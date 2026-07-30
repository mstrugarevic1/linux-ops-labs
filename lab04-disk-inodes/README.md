# Lab04: Disk, Inodes, Deleted-Open File

## Scenario

This lab has three independent filesystem failures.

## Start One Scenario

```sh
make lab04-disk
make lab04-inodes
make lab04-deleted-file
```

Run one at a time.

## Investigation Goals

- Disk: prove `/data` has no free space.
- Inodes: prove `/data` has no free inodes.
- Deleted file: find a deleted file still held open by a process.

## Hints

```sh
make lab04-shell SERVICE=disk
df -h /data
df -i /data
find /data -type f | wc -l
for p in /proc/[0-9]*; do for fd in "$p"/fd/*; do readlink "$fd" 2>/dev/null; done; done | grep deleted
```

Change `SERVICE=` to `inodes` or `deleted-file` for the scenario you started.

## Cleanup

```sh
make lab04-clean
```
