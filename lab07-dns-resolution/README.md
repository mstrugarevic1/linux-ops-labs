# Lab07: DNS Resolution

## Scenario

An internal service cannot reach a dependency even though the dependency container is healthy and reachable by its service name.

## User Impact

Requests that depend on the upstream service fail before any application response is received.

## Initial Symptoms

Run the following commands from this lab directory.

See the [repository-level Makefile](../Makefile) for the available targets.

```sh
make -C .. lab07-start
make -C .. lab07-logs
curl -s http://localhost:8007/health
```

## Investigation Goals

- Confirm both containers are running.
- Confirm the dependency itself is healthy.
- Inspect the name the client is trying to resolve.
- Compare failing and working names inside the Compose network.

## Useful Commands

```sh
docker compose -f lab07-dns-resolution/compose.yaml ps
make -C .. lab07-shell
python - <<'PY'
import socket
for name in ("backend", "api"):
    try:
        print(name, socket.gethostbyname(name))
    except OSError as exc:
        print(name, exc)
PY
cat /etc/resolv.conf
```

## Hints

1. The dependency has a working HTTP health endpoint.
2. Docker Compose provides DNS for service names on the project network.
3. Compare the configured target name with the service names in `compose.yaml`.

## Cleanup

```sh
make -C .. lab07-clean
```
