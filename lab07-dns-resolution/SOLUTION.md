# Lab07 Solution

## Root Cause

The client is configured with `TARGET_HOST=backend`, but the healthy dependency service is named `api`. Docker Compose DNS resolves service names on the project network, so `api` resolves and `backend` does not.

## Walkthrough

Check that both containers are running:

```sh
docker compose -f lab07-dns-resolution/compose.yaml ps
```

Confirm the dependency is healthy from the host:

```sh
curl -s http://localhost:8007/health
```

Inspect the client logs:

```sh
make lab07-logs
```

Expected observation: the client reports name resolution failures for `backend`.

Compare DNS names from inside the client container:

```sh
make lab07-shell
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

Expected observation: `api` resolves to a container address, while `backend` fails.

## Fix

```sh
make lab07-fix
make lab07-clean
make lab07-start
```

The patch changes the client target from `backend` to `api`.

## Verification

```sh
make lab07-logs
make lab07-shell
python - <<'PY'
import urllib.request
print(urllib.request.urlopen("http://api:8000/health", timeout=2).read().decode().strip())
PY
```

Expected observations:

- Client logs show successful responses from the dependency.
- DNS resolution succeeds for the configured target.
- The dependency remains healthy.

## Production Relevance

DNS failures often look like dependency outages until you verify service health and resolution from the failing network namespace.
