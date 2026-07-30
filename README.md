# linux-troubleshooting-labs

Minimal Linux troubleshooting labs for interview prep and practical DevOps/SRE practice.

This repository is intentionally small. Each lab creates one observable failure, keeps resource usage bounded, and uses standard Linux tools for investigation.

Only Lab01 is implemented.

## Requirements

- Docker
- Docker Compose v2
- `make`

## Lab01: File Descriptor Leak

Scenario: a Python HTTP service opens a file on every request and never closes it. Docker limits the process to 64 open files, so the leak becomes visible quickly without risking the host.

Start:

```sh
make lab01-start
```

Watch symptoms:

```sh
make lab01-logs
curl -s http://localhost:8001/health
curl -s http://localhost:8001/fds
```

Investigate inside the container:

```sh
make lab01-shell
cat /proc/1/limits | grep "open files"
ls /proc/1/fd | wc -l
lsof -p 1 | tail
```

Expected symptoms:

- request failures in the load generator;
- `OSError: [Errno 24] Too many open files` in logs;
- `/proc/1/fd` grows toward the configured limit;
- many descriptors point at `/tmp/lab01-data.txt`.

Root cause:

`lab01-fd-leak/app.py` keeps every opened file object in a global list:

```py
leaked_files.append(open(DATA_FILE))
```

Inspect the minimal fix:

```sh
make lab01-fix
```

The fix is to use a context manager so the descriptor closes after the read.

Verify after applying the patch:

```sh
make lab01-clean
make lab01-start
sleep 5
curl -s http://localhost:8001/fds
make lab01-logs
```

The descriptor count should stay low and the logs should not show `Too many open files`.

Clean up:

```sh
make lab01-clean
```
