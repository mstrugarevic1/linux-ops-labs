from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import time

requests = 0
started = time.time()


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        global requests
        requests += 1
        if self.path == "/stats":
            age = max(time.time() - started, 1)
            body = f"requests={requests} rps={requests / age:.1f}\n"
            self.send(200, body)
            return
        self.send(503, "temporary failure\n")

    def send(self, status, body):
        data = body.encode()
        self.send_response(status)
        self.send_header("content-type", "text/plain")
        self.send_header("content-length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def log_message(self, fmt, *args):
        return


ThreadingHTTPServer(("0.0.0.0", 8000), Handler).serve_forever()
