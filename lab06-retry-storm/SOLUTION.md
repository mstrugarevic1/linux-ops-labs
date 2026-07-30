# Lab06 Solution

## Root Cause

`client.py` starts 16 threads that retry immediately after each failed request. The server returns 503, so clients loop as fast as Python and the local network allow.

## Walkthrough

```sh
make lab06-start
curl -s http://localhost:8006/stats
make lab06-shell
ps -o pid,stat,comm,args
```

Expected observation: `/stats` shows a high request rate for a tiny local service.

## Fix

```sh
make lab06-fix
make lab06-clean
make lab06-start
```

The patch reduces threads and adds a short sleep after failures.

## Verify

```sh
curl -s http://localhost:8006/stats
```

RPS should be lower than the broken version. Exact values depend on the host.

## Production Relevance

Retry storms can turn a small outage into a larger one unless clients use backoff, jitter, and budgets.
