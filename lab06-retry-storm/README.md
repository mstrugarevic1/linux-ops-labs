# Lab06: Retry Storm

## Scenario

A client retries immediately against a server that returns 503.

## Start

```sh
make lab06-start
```

## Symptoms

```sh
curl -s http://localhost:8006/stats
make lab06-shell
ps -o pid,stat,comm,args
```

## Investigation Goals

- Measure request rate.
- Inspect the retrying client.
- Explain why a failing dependency receives more traffic.

## Hints

1. Compare `/stats` over time.
2. Read `client.py`.
3. Look for retry delay or backoff.

## Cleanup

```sh
make lab06-clean
```
