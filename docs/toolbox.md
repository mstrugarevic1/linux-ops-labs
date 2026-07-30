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
