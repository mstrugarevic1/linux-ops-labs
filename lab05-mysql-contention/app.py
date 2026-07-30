import subprocess
import time

MYSQL = ["mysql", "--ssl=0", "-hdb", "-uapp", "-plab", "lab", "-e"]


def run(sql):
    result = subprocess.run(MYSQL + [sql], text=True, capture_output=True)
    if result.returncode:
        print(f"setup query failed rc={result.returncode}: {result.stderr.strip()}", flush=True)
    return result


def spawn(label, sql):
    print(f"starting {label}", flush=True)
    return {
        "label": label,
        "process": subprocess.Popen(
            MYSQL + [sql],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
        ),
        "reported": False,
    }


while run("SELECT 1").returncode:
    print("waiting for mysql", flush=True)
    time.sleep(1)

run("UPDATE counters SET value = 0 WHERE id = 1")

jobs = [
    spawn("lock-holder", "START TRANSACTION; UPDATE counters SET value = value + 1 WHERE id = 1; SELECT SLEEP(600);")
]
time.sleep(1)

for n in range(4):
    jobs.append(spawn(f"lock-waiter-{n}", "START TRANSACTION; UPDATE counters SET value = value + 1 WHERE id = 1;"))

time.sleep(1)
for n in range(11):
    jobs.append(spawn(f"sleeping-connection-{n}", "SELECT SLEEP(600)"))

time.sleep(1)
for n in range(4):
    jobs.append(spawn(f"expected-connection-failure-{n}", "SELECT 1"))

while True:
    for job in jobs:
        process = job["process"]
        if job["reported"] or process.poll() is None:
            continue
        stdout, stderr = process.communicate()
        label = job["label"]
        if process.returncode == 0:
            print(f"{label} exited rc=0 stdout={stdout.strip()}", flush=True)
        else:
            print(f"{label} failed rc={process.returncode}: {stderr.strip()}", flush=True)
        job["reported"] = True
    running = sum(job["process"].poll() is None for job in jobs)
    print(f"mysql workload running={running}", flush=True)
    time.sleep(5)
