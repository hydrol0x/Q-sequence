#!/bin/bash
cd /home/judge/dep && cp /judge-scripts/domtree.cpp . && g++ -O2 -std=c++17 -pthread -o domtree domtree.cpp 2>&1 | head; 
python3 -I /judge-scripts/dom.py prep full full-out && /usr/bin/time -f "dom wall=%es rss=%MKB rc=%x" ./domtree dom full full-out full-out/targets.ids && /usr/bin/time -f "domreport wall=%es rss=%MKB rc=%x" python3 -I /judge-scripts/dom.py report full full-out > full-out/dom-stdout.txt 2> full-out/dom-stderr.txt
tail -5 full-out/dom-stderr.txt; echo "[$(date -u +%T)] done"
