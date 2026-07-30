# linux-troubleshooting-labs

Minimal Linux troubleshooting labs for interview prep and practical DevOps/SRE practice.

Each lab creates one bounded failure, runs with Docker Compose, and uses standard Linux tools for investigation. Start with one `make` command, inspect symptoms, apply the small fix where provided, verify, then clean up.

## Requirements

- Docker
- Docker Compose v2
- `make`

## Labs

| Lab | Scenario | Start | Clean |
| --- | --- | --- | --- |
| 01 | File descriptor leak | `make lab01-start` | `make lab01-clean` |
| 02 | Synchronous I/O backlog | `make lab02-start` | `make lab02-clean` |
| 03 | Memory leak / OOM | `make lab03-start` | `make lab03-clean` |
| 04 | Disk full, inode pressure, deleted-open-file | `make lab04-start` | `make lab04-clean` |
| 05 | MySQL connection exhaustion and row lock contention | `make lab05-start` | `make lab05-clean` |
| 06 | Retry storm | `make lab06-start` | `make lab06-clean` |

Use `make labNN-logs` for logs and `make labNN-shell` for a shell. Labs with code fixes also have `make labNN-fix` and `make labNN-reset`.

## Lab01: File Descriptor Leak

Symptom:

```sh
make lab01-start
make lab01-logs
curl -s http://localhost:8001/fds
```

Investigate:

```sh
make lab01-shell
cat /proc/1/limits | grep "open files"
ls /proc/1/fd | wc -l
lsof -p 1 | tail
```

Root cause: `lab01-fd-leak/app.py` keeps every opened file object in `leaked_files`, so descriptors remain open until the process hits Docker's `nofile=64` limit.

Fix:

```sh
make lab01-fix
make lab01-clean
make lab01-start
```

Verify: `/fds` stays low and logs no longer show `OSError: [Errno 24] Too many open files`.

## Lab02: Synchronous I/O Backlog

Symptom:

```sh
make lab02-start
make lab02-logs
```

Investigate:

```sh
make lab02-shell
cat /proc/loadavg
ps -eo pid,stat,comm,args
pidstat -d 1
df -h /data
```

Root cause: `lab02-blocked-io/app.py` starts several `dd` writers using `oflag=sync`, forcing every small write to wait for storage.

Fix:

```sh
make lab02-fix
make lab02-clean
make lab02-start
```

Verify: only one writer runs and `pidstat -d 1` shows much lower write pressure.

## Lab03: Memory Leak / OOM

Symptom:

```sh
make lab03-start
make lab03-logs
docker compose -f lab03-memory-oom/compose.yaml ps
```

Investigate:

```sh
make lab03-shell
cat /sys/fs/cgroup/memory.max
cat /sys/fs/cgroup/memory.current
ps -o pid,rss,comm,args
```

Root cause: `lab03-memory-oom/app.py` appends 1 MiB objects forever. The container has `mem_limit: 96m`, so it is eventually killed.

Fix:

```sh
make lab03-fix
make lab03-clean
make lab03-start
```

Verify: memory stabilizes because the list keeps only the latest eight chunks.

## Lab04: Disk, Inodes, Deleted-Open File

Symptom:

```sh
make lab04-start
make lab04-logs
```

Investigate:

```sh
make lab04-shell
df -h /data
df -i /data
find /data/files -type f | wc -l
for p in /proc/[0-9]*; do for fd in "$p"/fd/*; do readlink "$fd" 2>/dev/null; done; done | grep deleted
```

Root cause: `lab04-disk-inodes/scripts.sh` writes many tiny files into a 16 MiB tmpfs and starts `tail -f` on a file that is deleted while still open. Space remains charged until the holding process exits.

Fix: stop the holder and remove generated files.

```sh
make lab04-clean
```

Verify: the tmpfs disappears with the container.

## Lab05: MySQL Connections and Locks

Symptom:

```sh
make lab05-start
make lab05-logs
make lab05-db
```

Investigate:

```sh
make lab05-db
make lab05-shell
ps -eo pid,stat,comm,args
```

Root cause: `lab05-mysql-contention/app.py` opens many sleeping MySQL sessions as an `app` user capped with `MAX_USER_CONNECTIONS 16`, then holds a transaction open while other updates wait on the same row.

Fix:

```sh
make lab05-fix
make lab05-clean
make lab05-start
```

Verify: `SHOW PROCESSLIST` has fewer sleepers and the row lock is committed before the long sleep.

## Lab06: Retry Storm

Symptom:

```sh
make lab06-start
curl -s http://localhost:8006/stats
```

Investigate:

```sh
make lab06-shell
ps -o pid,stat,comm,args
curl -s http://server:8000/stats
```

Root cause: `lab06-retry-storm/client.py` starts 16 threads that retry immediately on every 503, amplifying a small outage into high request volume.

Fix:

```sh
make lab06-fix
make lab06-clean
make lab06-start
```

Verify: `/stats` shows much lower RPS because clients back off and use fewer threads.
