# Lab04: Disk, Inodes, Deleted-Open File

## Scenario

This lab contains three independent filesystem incidents. Run only one scenario at a time so the evidence stays clear.

## User Impact

Applications may fail writes, create no new files, or report confusing disk usage after files were deleted.

## Initial Symptoms

Start one scenario:

```sh
make lab04-disk
make lab04-inodes
make lab04-deleted-file
```

Then inspect the matching service:

```sh
make lab04-logs
make lab04-shell SERVICE=disk
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
make lab04-clean
```
