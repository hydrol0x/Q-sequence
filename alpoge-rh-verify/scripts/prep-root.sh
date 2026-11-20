#!/bin/bash
set -x
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq && apt-get install -y -qq zstd time procps jq >/dev/null
id builder 2>/dev/null || useradd -m -s /bin/bash builder
mkdir -p /work/dl /work/ext /work/scripts /work/logs && chown -R builder:builder /work
cat /proc/sys/vm/max_map_count /proc/sys/vm/overcommit_memory
set +x
exec runuser -u builder -- env -i HOME=/home/builder USER=builder PATH=/usr/local/bin:/usr/bin:/bin LANG=C.UTF-8 bash -c 'ulimit -n 65536; ulimit -a | grep -E "open files|stack"; exec bash /work/scripts/fetch.sh'
