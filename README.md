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

Use the same workflow for most labs:

```sh
make labNN-start
make labNN-logs
make labNN-shell
make labNN-clean
```

Each lab contains a `README.md` with the scenario and a `SOLUTION.md` with the walkthrough and fix.

## Lab Catalog

| Lab | Incident |
| --- | --- |
| [01 — File Descriptor Leak](./lab01-fd-leak) | HTTP service becomes unreliable under light traffic |
| [02 — Blocked I/O](./lab02-blocked-io) | Worker service causes sustained local write pressure |
| [03 — Memory OOM](./lab03-memory-oom) | Container exits after rapid memory growth |
| [04 — Disk and Inodes](./lab04-disk-inodes) | Filesystem incidents: full disk, inode exhaustion, deleted-open file |
| [05 — MySQL Contention](./lab05-mysql-contention) | MySQL workload becomes blocked and rejects application sessions |
| [06 — Retry Storm](./lab06-retry-storm) | Client traffic surges while a dependency is unhealthy |
| [08 — CPU Throttling](./lab08-cpu-throttling) | HTTP service is up but request latency becomes inconsistent |

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
