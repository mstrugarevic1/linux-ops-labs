# Lab02: Synchronous I/O Pressure

## Scenario

Several workers continuously write to disk using synchronous writes.

## Start

```sh
make lab02-start
```

## Symptoms

```sh
make lab02-logs
make lab02-shell
```

## Investigation Goals

- Identify writer processes.
- Compare process states.
- Measure per-process write pressure.
- Inspect the writer's `/proc/<pid>/io`.

## Hints

1. Start with `ps -eo pid,stat,comm,args`.
2. Use `pidstat -d 1` and `iostat 1` if available.
3. Pick one `dd` PID and inspect `/proc/<pid>/io`.

## Cleanup

```sh
make lab02-clean
```
