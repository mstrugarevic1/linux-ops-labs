#!/bin/sh
set -u

mkdir -p /data/files

dd if=/dev/zero of=/data/deleted-open.log bs=1M count=8 status=none
tail -f /data/deleted-open.log >/dev/null &
rm /data/deleted-open.log

i=0
while :; do
  mkdir -p "/data/files/$i"
  j=0
  while [ "$j" -lt 200 ]; do
    printf x >"/data/files/$i/$j" || break 2
    j=$((j + 1))
  done
  i=$((i + 1))
  df -h /data
  df -i /data
  sleep 1
done

echo "write failed; container left running for investigation"
sleep infinity
