# Lab03: Memory Leak / OOM

## Scenario

A container exits after rapid memory growth. Investigate what can be observed before the kill and what evidence remains afterward.

## User Impact

The service disappears abruptly and may restart depending on the runtime policy.

## Initial Symptoms

Run the following commands from this lab directory.

See the [repository-level Makefile](../Makefile) for the available targets.

```sh
make -C .. lab03-start
make -C .. lab03-logs
docker compose -f lab03-memory-oom/compose.yaml ps -a
```

## Investigation Goals

- Before termination, compare process RSS with cgroup memory usage.
- After termination, inspect exit code, OOM state, and recent logs.
- Distinguish current RSS from maximum resident set size reported by the app.
- Note Docker Desktop versus native Linux cgroup reporting differences.

## Useful Commands

```sh
make -C .. lab03-shell
ps -o pid,rss,vsz,comm,args
cat /sys/fs/cgroup/memory.current 2>/dev/null || cat /sys/fs/cgroup/memory/memory.usage_in_bytes
cat /sys/fs/cgroup/memory.max 2>/dev/null || cat /sys/fs/cgroup/memory/memory.limit_in_bytes
docker inspect lab03-memory-oom-app-1 --format '{{.State.OOMKilled}} {{.State.ExitCode}}'
```

## Cleanup

```sh
make -C .. lab03-clean
```
