# Lab05: MySQL Connections and Locks

## Scenario

An internal MySQL-backed job becomes blocked, then new application sessions begin failing. Observer access should still work while the application user is exhausted.

## User Impact

Requests depending on the application database user hang or fail, while database administration may still be possible through a separate account.

## Initial Symptoms

Run the following commands from this lab directory.

See the [repository-level Makefile](../Makefile) for the available targets.

```sh
make -C .. lab05-start
make -C .. lab05-logs
make -C .. lab05-db
```

## Investigation Goals

- Find sessions blocked on a row.
- Identify the session holding the lock.
- Confirm application-user connection exhaustion.
- Compare global connection count with per-user connection limits.

## Useful Commands

```sh
make -C .. lab05-db
docker compose -f lab05-mysql-contention/compose.yaml exec db mysql -uadmin -plab -e "SELECT id,user,db,command,time,state,info FROM information_schema.processlist ORDER BY id"
docker compose -f lab05-mysql-contention/compose.yaml exec db mysql -uadmin -plab -e "SHOW ENGINE INNODB STATUS\G"
```

## Cleanup

```sh
make -C .. lab05-clean
```
