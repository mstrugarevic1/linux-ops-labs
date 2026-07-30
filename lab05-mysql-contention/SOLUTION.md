# Lab05 Solution

## Root Cause

The workload creates one transaction that updates `counters.id=1` and sleeps without committing. Four more transactions try to update the same row and wait. Then the workload opens sleeping sessions until the `app` user's `MAX_USER_CONNECTIONS 16` limit is reached, and extra connection attempts fail.

## Walkthrough

```sh
make lab05-db
```

Useful manual queries:

```sh
docker compose -f lab05-mysql-contention/compose.yaml exec db mysql -uadmin -plab -e "
SELECT id,user,db,command,time,state,info
FROM information_schema.processlist
WHERE user IN ('app','admin')
ORDER BY id;
SHOW STATUS LIKE 'Threads_connected';
SHOW VARIABLES LIKE 'max_connections';
SELECT user, max_user_connections FROM mysql.user WHERE user IN ('app','admin');
"
```

Lock waits, where available:

```sh
docker compose -f lab05-mysql-contention/compose.yaml exec db mysql -uadmin -plab -e "
SELECT * FROM performance_schema.data_lock_waits\G
" || echo "data_lock_waits unavailable on this MySQL/MariaDB variant"
```

InnoDB detail:

```sh
docker compose -f lab05-mysql-contention/compose.yaml exec db mysql -uadmin -plab -e "SHOW ENGINE INNODB STATUS\G"
```

Expected observations: one active transaction owns a row lock, several `app` sessions wait or time out on the same row, and logs show labeled expected connection failures with MySQL error 1226.

## Fix

```sh
make lab05-fix
make lab05-clean
make lab05-start
```

The patch commits the lock-holder before the long sleep, so waiters are not blocked by an idle transaction.

## Verify

`information_schema.processlist` should show sleepers but no long-held row-lock transaction. Connection limit failures may still occur if enough sleepers are opened.

## Production Relevance

Connection exhaustion and lock contention often reinforce each other: blocked transactions hold sessions, and exhausted pools prevent investigation or recovery work.
