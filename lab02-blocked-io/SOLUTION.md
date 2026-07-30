# Lab02 Solution

## Root Cause

The broken workload starts six loops of `dd ... oflag=sync`. Each worker writes 32 MiB in 64 KiB chunks and forces every chunk through synchronous write semantics, so the container creates sustained write pressure without needing a large data set.

## Walkthrough

```sh
make lab02-shell
ps -eo pid,stat,comm,args
vmstat 1
pidstat -d 1
iostat 1
cat /proc/<dd-pid>/io
```

Expected observations:

- `ps` shows multiple `dd` children under the Python process.
- `vmstat 1` may show I/O wait or blocked processes depending on the host.
- `pidstat -d 1` shows per-process write throughput when available.
- `iostat 1` shows device-level write activity when available.
- `/proc/<pid>/io` shows increasing `write_bytes` for an active writer.

Exact values depend on Docker Desktop, filesystem, and host storage. If `pidstat` or `iostat` is missing, use `ps`, `vmstat`, and `/proc/<pid>/io`.

## Fix

```sh
make lab02-fix
make lab02-clean
make lab02-start
```

The fixed workload uses one writer, writes a 32 MiB batch, flushes once with `conv=fdatasync`, then sleeps for two seconds.

## Verify

Run the same commands and compare relative behavior. You should see fewer writer processes and lower sustained write pressure.

## Production Relevance

Small synchronous writes can make services appear CPU-light but latency-heavy because work waits on storage.
