#!/bin/bash
# runs as builder, scrubbed env
set -u
. ~/.elan/env
ulimit -n 65536
export LEAN_NUM_THREADS=32
cd /work/ext/lean
echo "[$(date -u +%FT%TZ)] start: lake build Main  (nproc=$(nproc), LEAN_NUM_THREADS=${LEAN_NUM_THREADS:-unset}, ulimit -s=$(ulimit -s))"
/usr/bin/time -v -o /work/logs/build.time lake build Main 2>&1 | tee /work/logs/build.log | tail -c 0
echo "[$(date -u +%FT%TZ)] end: lake build Main rc=${PIPESTATUS[0]}" | tee -a /work/logs/build.end
