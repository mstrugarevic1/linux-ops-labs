import socket
import sys
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

PORT = 8000
SERVER = ("server", PORT)
BIND_SOURCE_PORTS = True
SOURCE_PORTS = range(40000, 40008)
REQUESTS_PER_BATCH = 80
HELD_CONNECTIONS = len(SOURCE_PORTS)


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            self.reply(200, "ok\n")
            return
        self.reply(404, "not found\n")

    def reply(self, status, body):
        data = body.encode()
        self.send_response(status)
        self.send_header("content-type", "text/plain")
        self.send_header("content-length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def log_message(self, fmt, *args):
        return


def server():
    print(f"server listening on port {PORT}", flush=True)
    ThreadingHTTPServer(("0.0.0.0", PORT), Handler).serve_forever()


def request(n):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.settimeout(1)
        if BIND_SOURCE_PORTS:
            sock.bind(("", SOURCE_PORTS[n % len(SOURCE_PORTS)]))
        sock.connect(SERVER)
        sock.sendall(b"GET /health HTTP/1.1\r\nHost: server\r\nConnection: close\r\n\r\n")
        return sock.recv(128)


def hold_source_ports():
    sockets = []
    for port in SOURCE_PORTS:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(1)
        sock.bind(("", port))
        sock.connect(SERVER)
        sockets.append(sock)
    print(f"holding {len(sockets)} client source ports open", flush=True)
    return sockets


def client():
    held = hold_source_ports() if BIND_SOURCE_PORTS else []
    while True:
        ok = 0
        failed = 0
        for n in range(REQUESTS_PER_BATCH):
            try:
                request(n)
                ok += 1
            except OSError as exc:
                failed += 1
                if failed <= 5:
                    print(f"connect failed: {exc}", flush=True)
            time.sleep(0.02)
        print(f"batch complete ok={ok} failed={failed} bind_source_ports={BIND_SOURCE_PORTS}", flush=True)
        time.sleep(2)


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "server":
        server()
    elif len(sys.argv) > 1 and sys.argv[1] == "client":
        client()
    else:
        raise SystemExit("usage: app.py server|client")
