import resource
import time

chunks = []


def rss_mb():
    return resource.getrusage(resource.RUSAGE_SELF).ru_maxrss // 1024


while True:
    chunks.append(bytearray(1024 * 1024))
    print(f"allocated={len(chunks)}MiB rss={rss_mb()}MiB", flush=True)
    time.sleep(0.2)
