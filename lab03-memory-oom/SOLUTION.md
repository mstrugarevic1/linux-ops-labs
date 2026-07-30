# Lab03 Solution

## Root Cause

`app.py` appends 1 MiB objects forever. The container has `mem_limit: 96m`, so the process is killed by the container memory limit.

`max_rss` in the logs comes from `resource.getrusage().ru_maxrss`. It is the maximum resident set size seen so far, not necessarily current RSS.

## Before OOM Investigation

```sh
make lab03-shell
ps -o pid,rss,vsz,comm,args
cat /sys/fs/cgroup/memory.max 2>/dev/null || cat /sys/fs/cgroup/memory/memory.limit_in_bytes
cat /sys/fs/cgroup/memory.current 2>/dev/null || cat /sys/fs/cgroup/memory/memory.usage_in_bytes
```

Expected observations: process RSS rises, cgroup memory usage approaches the configured limit, and app logs show increasing allocation count.

## After OOM Investigation

```sh
docker compose -f lab03-memory-oom/compose.yaml ps -a
docker inspect lab03-memory-oom-app-1 --format '{{.State.OOMKilled}} {{.State.ExitCode}}'
docker compose -f lab03-memory-oom/compose.yaml logs --tail=20
```

Expected observation: exit code `137`. On native Linux Docker, `OOMKilled` is commonly `true`; Docker Desktop may report `false` even when the cgroup limit caused a SIGKILL, so correlate the exit code with allocation logs and the configured memory limit.

Cgroup file names differ by host:

- cgroup v2: `memory.current`, `memory.max`
- cgroup v1: `memory.usage_in_bytes`, `memory.limit_in_bytes`

## Fix

```sh
make lab03-fix
make lab03-clean
make lab03-start
```

The patch keeps only the newest eight chunks.

## Verify

Logs should stabilize around a small allocation count, and the container should keep running.

## Production Relevance

Container OOM kills often look like sudden process exits unless you inspect container state and cgroup limits.
