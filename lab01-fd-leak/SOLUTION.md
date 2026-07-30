# Lab01 Solution

## Root Cause

`app.py` opens `/tmp/lab01-data.txt` on every `/leak` request and stores the file object in `leaked_files`, so descriptors stay open until the container reaches `nofile=64`.

## Walkthrough

```sh
make lab01-shell
cat /proc/1/limits | grep "open files"
ls /proc/1/fd | wc -l
lsof -p 1 | tail
```

Expected observation: descriptor count grows and many descriptors point at `/tmp/lab01-data.txt`. Logs eventually show `OSError: [Errno 24] Too many open files`.

## Fix

```sh
make lab01-fix
make lab01-clean
make lab01-start
```

The patch uses a context manager so the file descriptor closes after each read.

## Verify

```sh
curl -s http://localhost:8001/fds
make lab01-logs
```

The descriptor count should stay low and logs should not show `Too many open files`.

## Production Relevance

FD leaks commonly break network clients, log readers, and services that open files or sockets without closing them.
