#!/bin/bash
# Deletes Lake's per-module .setup.json (an input file for `lean --setup`) once that module's .olean exists
# and the json is >3 minutes old. Runs as builder. Logs counts/bytes.
cd /work/ext/lean/.lake/build || exit 1
while true; do
  n=0; b=0
  while IFS= read -r -d '' f; do
    m=${f#ir/}; m=${m%.setup.json}
    if [ -f "lib/lean/$m.olean" ] && [ -f "lib/lean/$m.trace" ]; then
      s=$(stat -c %s "$f" 2>/dev/null || echo 0); rm -f -- "$f" && n=$((n+1)) && b=$((b+s))
    fi
  done < <(find ir -name '*.setup.json' -mmin +3 -print0 2>/dev/null)
  echo "$(date -u +%FT%TZ) deleted=$n bytes=$b disk_used=$(df --output=used -BG / | tail -1 | tr -d ' ')" >> /work/logs/janitor.log
  sleep 120
done
