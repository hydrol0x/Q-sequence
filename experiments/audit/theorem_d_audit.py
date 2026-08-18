#!/usr/bin/env python3
"""Adversarial audit of REPORT.md Theorem D (section 6).

Implements the four case constructions EXACTLY as written in the proof TEXT
(not from scripts/check_theorem_d.py), with exact rational arithmetic, and
searches a parameter grid (incl. boundaries, near-critical c1, large d's) for
sets satisfying hypotheses (a),(b) where the written construction fails to
produce f(n) outside E(n) at n = 1e5 + irregular offsets (and, for any
failure, at escalating larger n to separate 'n not large enough yet' from a
genuine hole in the proof)."""
from fractions import Fraction as F
import math, itertools, sys

HALF = F(1, 2)

def lo_edge(c1, d1, m):      # real lower edge of E(m)
    return max(F(1), c1 * m - d1)

def hi_edge(c2, d2, m):      # real upper edge
    return c2 * m + d2

def in_E(c1, c2, d1, d2, v, m):
    return lo_edge(c1, d1, m) <= v <= hi_edge(c2, d2, m)

def ceil_f(x):  return math.ceil(x)
def floor_f(x): return math.floor(x)

def minimal_int(c1, c2, d1, d2, m):
    """smallest integer of E(m); None if E(m) has no integer >= 1"""
    v = max(1, ceil_f(c1 * m - d1))
    return v if v <= hi_edge(c2, d2, m) else None

def maximal_int(c1, c2, d1, d2, m):
    v = floor_f(hi_edge(c2, d2, m))
    return v if v >= lo_edge(c1, d1, m) and v >= 1 else None

CAP = 300000

def check_a(c1, c2, d1, d2):
    """hypothesis (a): E(m) contains an integer >= 1 for every m >= 1.
    Returns True / False / None (=could not verify exactly within CAP)."""
    # region 1 (lower edge clipped to 1, i.e. c1*m - d1 <= 1): 1 in E(m) iff
    # hi(m) >= 1; hi nondecreasing, so hi(1) >= 1 suffices for the whole region.
    if hi_edge(c2, d2, 1) < 1:
        return False
    if c1 == 0:
        return True   # lower edge is always 1 and hi(m) >= hi(1) >= 1
    if d1 + d2 >= 1:
        return True   # once lower > 1, interval length (c2-c1)m + d1+d2 >= 1
    m_cut = int((1 + d1) / c1) + 2          # beyond: lower edge = c1 m - d1 > 1
    if c2 > c1:
        m_len = int((1 - (d1 + d2)) / (c2 - c1)) + 2
        M = max(m_cut, m_len, 200)
        if M > CAP:
            return None
        return all(minimal_int(c1, c2, d1, d2, m) is not None for m in range(1, M + 1))
    else:
        # c1 == c2 = p/q: membership beyond m_cut depends on m mod q only
        q = c1.denominator
        M = m_cut + 2 * q + 200
        if M > CAP:
            return None
        return all(minimal_int(c1, c2, d1, d2, m) is not None for m in range(1, M + 1))

def check_b(c1, c2, d1, d2):
    return in_E(c1, c2, d1, d2, 1, 1) and in_E(c1, c2, d1, d2, 64, 96)

def construct(c1, c2, d1, d2, n):
    """Run the case construction from the proof text at position n.
    Returns (status, detail):
      'BREAK'    f(n) outside E(n)  (theorem's construction succeeded)
      'NOBREAK'  construction valid but f(n) in E(n)     <-- proof failure at this n
      'INVALID:<why>'  a side condition of the construction fails at this n
    """
    lo = lambda m: lo_edge(c1, d1, m)
    hi = lambda m: hi_edge(c2, d2, m)
    if c1 < HALF and c2 > 0:
        case = 1
        m1 = minimal_int(c1, c2, d1, d2, n - 1)
        m2 = minimal_int(c1, c2, d1, d2, n - 2)
        if m1 is None or m2 is None: return ('INVALID:no-min', case)
        f1, f2 = max(3, m1), max(3, m2)
        if not in_E(c1, c2, d1, d2, f1, n - 1): return ('INVALID:f(n-1) not in E', case)
        if not in_E(c1, c2, d1, d2, f2, n - 2): return ('INVALID:f(n-2) not in E', case)
        if not (f1 < n - 1 and f2 < n - 1):     return ('INVALID:f>=n-1', case)
        a, b = n - f1, n - f2
        if not (1 <= a <= n - 3 and 1 <= b <= n - 3): return ('INVALID:lookup collision/range', case)
        fa = maximal_int(c1, c2, d1, d2, a)
        fb = maximal_int(c1, c2, d1, d2, b)
        if fa is None or fb is None: return ('INVALID:no-max', case)
        # consistency: overlapping assignments
        assign = {n - 1: f1, n - 2: f2}
        for (pos, val) in ((a, fa), (b, fb)):
            if pos in assign and assign[pos] != val: return ('INVALID:conflict', case)
            assign[pos] = val
        fn = assign[a] + assign[b]
        return (('BREAK' if fn > hi(n) else 'NOBREAK'), (case, fn, float(hi(n))))
    if c1 < HALF and c2 == 0:
        case = 2
        # envelope should be [1, d2]; per text c1 must be 0 under (a)
        if not in_E(c1, c2, d1, d2, 3, n - 1) or not in_E(c1, c2, d1, d2, 3, n - 2):
            return ('INVALID:3 not in E', case)
        a = n - 3
        f3 = floor_f(d2)
        if not in_E(c1, c2, d1, d2, f3, a): return ('INVALID:floor(d2) not in E', case)
        fn = 2 * f3
        return (('BREAK' if fn > hi(n) else 'NOBREAK'), (case, fn, float(hi(n))))
    if c1 >= HALF and c2 > HALF:
        case = 3
        f1 = maximal_int(c1, c2, d1, d2, n - 1)
        f2 = maximal_int(c1, c2, d1, d2, n - 2)
        if f1 is None or f2 is None: return ('INVALID:no-max', case)
        if not (f1 <= n - 1 and f2 <= n - 1): return ('INVALID:f>n-1', case)
        a, b = n - f1, n - f2
        if a < 1 or b < 1: return ('INVALID:lookup<1', case)
        if a in (n - 1, n - 2) or b in (n - 1, n - 2): return ('INVALID:collision', case)
        fa = minimal_int(c1, c2, d1, d2, a)
        fb = minimal_int(c1, c2, d1, d2, b)
        if fa is None or fb is None: return ('INVALID:no-min', case)
        assign = {n - 1: f1, n - 2: f2}
        for (pos, val) in ((a, fa), (b, fb)):
            if pos in assign and assign[pos] != val: return ('INVALID:conflict', case)
            assign[pos] = val
        fn = assign[a] + assign[b]
        return (('BREAK' if fn < lo(n) else 'NOBREAK'), (case, fn, float(lo(n))))
    if c1 == HALF and c2 == HALF:
        case = 4
        m1 = minimal_int(c1, c2, d1, d2, n - 1)
        m2 = minimal_int(c1, c2, d1, d2, n - 2)
        if m1 is None or m2 is None: return ('INVALID:no-min', case)
        if m1 < 3 or m2 < 3: return ('INVALID:min<3 (n too small)', case)
        a, b = n - m1, n - m2
        if a in (n - 1, n - 2) or b in (n - 1, n - 2): return ('INVALID:collision', case)
        if a < 1 or b < 1 or a > n - 3 or b > n - 3: return ('INVALID:range', case)
        fa = maximal_int(c1, c2, d1, d2, a)
        fb = maximal_int(c1, c2, d1, d2, b)
        if fa is None or fb is None: return ('INVALID:no-max', case)
        assign = {n - 1: m1, n - 2: m2}
        for (pos, val) in ((a, fa), (b, fb)):
            if pos in assign and assign[pos] != val: return ('INVALID:conflict', case)
            assign[pos] = val
        fn = assign[a] + assign[b]
        return (('BREAK' if fn > hi(n) else 'NOBREAK'), (case, fn, float(hi(n))))
    return ('INVALID:no-case', None)

def main():
    cs = sorted(set([F(0), F(1,10), F(1,4), F(1,3), F(2,5), F(49,100), F(499,1000),
          F(1,2) - F(1,10**6), F(1,2) - F(1,10**9), F(1,2), F(1,2) + F(1,10**9),
          F(1,2) + F(1,10**6), F(501,1000), F(51,100), F(6,10), F(62,98), F(2,3),
          F(63,100), F(65,100), F(7,10), F(3,4), F(9,10), F(96,100), F(99,100), F(999,1000)]))
    ds = [F(0), F(1,2), F(1), F(5,2), F(3), F(10), F(16), F(637,10), F(64), F(100),
          F(1000), F(10000)]
    offsets = [0, 1, 2, 3, 5, 7, 13, 29, 57, 123, 997, 1234, 4321, 9999, 33333]
    ns = [10**5 + o for o in offsets]
    total = admitted = 0
    fails = []
    invalids = []
    for c1, c2 in itertools.product(cs, cs):
        if not (0 <= c1 <= c2 < 1):
            continue
        for d1, d2 in itertools.product(ds, ds):
            total += 1
            if not check_b(c1, c2, d1, d2):  # cheap first
                continue
            ca = check_a(c1, c2, d1, d2)
            if ca is False:
                continue
            # ca is True or None ("unverified"); still attack the construction,
            # but a reported theorem-FAIL would require re-verifying (a).
            admitted += 1
            for n in ns:
                st, det = construct(c1, c2, d1, d2, n)
                if st == 'NOBREAK':
                    # escalate: is it broken at larger n (asymptotic claim)?
                    esc = None
                    for big in [10**6, 10**7, 10**9, 10**12, 10**15]:
                        st2, det2 = construct(c1, c2, d1, d2, big)
                        if st2 == 'BREAK':
                            esc = big; break
                    fails.append((c1, c2, d1, d2, n, det, esc))
                elif st.startswith('INVALID'):
                    esc = None
                    for big in [10**6, 10**7, 10**9, 10**12, 10**15]:
                        st2, det2 = construct(c1, c2, d1, d2, big)
                        if st2 == 'BREAK':
                            esc = big; break
                    invalids.append((c1, c2, d1, d2, n, st, esc))
    print(f"grid points considered: {total}; satisfying (a)&(b): {admitted}")
    print(f"NOBREAK events at n~1e5: {len(fails)}")
    never = [f for f in fails if f[6] is None]
    print(f"  ... of which NOT broken even at escalated n (genuine proof holes): {len(never)}")
    for f in fails[:40]:
        c1, c2, d1, d2, n, det, esc = f
        print(f"  NOBREAK c1={c1} c2={c2} d1={d1} d2={d2} n={n} det={det} first_break_at={esc}")
    if len(fails) > 40: print(f"  ... {len(fails)-40} more")
    print(f"INVALID events at n~1e5: {len(invalids)}")
    neverI = [f for f in invalids if f[6] is None]
    print(f"  ... of which never valid+breaking at escalated n: {len(neverI)}")
    for f in invalids[:20]:
        c1, c2, d1, d2, n, st, esc = f
        print(f"  {st} c1={c1} c2={c2} d1={d1} d2={d2} n={n} first_break_at={esc}")
    if len(invalids) > 20: print(f"  ... {len(invalids)-20} more")
    # (iv) the d2 floor at the critical template
    print("\n(iv) floor check: c1=c2=1/2, is 64 in E(96) with d2 slightly below 16?")
    for d2 in [F(16), F(16) - F(1, 1000), F(15), F(0)]:
        ok = in_E(HALF, HALF, F(0), d2, 64, 96)
        print(f"    d2={d2}: 64 in E(96) -> {ok}  (upper edge = {48 + d2})")

if __name__ == '__main__':
    main()
