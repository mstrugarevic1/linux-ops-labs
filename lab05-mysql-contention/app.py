import subprocess
import time

MYSQL = ["mysql", "--ssl=0", "-hdb", "-uapp", "-plab", "lab", "-e"]


def run(sql):
    return subprocess.run(MYSQL + [sql], text=True, capture_output=True)


def spawn(sql):
    return subprocess.Popen(MYSQL + [sql], stdout=subprocess.DEVNULL, stderr=subprocess.PIPE, text=True)


while run("SELECT 1").returncode:
    time.sleep(1)

run("UPDATE counters SET value = 0 WHERE id = 1")

procs = []
for _ in range(18):
    procs.append(spawn("SELECT SLEEP(600)"))

procs.append(spawn("START TRANSACTION; UPDATE counters SET value = value + 1 WHERE id = 1; SELECT SLEEP(600);"))

time.sleep(2)
for _ in range(8):
    procs.append(spawn("UPDATE counters SET value = value + 1 WHERE id = 1"))

while True:
    failures = [p.stderr.read().strip() for p in procs if p.poll() not in (None, 0)]
    if failures:
        print(failures[-1], flush=True)
    print("open connections and lock waiters are intentionally held", flush=True)
    time.sleep(5)
