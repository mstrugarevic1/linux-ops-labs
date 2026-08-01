# Lab02: Synchronous I/O Pressure

## Scenario

A worker container becomes latency-heavy while doing local file writes. The workload is bounded, but it is designed to create visible synchronous write pressure.

## User Impact

The service appears alive but spends much of its time waiting on storage.

## Initial Symptoms

Run the following commands from the repository root.

See the [repository-level Makefile](../Makefile) for the available targets.

```sh
make lab02-start
make lab02-logs
make lab02-shell
```

## Investigation Goals

- Identify the writer processes.
- Compare process states and system wait behavior.
- Measure per-process write pressure.
- Inspect `/proc/<pid>/io` for a writer process.

## Useful Commands

```sh
ps -eo pid,stat,comm,args
vmstat 1
pidstat -d 1
iostat 1
cat /proc/<pid>/io
```

`pidstat` and `iostat` may not be installed in every base image. `/proc/<pid>/io`, `ps`, and `vmstat` are enough to continue.

## Cleanup

```sh
make lab02-clean
```
