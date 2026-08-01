"""CPU-bound HTTP app for the throttling lab.

It burns CPU in foreground and background work so learners can inspect cgroup
throttling, latency, and CPU pressure symptoms. It is a training workload with
no guarantee of correctness, completeness, or production suitability.
"""

import json
import os
import sys
import threading
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

PORT = 8000
WORK_UNITS = int(os.getenv("WORK_UNITS", "2500000"))
BACKGROUND_UNITS = int(os.getenv("BACKGROUND_UNITS", "250000"))
BACKGROUND_SLEEP = float(os.getenv("BACKGROUND_SLEEP", "0.15"))


def cpu_work(units):
    value = 0
    for n in range(units):
        value = (value + (n * n)) % 1000003
    return value


def cpu_stat():
    try:
        with open("/sys/fs/cgroup/cpu.stat", encoding="utf-8") as f:
            return f.read().strip()
    except OSError as exc:
        return f"cpu.stat unavailable: {exc}"


def burn_cpu():
    while True:
        cpu_work(BACKGROUND_UNITS)
        time.sleep(BACKGROUND_SLEEP)


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            self.reply(200, {"status": "ok"})
            return
        if self.path == "/work":
            start = time.perf_counter()
            result = cpu_work(WORK_UNITS)
            self.reply(200, {"result": result, "elapsed_ms": round((time.perf_counter() - start) * 1000, 1)})
            return
        if self.path == "/cpu":
            self.reply(200, {"cpu_stat": cpu_stat()})
            return
        self.reply(404, {"error": "not found"})

    def reply(self, status, body):
        data = (json.dumps(body) + "\n").encode()
        self.send_response(status)
        self.send_header("content-type", "application/json")
        self.send_header("content-length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def log_message(self, fmt, *args):
        sys.stderr.write("%s\n" % (fmt % args))


if __name__ == "__main__":
    threading.Thread(target=burn_cpu, daemon=True).start()
    print(f"serving on port {PORT} work_units={WORK_UNITS}", flush=True)
    ThreadingHTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
