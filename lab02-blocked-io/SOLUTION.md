# Lab02 Solution

## Root Cause

The broken workload starts six loops of `dd ... oflag=sync`, forcing each small write to wait on storage.

## Walkthrough

```sh
make lab02-shell
ps -eo pid,stat,comm,args
vmstat 1
pidstat -d 1
iostat 1
cat /proc/<dd-pid>/io
```

Expected observation: multiple active `dd` processes and sustained write pressure. Exact values depend on Docker Desktop, filesystem, and host storage.

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
