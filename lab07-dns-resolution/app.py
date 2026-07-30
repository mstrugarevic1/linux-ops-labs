import os
import sys
import time
import urllib.error
import urllib.request
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

PORT = 8000
TARGET_HOST = os.getenv("TARGET_HOST", "backend")


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
        sys.stderr.write("%s\n" % (fmt % args))


def server():
    print(f"api serving on port {PORT}", flush=True)
    ThreadingHTTPServer(("0.0.0.0", PORT), Handler).serve_forever()


def client():
    url = f"http://{TARGET_HOST}:8000/health"
    while True:
        try:
            body = urllib.request.urlopen(url, timeout=2).read().decode().strip()
            print(f"dependency ok target={TARGET_HOST} body={body}", flush=True)
        except (OSError, urllib.error.URLError) as exc:
            print(f"dependency failed target={TARGET_HOST}: {exc}", flush=True)
        time.sleep(2)


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "server":
        server()
    elif len(sys.argv) > 1 and sys.argv[1] == "client":
        client()
    else:
        raise SystemExit("usage: app.py server|client")
