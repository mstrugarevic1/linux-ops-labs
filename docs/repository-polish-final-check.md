# Repository Polish Final Check

## Lab08 CPU Throttling Addendum

### Lab08 Files Added

- `lab08-cpu-throttling/README.md`
- `lab08-cpu-throttling/SOLUTION.md`
- `lab08-cpu-throttling/compose.yaml`
- `lab08-cpu-throttling/app.py`
- `lab08-cpu-throttling/fix.patch`

### Lab08 Files Changed

- `Makefile`
- `README.md`
- `docs/repository-polish-final-check.md`

### Lab08 What Improved

- Added a safe local Docker Compose lab for CPU throttling.
- Workload uses only the Python standard library and the stock `python:3.12-slim` image.
- Container is bounded with `cpus: 0.25`, `mem_limit: 128m`, and `pids_limit: 64`.
- `/health` confirms the service is up.
- `/work` performs bounded CPU work.
- `SOLUTION.md` documents Docker status, Docker stats, cgroup `cpu.stat`, cgroup v2 notes, `/proc`, optional `top`/`ps`, latency checks, fix, and verification.
- `fix.patch` raises the CPU allocation to `1.0` CPU.

### Lab08 Validation Commands Run

- `make help` - passed.
- `make smoke` - passed.
- `docker compose -f lab08-cpu-throttling/compose.yaml config` - passed with broken lab state restored to `cpus: 0.25`.
- `git apply --check lab08-cpu-throttling/fix.patch` - passed.
- `git apply lab08-cpu-throttling/fix.patch` - passed.
- `git apply -R --check lab08-cpu-throttling/fix.patch` - passed.
- `git apply -R lab08-cpu-throttling/fix.patch` - passed.
- `make lab08-clean` - passed before runtime validation.
- `make lab08-start` - passed.
- `docker compose -f lab08-cpu-throttling/compose.yaml ps` - passed; app container was running on port `8008`.
- `curl -s http://localhost:8008/health` - passed, returned `{"status": "ok"}`.
- `curl -s http://localhost:8008/work` - passed, returned bounded work result with about `1118.3` ms app-reported elapsed time.
- `docker compose -f lab08-cpu-throttling/compose.yaml logs --tail=20` - passed.
- `make lab08-logs` - produced expected logs; interrupted intentionally because the target follows logs.
- `docker compose -f lab08-cpu-throttling/compose.yaml exec app cat /sys/fs/cgroup/cpu.stat` - passed and showed throttling counters including `nr_throttled`.
- `make lab08-clean` - passed after runtime validation.
- `make lab08-fix` - passed.
- `make lab08-reset` - passed and restored the broken lab state.
- `git diff --check` - passed.

### Lab08 Remaining Limitations

- Exact `/work` latency and throttling counters vary by host, Docker runtime, and CPU scheduler.
- Minimal Python image may not include `top` or `ps`; the lab documents `/proc` and cgroup files as the reliable path.

### Lab08 Final Recommendation

Ready to commit.

## Files Changed

- `Makefile`
- `README.md`
- `lab01-fd-leak/README.md`
- `lab02-blocked-io/README.md`
- `lab02-blocked-io/SOLUTION.md`
- `lab03-memory-oom/README.md`
- `lab03-memory-oom/SOLUTION.md`
- `lab04-disk-inodes/README.md`
- `lab04-disk-inodes/SOLUTION.md`
- `lab05-mysql-contention/README.md`
- `lab05-mysql-contention/SOLUTION.md`
- `lab06-retry-storm/README.md`

## Files Added

- `docs/toolbox.md`
- `docs/repository-polish-final-check.md`

## Files Removed

- None.

## What Improved

- Root README is now an incident catalog instead of a solution summary.
- Lab READMEs use a consistent incident format: scenario, user impact, symptoms, goals, commands, cleanup.
- Lab02 docs now emphasize bounded synchronous write pressure and practical observation commands.
- Lab03 docs now split pre-OOM and post-OOM investigation and clarify `ru_maxrss`.
- Lab04 docs now present disk full, inode exhaustion, and deleted-open file as independent scenarios.
- Lab05 docs now call out row locks, app-user connection exhaustion, and separate admin observation.
- Lab05 workload statically follows the requested order: lock holder, lock waiters, sleeping app sessions, expected connection failures.
- Added a short symptom-to-tool mapping in `docs/toolbox.md`.
- Added minimal global Make targets for help, smoke, and cleanup.

## Root README Solution Leak Check

- Checked with `rg` for explicit solution/root-cause terms.
- No root-cause walkthroughs or fixes are present in `README.md`.

## Runnable Lab Check

- Docker Compose is installed: `docker compose version` reported `Docker Compose version v5.1.4`.
- Representative Lab01 runtime validation passed with escalated Docker access.
- Lab01 containers started, finite logs showed traffic, `/health` returned `ok`, and cleanup removed containers and the lab network.

## Validation Commands Run

- `make help` - passed.
- `make smoke` - passed.
- `docker compose -f lab01-fd-leak/compose.yaml config` - passed.
- `docker compose -f lab02-blocked-io/compose.yaml config` - passed.
- `docker compose -f lab03-memory-oom/compose.yaml config` - passed.
- `docker compose -f lab04-disk-inodes/compose.yaml config` - passed.
- `docker compose -f lab05-mysql-contention/compose.yaml config` - passed.
- `docker compose -f lab06-retry-storm/compose.yaml config` - passed.
- `make lab01-clean` - passed with escalated Docker access.
- `make lab01-start` - passed with escalated Docker access.
- `docker compose -f lab01-fd-leak/compose.yaml ps` - passed.
- `docker compose -f lab01-fd-leak/compose.yaml logs --tail=20` - passed.
- `curl -s http://localhost:8001/health` - passed, returned `ok`.
- `make lab01-clean` - passed after runtime validation.
- `git apply --check lab01-fd-leak/fix.patch` - passed.
- `git apply lab01-fd-leak/fix.patch` - passed.
- `git apply -R --check lab01-fd-leak/fix.patch` - passed.
- `git apply -R lab01-fd-leak/fix.patch` - passed.
- `git apply --check lab02-blocked-io/fix.patch` - passed.
- `git apply lab02-blocked-io/fix.patch` - passed.
- `git apply -R --check lab02-blocked-io/fix.patch` - passed.
- `git apply -R lab02-blocked-io/fix.patch` - passed.
- `git apply --check lab03-memory-oom/fix.patch` - passed.
- `git apply lab03-memory-oom/fix.patch` - passed.
- `git apply -R --check lab03-memory-oom/fix.patch` - passed.
- `git apply -R lab03-memory-oom/fix.patch` - passed.
- `git apply --check lab05-mysql-contention/fix.patch` - passed.
- `git apply lab05-mysql-contention/fix.patch` - passed.
- `git apply -R --check lab05-mysql-contention/fix.patch` - passed.
- `git apply -R lab05-mysql-contention/fix.patch` - passed.
- `git apply --check lab06-retry-storm/fix.patch` - passed.
- `git apply lab06-retry-storm/fix.patch` - passed.
- `git apply -R --check lab06-retry-storm/fix.patch` - passed.
- `git apply -R lab06-retry-storm/fix.patch` - passed.
- `rg ... README.md` spoiler scan - passed with no matches.
- `git diff --check` - passed.

## Remaining Limitations

- Lab05 depends on MySQL `performance_schema.data_lock_waits`; the solution includes a fallback when unavailable.
- Docker Desktop and native Linux may report cgroup and OOM state differently.

## Final Recommendation

Ready to commit.
