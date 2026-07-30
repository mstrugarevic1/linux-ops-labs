# Lab08 Solution

## Root Cause

The service runs CPU-heavy work inside a container limited to `0.25` CPU. A background CPU loop plus `/work` requests can consume the small quota quickly, so the cgroup throttles execution and request latency becomes inconsistent.

## Walkthrough

Start the lab and confirm the service is up:

```sh
make lab08-start
docker compose -f lab08-cpu-throttling/compose.yaml ps
curl -s http://localhost:8008/health
```

Measure request latency:

```sh
time curl -s http://localhost:8008/work
for i in 1 2 3 4 5; do time curl -s http://localhost:8008/work >/dev/null; done
```

Check CPU usage from the host:

```sh
docker stats --no-stream
```

Inspect the container:

```sh
docker compose -f lab08-cpu-throttling/compose.yaml exec app sh
cat /sys/fs/cgroup/cpu.stat
cat /sys/fs/cgroup/cpu.max 2>/dev/null || true
cat /proc/1/stat
top
ps
```

On cgroup v2, `cpu.stat` commonly includes `nr_periods`, `nr_throttled`, and `throttled_usec`. Rising throttling counters while `/work` is slow is the key evidence. `cpu.max` shows quota and period; for this lab it should reflect a low quota.

`top` or `ps` may not exist in minimal images. If they are missing, use `/proc` and Docker-level commands.

## Fix

Apply the patch:

```sh
make lab08-fix
make lab08-clean
make lab08-start
```

The patch raises the CPU allocation from `0.25` to `1.0` CPU. A production fix could also reduce CPU-heavy work, move it off the request path, or tune worker concurrency.

## Verification

Run the same checks again:

```sh
curl -s http://localhost:8008/health
for i in 1 2 3 4 5; do time curl -s http://localhost:8008/work >/dev/null; done
docker compose -f lab08-cpu-throttling/compose.yaml exec app cat /sys/fs/cgroup/cpu.stat
docker stats --no-stream
```

Expected observations:

- `/health` remains healthy.
- `/work` latency improves or becomes less variable.
- `nr_throttled` and `throttled_usec` grow more slowly under the same request pattern.

## Production Relevance

CPU throttling can make a service look healthy but slow. It is common when CPU limits are much lower than the work the service performs.
