# Lab04: Disk, Inodes, Deleted-Open File

## Scenario

This lab contains three independent filesystem incidents. Run only one scenario at a time so the evidence stays clear.

## User Impact

Applications may fail writes, create no new files, or report confusing disk usage after files were deleted.

## Initial Symptoms

Run the following commands from this lab directory.

See the [repository-level Makefile](../Makefile) for the available targets.

Start one scenario:

```sh
make -C .. lab04-disk
make -C .. lab04-inodes
make -C .. lab04-deleted-file
```

Then inspect the matching service:

```sh
make -C .. lab04-logs
make -C .. lab04-shell SERVICE=disk
```

Use `SERVICE=inodes` or `SERVICE=deleted-file` for the scenario you started.

## Investigation Goals

- Disk full: prove `/data` has no free bytes.
- Inode exhaustion: prove `/data` has no free inodes.
- Deleted-open file: find a deleted path still held open by a process.
- Verify each scenario independently.

## Useful Commands

```sh
df -h /data
du -sh /data
df -i /data
find /data -type f | wc -l
for p in /proc/[0-9]*; do for fd in "$p"/fd/*; do readlink "$fd" 2>/dev/null; done; done | grep deleted
```

## Cleanup

```sh
make -C .. lab04-clean
```
