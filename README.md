# Linux Troubleshooting Labs

Practical, reproducible Linux troubleshooting scenarios for DevOps and SRE practice.

Each lab starts a deliberately broken workload inside Docker, exposes observable symptoms, and provides an investigation path using standard Linux and service-level diagnostic tools.

The goal is not only to apply a fix, but to identify the failure from evidence.

These labs inspect Linux behavior inside Docker containers, not the host OS. On Docker Desktop for macOS, the Linux containers run inside a VM, so host tools and container tools may report different views. Cgroup paths and files may also vary between cgroup v1 and v2.

The labs are intentionally broken. Run them only on a local developer machine with Docker Compose v2.

## What This Repository Demonstrates

- Linux process and resource troubleshooting
- Investigation through `/proc`
- File descriptor and filesystem analysis
- Memory and cgroup inspection
- Disk I/O diagnosis
- MySQL connection and lock investigation
- Retry, backoff, and failure amplification analysis
- Verification of a fix against the original symptoms

## Requirements

- Docker
- Docker Compose v2
- `make`
- `curl` for selected labs

Verify the environment:

```sh
docker --version
docker compose version
make --version
```

## Labs

| Lab | Scenario | Start | Clean |
| --- | --- | --- | --- |
| 01 | File descriptor leak | `make lab01-start` | `make lab01-clean` |
| 02 | Synchronous I/O pressure | `make lab02-start` | `make lab02-clean` |
| 03 | Memory leak / OOM kill | `make lab03-start` | `make lab03-clean` |
| 04 | Disk, inode, deleted-open-file scenarios | `make lab04-disk` | `make lab04-clean` |
| 05 | MySQL locks and connection exhaustion | `make lab05-start` | `make lab05-clean` |
| 06 | Retry storm | `make lab06-start` | `make lab06-clean` |

Start with the lab README, then check `SOLUTION.md` when you want the walkthrough.

```sh
make help
```
