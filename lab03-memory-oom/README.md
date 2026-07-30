# Lab03: Memory Leak / OOM

## Scenario

A Python process allocates memory until the container memory limit kills it.

## Start

```sh
make lab03-start
```

## Symptoms

```sh
make lab03-logs
docker compose -f lab03-memory-oom/compose.yaml ps -a
```

## Investigation Goals

- Before the kill, inspect process memory and cgroup usage.
- After the kill, inspect `OOMKilled`, exit code, and logs.
- Use logs to correlate allocation growth with termination.

## Hints

1. Enter quickly with `make lab03-shell`.
2. Check `ps -o pid,rss,comm,args`.
3. Check cgroup memory files under `/sys/fs/cgroup`.

## Cleanup

```sh
make lab03-clean
```
