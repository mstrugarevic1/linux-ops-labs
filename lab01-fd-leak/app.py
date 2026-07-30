import os
import sys
import time
import urllib.error
import urllib.request
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

DATA_FILE = "/tmp/lab01-data.txt"
PORT = 8000
leaked_files = []


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            self.reply(200, "ok\n")
            return
        if self.path == "/fds":
            self.reply(200, f"{len(os.listdir('/proc/self/fd'))}\n")
            return
        if self.path == "/leak":
            leaked_files.append(open(DATA_FILE))
            self.reply(200, "read one file and leaked its descriptor\n")
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


def serve():
    with open(DATA_FILE, "w") as f:
        f.write("small file used to make leaked descriptors easy to spot\n")
    ThreadingHTTPServer(("0.0.0.0", PORT), Handler).serve_forever()


def load():
    url = "http://app:8000/leak"
    while True:
        try:
            urllib.request.urlopen(url, timeout=2).read()
        except (OSError, urllib.error.URLError) as exc:
            print(f"request failed: {exc}", flush=True)
        time.sleep(0.15)


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "load":
        load()
    serve()
