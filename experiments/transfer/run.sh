#!/bin/sh
# Build and run the Q-sequence generation-transfer interval experiment.
# Single-threaded; peak RAM ~671 MB at full scale.
set -e
cd "$(dirname "$0")"
gcc -O2 -Wall -Wextra -o qtransfer qtransfer.c

# Small-scale end-to-end validation (full naive-reference cross-check on every step):
./qtransfer 14 9 | tee selftest_small.txt

# Full-scale experiment: N = 2^25, seeds exact to 2^20, fuzz +-E0 on G_19 = [2^19, 2^20):
./qtransfer 25 20 | tee results.txt

# Supplementary: local oscillation of exact Q (explains the first-step inflation):
gcc -O2 -Wall -Wextra -o jumpstats jumpstats.c
./jumpstats | tee jumpstats.txt
printf '\n== SUPPLEMENTARY: local oscillation of exact Q (jumpstats.c) ==\n' >> results.txt
cat jumpstats.txt >> results.txt
