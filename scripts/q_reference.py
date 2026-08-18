#!/usr/bin/env python3
"""
Exact-integer reference implementation of the Hofstadter Q-sequence.

    Q(1) = 1, Q(2) = 1,
    Q(n) = Q(n - Q(n-1)) + Q(n - Q(n-2))   for n >= 3.

Q(n) is defined iff both lookup indices n - Q(n-1) and n - Q(n-2) lie in
[1, n-1]; the sequence *dies at n* iff Q(n-1) >= n or Q(n-2) >= n.

This mirrors the Lean engine (`QSequence/Engine.lean`) exactly and is intended
for fast numeric experimentation in the research phase.  Python ints are
arbitrary precision, so all arithmetic is exact.

Usage:
    python3 q_reference.py --upto 100000000        # compute, report survival
    python3 q_reference.py --upto 10000000 --stats # + empirical diagnostics
    python3 q_reference.py --values 1 2 3 24 1000   # print specific Q(n)

The sequence is stored 1-indexed in a list `q` with q[0] unused.
"""
from __future__ import annotations
import argparse
import sys


def compute(N: int) -> tuple[list[int], int | None]:
    """Return (q, death) where q holds Q(1..min(N,death-1)) at indices 1..,
    and death is None if the sequence survives through N, else the death index.
    """
    if N < 1:
        return [0], None
    q = [0] * (N + 1)  # q[0] unused; 1-indexed
    q[1] = 1
    if N >= 2:
        q[2] = 1
    for n in range(3, N + 1):
        qn1 = q[n - 1]
        qn2 = q[n - 2]
        # death iff a lookup index falls below 1
        if qn1 >= n or qn2 >= n:
            return q[:n], n
        q[n] = q[n - qn1] + q[n - qn2]
    return q, None


def stats(q: list[int], N: int) -> None:
    """Empirical diagnostics useful for the research phase.  Prints, over
    n in [1, N]:
      * max |2 Q(n) - n|  (deviation from n/2, doubled to stay integer)
      * the n achieving it
      * count of monotonicity failures Q(n) < Q(n-1)
      * max downward jump Q(n-1) - Q(n) and max upward jump
      * whether Q(n) + Q(n-1) - n stays bounded / its range (a common heuristic)
    """
    max_dev = 0
    max_dev_n = 0
    mono_fail = 0
    max_down = 0
    max_up = 0
    sum_lo = None
    sum_hi = None
    for n in range(1, N + 1):
        dev = abs(2 * q[n] - n)
        if dev > max_dev:
            max_dev, max_dev_n = dev, n
        if n >= 2:
            d = q[n] - q[n - 1]
            if d < 0:
                mono_fail += 1
                if -d > max_down:
                    max_down = -d
            elif d > max_up:
                max_up = d
            s = q[n] + q[n - 1] - n
            sum_lo = s if sum_lo is None else min(sum_lo, s)
            sum_hi = s if sum_hi is None else max(sum_hi, s)
    print(f"  N                         = {N}")
    print(f"  Q(N)                      = {q[N]}")
    print(f"  Q(N)/N                    = {q[N] / N:.9f}   (target 1/2)")
    print(f"  max |2Q(n) - n|           = {max_dev}  at n = {max_dev_n}")
    print(f"  max |2Q(n)-n| / N         = {max_dev / N:.6f}")
    print(f"  monotonicity failures     = {mono_fail}  (Q non-monotone)")
    print(f"  max downward jump         = {max_down}")
    print(f"  max upward jump           = {max_up}")
    print(f"  range of Q(n)+Q(n-1)-n    = [{sum_lo}, {sum_hi}]")


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--upto", type=int, default=0, help="compute Q(1..N)")
    ap.add_argument("--stats", action="store_true", help="print diagnostics")
    ap.add_argument("--values", type=int, nargs="*", help="print specific Q(n)")
    args = ap.parse_args(argv)

    N = args.upto
    if args.values:
        N = max(N, max(args.values))
    if N <= 0:
        ap.print_help()
        return 0

    q, death = compute(N)
    if death is not None:
        print(f"DEATH at n = {death}: Q(n-1)={q[death-1]}, Q(n-2)={q[death-2]}, "
              f"lookup index n - Q(n-1) = {death - q[death-1]}")
        print("NOTE: any real death index exceeds 3e10; a small death index "
              "indicates a bookkeeping bug.")
        return 1

    print(f"SURVIVES through N = {N}.  Q(N) = {q[N]}  (Q(N)/N = {q[N]/N:.9f})")
    if args.values:
        for v in args.values:
            print(f"  Q({v}) = {q[v]}")
    if args.stats:
        stats(q, N)
    return 0


if __name__ == "__main__":
    sys.setrecursionlimit(10000)
    raise SystemExit(main(sys.argv[1:]))
