#!/usr/bin/env python3
"""Full independent verification of the C results at NMAX=10^7 (pure Python,
separate code path), plus an independent suffix-array+LCP computation (no
hashing) of the longest repeated substring of d for N=10^5."""
import sys, time

N = 10_000_000
t0 = time.time()
Q = [0] * (N + 1)
Q[1] = Q[2] = 1
inv = 0
for n in range(3, N + 1):
    a = Q[n-1]; b = Q[n-2]
    if a >= n or b >= n:
        print(f"DEATH at n={n}"); sys.exit(2)
    v = Q[n-a] + Q[n-b]
    Q[n] = v
    if v < 1 or v > n:
        inv += 1
print(f"recomputed Q(1..1e7) in {time.time()-t0:.1f}s; invariant violations={inv}")

def chk(name, got, want):
    print(f"{name}: got {got}, C said {want} -> {'PASS' if got == want else 'FAIL'}")

chk("Q(1..15)", Q[1:16], [1,1,2,3,3,4,5,5,6,6,6,8,8,8,10])
chk("Q(100000)", Q[100000], 48157)
chk("Q(10^6)", Q[1000000], 512066)
chk("Q(10^7)", Q[10000000], 5124632)
chk("sum Q(1..10^6) mod 2^64", sum(Q[1:1000001]) % (1 << 64), 250007889123)
chk("sum Q(1..10^7) mod 2^64", sum(Q[1:N+1]) % (1 << 64), 25000190971777)

dmin = dmax = 0
for n in range(2, N + 1):
    df = Q[n] - Q[n-1]
    if df < dmin: dmin = df
    if df > dmax: dmax = df
chk("d range", (dmin, dmax), (-661641, 631083))

zeros = [n for n in range(1, N + 1) if 2 * Q[n] == n]
chk("zero count", len(zeros), 231)
chk("last 5 zeros", zeros[-5:], [8227044, 8750472, 8900582, 9295244, 9830512])
gaps = [(zeros[i] - zeros[i-1], zeros[i-1], zeros[i]) for i in range(1, len(zeros))]
chk("largest gap", max(gaps), (951566, 5999550, 6951116))
w = set()
for z in zeros[:1000]:
    if z + 32 <= N:
        w.add(tuple(Q[m] - Q[m-1] for m in range(z + 1, z + 33)))
chk("distinct 32-windows after zeros", len(w), 231)

# task-2 witness at (375, 759): equality for 9 symbols, mismatch at symbol 10
d375 = [Q[375+i] - Q[374+i] for i in range(10)]
d759 = [Q[759+i] - Q[758+i] for i in range(10)]
chk("witness block d(375..383)", d375[:9], [-4, 4, -2, 2, 0, 0, 0, 0, 0])
chk("d(375..383)==d(759..767) and d(384)!=d(768)",
    (d375[:9] == d759[:9], d375[9] != d759[9]), (True, True))

# task-3 spot checks (first mismatch at i=0 for k=10 and k=22)
chk("d(1024), d(2048)", (Q[1024]-Q[1023], Q[2048]-Q[2047]), (37, 11))
chk("d(4194304), d(8388608)", (Q[4194304]-Q[4194303], Q[8388608]-Q[8388607]), (16689, 50044))

# ---- independent LRS for N=1e5 via suffix array + Kasai LCP (no hashing) ----
t0 = time.time()
s = [Q[n] - Q[n-1] for n in range(2, 100001)]   # d(2..100000), M=99999
n = len(s)
order = {v: i for i, v in enumerate(sorted(set(s)))}
rank = [order[v] for v in s]
sa = list(range(n)); tmp = [0] * n
k = 1
while True:
    key = lambda i: (rank[i], rank[i+k] if i + k < n else -1)
    sa.sort(key=key)
    tmp[sa[0]] = 0
    for i in range(1, n):
        tmp[sa[i]] = tmp[sa[i-1]] + (key(sa[i-1]) < key(sa[i]))
    rank = tmp[:]
    if rank[sa[-1]] == n - 1:
        break
    k *= 2
lcp = [0] * n; h = 0
for i in range(n):
    if rank[i] > 0:
        j = sa[rank[i] - 1]
        while i + h < n and j + h < n and s[i+h] == s[j+h]:
            h += 1
        lcp[rank[i]] = h
        if h: h -= 1
    else:
        h = 0
L = max(lcp)
chk("SA/LCP longest-repeat LENGTH, d N=1e5", L, 9)
# list every maximal-length witness pair (adjacent in suffix order)
pairs = []
for r in range(1, n):
    if lcp[r] == L:
        p1, p2 = sorted((sa[r-1], sa[r]))
        assert s[p1:p1+L] == s[p2:p2+L]          # exact check, no hashing
        pairs.append((p1 + 2, p2 + 2))           # symbol i <-> n = i+2
print(f"all suffix-adjacent length-{L} witness pairs (n-indices): {sorted(pairs)}")
chk("C witness (375,759) among them", (375, 759) in pairs, True)
print(f"suffix-array check done in {time.time()-t0:.1f}s")
print("ALL CHECKS DONE")
