# Lab01: File Descriptor Leak

## Scenario

A small Python HTTP service becomes unreliable after enough traffic.

## Start

```sh
make lab01-start
```

## Symptoms

```sh
make lab01-logs
curl -s http://localhost:8001/health
curl -s http://localhost:8001/fds
```

## Investigation Goals

- Find the open-file limit for PID 1.
- Count open descriptors.
- Identify repeated descriptor targets.
- Explain why requests begin failing.

## Hints

1. Inspect `/proc/1/limits`.
2. Compare `ls /proc/1/fd | wc -l` over time.
3. Use `lsof -p 1`.

## Cleanup

```sh
make lab01-clean
```
