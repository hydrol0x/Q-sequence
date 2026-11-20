#!/bin/bash
# sampler: container memory + load + olean count, every 60s
( while true; do echo "$(date -u +%FT%TZ) memcur=$(cat /sys/fs/cgroup/memory.current) mempeak=$(cat /sys/fs/cgroup/memory.peak) load=$(cut -d' ' -f1-3 /proc/loadavg) lean_procs=$(pgrep -c -x lean) disk=$(df --output=used -BG / | tail -1 | tr -d ' ')"; sleep 60; done >> /work/logs/sampler.log ) &
exec runuser -u builder -- env -i HOME=/home/builder USER=builder PATH=/usr/local/bin:/usr/bin:/bin LANG=C.UTF-8 bash /work/scripts/build.sh
