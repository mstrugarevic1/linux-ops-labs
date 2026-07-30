# Lab04 Solution

## Root Causes

- `disk`: fills a 16 MiB tmpfs with 1 MiB files.
- `inodes`: creates tiny files on a tmpfs capped at 4096 inodes.
- `deleted-file`: opens a file on shell fd 3, then deletes the path while the descriptor remains open.

## Disk Walkthrough

```sh
make lab04-disk
make lab04-shell SERVICE=disk
df -h /data
du -sh /data
```

Fix and verify:

```sh
make lab04-clean
```

## Inode Walkthrough

```sh
make lab04-inodes
make lab04-shell SERVICE=inodes
df -i /data
find /data/files -type f | wc -l
```

Fix and verify:

```sh
make lab04-clean
```

## Deleted-Open File Walkthrough

```sh
make lab04-deleted-file
make lab04-shell SERVICE=deleted-file
for p in /proc/[0-9]*; do for fd in "$p"/fd/*; do readlink "$fd" 2>/dev/null; done; done | grep deleted
df -h /data
```

Fix and verify:

```sh
make lab04-clean
```

## Production Relevance

Filesystem alerts can be caused by bytes, inode count, or deleted files held open by long-running processes.
