import os
import subprocess
import time

WORKERS = 6
BROKEN_CMD = "dd if=/dev/zero of={path} bs=64K count=512 oflag=sync conv=notrunc"


def main():
    os.makedirs("/data", exist_ok=True)
    procs = []
    for n in range(WORKERS):
        path = f"/data/worker-{n}.bin"
        cmd = f"while :; do {BROKEN_CMD.format(path=path)}; done"
        procs.append(subprocess.Popen(["sh", "-c", cmd], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL))
    while True:
        running = sum(p.poll() is None for p in procs)
        print(f"sync writers running={running}", flush=True)
        time.sleep(1)


if __name__ == "__main__":
    main()
