# Lab09: TCP Connection Churn

## Scenario

A client becomes unreliable while making many short-lived TCP connections to a healthy local service.

## User Impact

Some requests fail even though the server process is running and accepting connections.

## Initial Symptoms

Run the following commands from this lab directory.

See the [repository-level Makefile](../Makefile) for the available targets.

```sh
make -C .. lab09-start
make -C .. lab09-logs
curl -s http://localhost:8009/health
```

## Investigation Goals

- Confirm the server is healthy.
- Observe client connection failures.
- Inspect active and recently closed TCP sockets.
- Explain why excessive short-lived connections can exhaust available client-side ports.

## Useful Commands

```sh
docker compose -f lab09-tcp-port-exhaustion/compose.yaml ps
make -C .. lab09-shell
cat /proc/net/tcp
cat /proc/sys/net/ipv4/ip_local_port_range
```

## Hints

1. The lab uses a deliberately tiny client-side source port pool to stay safe.
2. Some ports are held open so the small pool is exhausted deterministically.
3. Look for repeated local ports and connection states in `/proc/net/tcp`.
4. Compare the client behavior with kernel-selected ephemeral ports.

## Cleanup

```sh
make -C .. lab09-clean
```
