# linux-troubleshooting-labs

Practical Linux troubleshooting labs for DevOps/SRE interview preparation.

These labs inspect Linux behavior inside Docker containers, not the host OS. On Docker Desktop for macOS, the Linux containers run inside a VM, so host tools and container tools may report different views. Cgroup paths and files may also vary between cgroup v1 and v2.

The labs are intentionally broken. Run them only on a local developer machine with Docker Compose v2.

## Requirements

- Docker
- Docker Compose v2
- `make`

## Labs

| Lab | Failure mode | Primary tools | Difficulty |
| --- | --- | --- | --- |
| 01 | File descriptor leak | `lsof`, `/proc`, `curl` | Medium |
| 02 | Synchronous I/O pressure | `iostat`, `pidstat`, `vmstat`, `/proc/<pid>/io` | Medium |
| 03 | Memory leak / OOM kill | `ps`, cgroups, `docker inspect`, logs | Medium |
| 04 | Disk full, inode exhaustion, deleted-open file | `df`, `find`, `/proc/*/fd` | Medium |
| 05 | MySQL row locks and connection exhaustion | `processlist`, `performance_schema`, InnoDB status | Hard |
| 06 | Retry storm | `curl`, `ps`, service counters | Medium |

Start with the lab README, then check `SOLUTION.md` when you want the walkthrough.

```sh
make help
```

## Maintainer Notes

Suggested GitHub description:

```text
Minimal Docker-based Linux troubleshooting labs for DevOps/SRE practice and interviews.
```

Suggested topics:

```text
linux troubleshooting devops sre docker observability interview-preparation
```
