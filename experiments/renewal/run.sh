#!/bin/sh
# Build and run the exact-substructure search on Hofstadter's Q-sequence.
# Outputs:
#   results_selftest.txt      LRS machinery validated against O(M^2) brute force
#   results_smoke_200000.txt  reduced run (NMAX=2e5), anchor checks
#   results.txt               full run (NMAX=1e7) -- main deliverable
set -e
cd "$(dirname "$0")"
gcc -O2 -Wall -Wextra -std=gnu11 -o qrenewal qrenewal.c
./qrenewal selftest > results_selftest.txt 2>&1
./qrenewal 200000   > results_smoke_200000.txt 2>&1
./qrenewal 10000000 > results.txt 2>&1
python3 crosscheck.py   > results_crosscheck_python.txt 2>&1     # independent, N=2e5
python3 verify_full.py  > results_verify_full_python.txt 2>&1    # independent, N=1e7 + SA/LCP
