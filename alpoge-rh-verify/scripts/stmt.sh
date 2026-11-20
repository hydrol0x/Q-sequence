#!/bin/bash
cd /home/judge/dep && cp /judge-scripts/depgraph.cpp . && g++ -O2 -std=c++17 -o depgraph depgraph.cpp && mkdir -p stmt && /usr/bin/time -f "depgraph stmt wall=%es rss=%MKB rc=%x" ./depgraph /home/judge/drew/solution.ndjson stmt stmt
cmp stmt/nodes.tsv full/nodes.tsv | head -2; ls -l stmt; rm -f stmt/nodes.tsv; tar -cf - stmt | zstd -9 -T16 -q -o /home/judge/dep/stmt-pack.tar.zst -f; ls -l stmt-pack.tar.zst; sha256sum stmt-pack.tar.zst
