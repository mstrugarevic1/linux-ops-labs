# Lab08: CPU Throttling

## Scenario

An internal HTTP service is technically up, but requests become slow and inconsistent while the container is doing CPU-heavy work.

## User Impact

Health checks may pass, but user-facing work requests have poor and variable latency.

## Initial Symptoms

Run the following commands from the repository root.

See the [repository-level Makefile](../Makefile) for the available targets.

```sh
make lab08-start
curl -s http://localhost:8008/health
time curl -s http://localhost:8008/work
make lab08-logs
```

## Investigation Goals

- Confirm the service is running.
- Check whether container CPU usage is high.
- Inspect the container CPU quota.
- Check cgroup CPU throttling counters where available.
- Compare latency before and after the fix.

## Useful Commands

```sh
docker compose -f lab08-cpu-throttling/compose.yaml ps
docker stats --no-stream
make lab08-shell
cat /sys/fs/cgroup/cpu.stat
cat /sys/fs/cgroup/cpu.max 2>/dev/null || true
cat /proc/1/stat
```

## Hints

1. Compare `/health` and `/work` latency.
2. Look for cgroup v2 counters such as `nr_throttled` and `throttled_usec`.
3. Inspect the Compose CPU limit before changing application code.
4. If `top` or `ps` exists in your runtime, use it inside the container; otherwise `/proc` is enough.

## Cleanup

```sh
make lab08-clean
```
