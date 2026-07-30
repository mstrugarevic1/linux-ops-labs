# Lab06: Retry Storm

## Scenario

A client-facing dependency is unhealthy, and local client traffic surges instead of backing off.

## User Impact

The failing service receives amplified load, making recovery harder and obscuring the original failure.

## Initial Symptoms

```sh
make lab06-start
curl -s http://localhost:8006/stats
make lab06-shell
```

## Investigation Goals

- Measure request rate.
- Inspect the retrying client process.
- Explain why a failing dependency receives more traffic.
- Verify whether retries have delay or backoff.

## Useful Commands

```sh
curl -s http://localhost:8006/stats
ps -o pid,stat,comm,args
sed -n '1,200p' client.py
```

## Cleanup

```sh
make lab06-clean
```
