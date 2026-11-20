#!/bin/bash
cd /home/judge/dep && mkdir -p full full-out
echo "[$(date -u +%T)] depgraph on solution.ndjson ($(stat -c %s /home/judge/drew/solution.ndjson) bytes)"
/usr/bin/time -f "depgraph wall=%es rss=%MKB rc=%x" ./depgraph /home/judge/drew/solution.ndjson full
ls -l full; wc -l full/nodes.tsv
echo "[$(date -u +%T)] analyze"
/usr/bin/time -f "analyze wall=%es rss=%MKB rc=%x" python3 -I /judge-scripts/analyze.py /home/judge/dep/full /home/judge/dep /home/judge/dep/full-out > full-out/stdout.txt 2> full-out/stderr.txt
tail -3 full-out/stderr.txt; echo "[$(date -u +%T)] done"
