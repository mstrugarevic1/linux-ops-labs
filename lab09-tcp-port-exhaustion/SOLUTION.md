# Lab09 Solution

## Root Cause

The client creates many short-lived TCP connections while binding each connection to one of only eight local source ports. The lab holds that tiny source-port pool open first, so later attempts to bind the same client-side ports fail with address-in-use errors.

This is a safe local approximation of client-side ephemeral port exhaustion. It does not try to exhaust the host's full ephemeral port range.

## Walkthrough

Check that the service is running:

```sh
docker compose -f lab09-tcp-port-exhaustion/compose.yaml ps
curl -s http://localhost:8009/health
```

Inspect client logs:

```sh
make lab09-logs
```

Expected observation: the server stays healthy while the client reports intermittent connection failures.

Inspect TCP state from the client container:

```sh
make lab09-shell
cat /proc/net/tcp
cat /proc/sys/net/ipv4/ip_local_port_range
```

The local port range in `/proc/sys/net/ipv4/ip_local_port_range` is much larger than this lab's deliberately tiny source port pool. The failures come from exhausting the small client pool, not from host-wide exhaustion.

## Fix

```sh
make lab09-fix
make lab09-clean
make lab09-start
```

The patch stops binding the client to the tiny source port pool and lets the kernel choose from the normal ephemeral range. A production fix would usually reuse connections, enable pooling, reduce churn, or tune concurrency.

## Verification

```sh
curl -s http://localhost:8009/health
make lab09-logs
make lab09-shell
cat /proc/net/tcp
```

Expected observations:

- The server remains healthy.
- Client failures drop or disappear under the same bounded workload.
- Connections use a broader set of local ports.

## Production Relevance

High connection churn can make clients unreliable even when the remote service is healthy. Checking socket state from the client namespace avoids blaming the server too early.
