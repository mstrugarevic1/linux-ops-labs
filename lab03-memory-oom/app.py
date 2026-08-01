"""Memory pressure workload for the OOM lab.

It allocates memory until the container limit is reached so learners can inspect
RSS growth, cgroup limits, and OOM-kill evidence. It is a training workload
with no guarantee of correctness, completeness, or production suitability.
"""

import resource
import time

chunks = []


def max_rss_mb():
    return resource.getrusage(resource.RUSAGE_SELF).ru_maxrss // 1024


while True:
    chunks.append(bytearray(1024 * 1024))
    print(f"allocated={len(chunks)}MiB max_rss={max_rss_mb()}MiB", flush=True)
    time.sleep(0.2)
