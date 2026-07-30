# Lab05: MySQL Connections and Locks

## Scenario

A workload creates row-lock contention and then exhausts the `app` user's MySQL connection limit.

## Start

```sh
make lab05-start
```

## Symptoms

```sh
make lab05-logs
make lab05-db
```

## Investigation Goals

- Find the transaction holding the row lock.
- Find transactions waiting on that lock.
- Confirm app-user connection exhaustion.
- Inspect MySQL counters and configured limits.

## Hints

1. Query `information_schema.processlist`.
2. Try `performance_schema.data_lock_waits`.
3. Read `SHOW ENGINE INNODB STATUS`.
4. Compare active app sessions with `MAX_USER_CONNECTIONS`.

## Cleanup

```sh
make lab05-clean
```
