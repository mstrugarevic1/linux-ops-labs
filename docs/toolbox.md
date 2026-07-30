# Troubleshooting Toolbox

| Symptom | Useful tools |
| --- | --- |
| Too many open files | `lsof`, `/proc/<pid>/fd`, `/proc/<pid>/limits` |
| Disk full | `df -h`, `du -sh`, `find` |
| Inode exhaustion | `df -i`, `find`, `stat` |
| Deleted file still using space | `lsof +L1`, `/proc/<pid>/fd`, `readlink` |
| Memory pressure or OOM | `ps`, `/proc/<pid>/status`, cgroup files, `docker inspect` |
| I/O pressure | `vmstat`, `iostat`, `pidstat -d`, `/proc/<pid>/io` |
| Connection exhaustion | `information_schema.processlist`, service logs, connection counters |
| Database lock waits | `performance_schema.data_lock_waits`, `SHOW ENGINE INNODB STATUS` |
| Retry storm | request counters, logs, `ps`, client retry configuration |
| DNS resolution failure | `getent hosts`, `nslookup` when available, `/etc/resolv.conf`, Python `socket.gethostbyname` |
| TCP connection churn | `/proc/net/tcp`, `ss` when available, `/proc/sys/net/ipv4/ip_local_port_range` |
