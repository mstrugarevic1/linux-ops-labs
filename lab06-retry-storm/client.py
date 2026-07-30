import threading
import time
import urllib.error
import urllib.request

URL = "http://server:8000/"
THREADS = 16


def worker():
    while True:
        try:
            urllib.request.urlopen(URL, timeout=1).read()
        except (OSError, urllib.error.URLError):
            pass


for _ in range(THREADS):
    threading.Thread(target=worker, daemon=True).start()

while True:
    time.sleep(5)
