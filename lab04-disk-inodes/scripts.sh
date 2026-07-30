#!/bin/sh
set -eu

case "${1:-}" in
  disk)
    mkdir -p /data
    i=0
    while dd if=/dev/zero of="/data/fill-$i.bin" bs=1M count=1 status=none; do
      df -h /data
      i=$((i + 1))
      sleep 0.2
    done
    echo "disk scenario: /data is full; inspect df and files"
    sleep infinity
    ;;
  inodes)
    mkdir -p /data/files
    i=0
    while printf x >"/data/files/$i"; do
      if [ $((i % 100)) -eq 0 ]; then
        df -i /data
      fi
      i=$((i + 1))
    done
    echo "inode scenario: inode allocation failed; inspect df -i"
    sleep infinity
    ;;
  deleted-file)
    mkdir -p /data
    dd if=/dev/zero of=/data/deleted-open.log bs=1M count=8 status=none
    exec 3</data/deleted-open.log
    rm /data/deleted-open.log
    echo "deleted-file scenario: deleted file is still held open"
    sleep infinity
    ;;
  *)
    echo "usage: $0 disk|inodes|deleted-file" >&2
    exit 2
    ;;
esac
