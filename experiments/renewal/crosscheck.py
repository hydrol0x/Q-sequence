#!/usr/bin/env python3
"""Independent cross-check of the C implementation (separate code path).

Recomputes Q(1..200000) directly from the recurrence in pure Python and
compares: the known prefix, Q(100000), sum mod 2^64 at 200000 (against the
value printed by ./qrenewal 200000), the d-range at 200000, the zero count
of e(n)=2Q(n)-n at 200000, and the exact witness repeat of task 2 for
N=100000 (positions 375 and 759, length 9, and that length 10 fails there).
"""
N = 200000
Q = [0, 1, 1]
for n in range(3, N + 1):
    a, b = Q[n-1], Q[n-2]
    assert a < n and b < n, f"death at {n}"
    v = Q[n-a] + Q[n-b]
    assert 1 <= v <= n, f"invariant violated at {n}"
    Q.append(v)

assert Q[1:16] == [1,1,2,3,3,4,5,5,6,6,6,8,8,8,10], "prefix mismatch"
print("prefix Q(1..15): PASS")
print(f"Q(100000) = {Q[100000]}  (expect 48157): {'PASS' if Q[100000]==48157 else 'FAIL'}")
s = sum(Q[1:N+1]) % (1 << 64)
print(f"sum Q(1..200000) mod 2^64 = {s}  (C printed 10001846157): {'PASS' if s==10001846157 else 'FAIL'}")
d = [None, None] + [Q[n] - Q[n-1] for n in range(2, N + 1)]
print(f"d range n=2..200000: [{min(d[2:])}, {max(d[2:])}]  (C printed [-16681, 15291]):",
      "PASS" if (min(d[2:]), max(d[2:])) == (-16681, 15291) else "FAIL")
zeros = [n for n in range(1, N + 1) if 2 * Q[n] == n]
print(f"zeros of e(n) up to 200000: {len(zeros)}  (C printed 140): {'PASS' if len(zeros)==140 else 'FAIL'}")
# task-2 witness for N=100000: d[375..383] == d[759..767], and no length-10 match there
w_ok = all(d[375 + i] == d[759 + i] for i in range(9)) and d[375 + 9] != d[759 + 9]
print(f"witness d(375..383)==d(759..767), length exactly 9 at that pair: {'PASS' if w_ok else 'FAIL'}")
print("block:", d[375:384])
