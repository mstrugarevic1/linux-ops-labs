# Lab01: File Descriptor Leak

## Scenario

An internal HTTP service becomes unreliable after running under light traffic for a short time. Your task is to collect evidence before applying the fix.

## User Impact

Health checks and normal requests may begin failing even though the process is still running.

## Initial Symptoms

Run the following commands from this lab directory.

See the [repository-level Makefile](../Makefile) for the available targets.

```sh
make -C .. lab01-start
make -C .. lab01-logs
curl -s http://localhost:8001/health
curl -s http://localhost:8001/fds
```

## Investigation Goals

- Find the open-file limit for the service process.
- Count open descriptors over time.
- Identify repeated descriptor targets.
- Explain why requests eventually fail.

## Useful Commands

```sh
make -C .. lab01-shell
cat /proc/1/limits
ls /proc/1/fd | wc -l
lsof -p 1
```

## Cleanup

```sh
make -C .. lab01-clean
```
