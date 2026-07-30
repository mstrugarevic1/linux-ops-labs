# Linux Troubleshooting Labs

Local, Docker Compose based Linux troubleshooting labs for DevOps and SRE interview practice.

Each lab starts a small broken workload, gives you observable symptoms, and asks you to collect evidence with standard Linux or service diagnostic tools before reading the solution.

## What This Demonstrates

- Process, file descriptor, memory, filesystem, and I/O investigation
- `/proc` and cgroup inspection from inside containers
- MySQL lock and connection troubleshooting
- Retry and failure amplification analysis
- Verifying a fix against the original symptoms

These labs inspect Linux behavior inside Docker containers. On Docker Desktop for macOS, containers run inside a Linux VM, so host tools and container tools may show different views.

## Requirements

- Docker
- Docker Compose v2
- `make`
- `curl` for selected HTTP labs
- `python3` for `make smoke`

Check your environment:

```sh
docker --version
docker compose version
make --version
```

## Quick Start

```sh
make help
make lab01-start
make lab01-logs
make lab01-clean
```

Start with each lab's `README.md`. Open `SOLUTION.md` only when you want the walkthrough and fix.

## Lab Catalog

| Lab | Incident | Start | Docs |
| --- | --- | --- | --- |
| 01 | HTTP service becomes unreliable under light traffic | `make lab01-start` | [README](lab01-fd-leak/README.md), [solution](lab01-fd-leak/SOLUTION.md) |
| 02 | Worker service causes sustained local write pressure | `make lab02-start` | [README](lab02-blocked-io/README.md), [solution](lab02-blocked-io/SOLUTION.md) |
| 03 | Container exits after rapid memory growth | `make lab03-start` | [README](lab03-memory-oom/README.md), [solution](lab03-memory-oom/SOLUTION.md) |
| 04 | Filesystem incidents: full disk, inode exhaustion, deleted-open file | `make lab04-disk` | [README](lab04-disk-inodes/README.md), [solution](lab04-disk-inodes/SOLUTION.md) |
| 05 | MySQL workload becomes blocked and rejects application sessions | `make lab05-start` | [README](lab05-mysql-contention/README.md), [solution](lab05-mysql-contention/SOLUTION.md) |
| 06 | Client traffic surges while a dependency is unhealthy | `make lab06-start` | [README](lab06-retry-storm/README.md), [solution](lab06-retry-storm/SOLUTION.md) |

Useful tool mapping: [docs/toolbox.md](docs/toolbox.md).

## Lab Structure

Most labs contain:

- `README.md`: scenario, user impact, symptoms, goals, useful commands, cleanup
- `SOLUTION.md`: root cause, investigation walkthrough, fix, verification
- `fix.patch`: minimal patch for the broken workload, where applicable
- `compose.yaml`: local Docker Compose workload

## Safety And Cleanup

The labs intentionally consume local container resources. They are bounded, but run them on a developer machine and clean up when finished:

```sh
make clean-all
```

Lab04 has three independent scenarios. Run one Lab04 scenario at a time.
