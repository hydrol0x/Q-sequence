cd /work/ext/lean/.lake/build/lib/lean 2>/dev/null || exit 1
N=$(find . -name "*.olean" | wc -l)
echo "$(date -u +%FT%TZ) oleans=$N running_lean=$(ps -eo stat,comm | grep -c '^[RSD].* lean$') mem_cur_GB=$(( $(cat /sys/fs/cgroup/memory.current)/1073741824 )) mem_peak_GB=$(( $(cat /sys/fs/cgroup/memory.peak)/1073741824 )) disk=$(df --output=used -BG / | tail -1 | tr -d ' ') buildlog_bytes=$(stat -c %s /work/logs/build.log)"
for d in */; do printf "%s=%s " "$d" "$(find "$d" -name '*.olean' | wc -l)"; done; echo
