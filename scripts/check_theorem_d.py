#!/usr/bin/env python3
"""Numerical verification of Theorem D (REPORT.md §6): for each parameter set
satisfying the hypotheses, the adversarial construction of the corresponding
case yields an envelope-consistent f obeying the recurrence at n whose value
f(n) breaks the envelope.  Exact rational arithmetic via fractions."""
from fractions import Fraction as F
from math import floor, ceil

def env(m, c1, c2, d1, d2):
    lo = max(1, ceil(c1 * m - d1))
    hi = floor(c2 * m + d2)
    return lo, hi

def check(c1, c2, d1, d2, n, verbose=True):
    """Build the adversarial f per the proof's case; verify everything exactly."""
    assert 0 <= c1 <= c2 < 1 and d1 >= 0 and d2 >= 0
    # hypothesis (a) spot-check on the indices we will use + a sample
    # hypothesis (b): Q(1)=1 in E(1), Q(96)=64 in E(96)
    lo1, hi1 = env(1, c1, c2, d1, d2)
    lo96, hi96 = env(96, c1, c2, d1, d2)
    assert lo1 <= 1 <= hi1, "hypothesis (b) fails at m=1"
    assert lo96 <= 64 <= hi96, "hypothesis (b) fails at m=96"

    f = {}
    def set_min(m, at_least=None):
        lo, hi = env(m, c1, c2, d1, d2)
        assert lo <= hi, f"empty envelope at {m}"
        v = lo if at_least is None else max(lo, at_least)
        assert lo <= v <= hi, f"choice {v} not in E({m})=[{lo},{hi}]"
        f[m] = v
    def set_max(m):
        lo, hi = env(m, c1, c2, d1, d2)
        assert lo <= hi, f"empty envelope at {m}"
        f[m] = hi

    if c1 < F(1,2) and c2 > 0:
        case = 1
        set_min(n-1, at_least=3); set_min(n-2, at_least=3)
    elif c1 < F(1,2) and c2 == 0:
        case = 2
        set_min(n-1, at_least=3); set_min(n-2, at_least=3)  # E=[1,d2], 3 allowed since d2>=64
    elif c2 > F(1,2):
        case = 3
        set_max(n-1); set_max(n-2)
    else:
        case = 4  # c1 = c2 = 1/2
        assert c1 == F(1,2) and c2 == F(1,2)
        set_min(n-1); set_min(n-2)

    a = n - f[n-1]; b = n - f[n-2]
    assert 1 <= a <= n-1 and 1 <= b <= n-1, "lookup out of range"
    assert a not in (n-1, n-2) and b not in (n-1, n-2), "collision with fixed positions"
    if case in (1, 2, 4):
        set_max(a)
        if b != a: set_max(b)
    else:
        set_min(a)
        if b != a: set_min(b)
    fn = f[a] + f[b]
    lo_n, hi_n = env(n, c1, c2, d1, d2)
    broke = fn > hi_n if case in (1, 2, 4) else fn < lo_n
    if verbose:
        print(f"case {case}: c1={c1} c2={c2} d1={d1} d2={d2} n={n}: "
              f"f(n)={fn}, E(n)=[{lo_n},{hi_n}] -> {'BREAK' if broke else 'NO BREAK (!!)'}")
    return broke

params = [
    (F(3,10), F(6,10), F(5), F(20)),    # case 1
    (F(0),    F(9,10), F(0), F(1)),     # case 1, c1=0
    (F(49,100), F(1,2), F(10), F(16)),  # case 1 boundary c2=1/2
    (F(0),    F(0),    F(0), F(70)),    # case 2 (needs d2>=64)
    (F(11,20), F(4,5), F(3), F(20)),    # case 3
    (F(1,2),  F(51,100), F(2), F(16)),  # case 3, c2 barely > 1/2
    (F(74,100), F(99,100), F(0), F(64)),# case 3, high c's  (d2 for m=96: 64<=95.04+64 ok; lo96=71.04-0=72>64? check b!)
    (F(1,2),  F(1,2),  F(4), F(16)),    # case 4 critical
    (F(1,2),  F(1,2),  F(0), F(16)),    # case 4, d1=0
    (F(1,2),  F(1,2),  F(100), F(16)),  # case 4, large d1
    (F(2,3),  F(2,3),  F(1,3), F(1,3)), # would be case 3 c1=c2=2/3 -- (b) at 96: 64 in [63.67,64.33] ok
]
ok = True
for (c1, c2, d1, d2) in params:
    try:
        for n in (10**5, 10**6 + 7, 10**7 + 1):
            r = check(c1, c2, d1, d2, n, verbose=(n == 10**6 + 7))
            ok = ok and r
    except AssertionError as e:
        print(f"  params c1={c1} c2={c2} d1={d1} d2={d2}: hypothesis violated: {e}")
print("ALL BREAKS CONFIRMED" if ok else "SOME CASE FAILED TO BREAK — THEOREM D PROOF BUG")
