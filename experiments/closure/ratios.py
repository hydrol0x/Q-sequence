#!/usr/bin/env python3
# ratios.py — derived table: among windows that OCCUR MORE THAN ONCE (the only
# ones that can exhibit ambiguity), what fraction are ambiguous?  Computed
# exactly from windows_out.txt.  Also reports admissible-window saturation for
# the t alphabet (t(n) == n mod 2 forces 2^(w+1) admissible windows) and 3^w /
# 4^w / 9^w caps for context.
import re, sys

src = open(sys.argv[1] if len(sys.argv) > 1 else "windows_out.txt").read()
blocks = re.split(r"Alphabet: ", src)[1:]
print("Derived table: ambiguous / repeated (fraction of RECURRING windows that are ambiguous)")
print("and distinct / admissible (saturation of the a-priori possible window space).")
for b in blocks:
    name = b.splitlines()[0]
    if name.startswith("sigma"):
        adm = lambda w: 3 ** w
        admname = "3^w"
    elif name.startswith("t(n)"):
        adm = lambda w: 2 ** (w + 1)  # parity-admissible: t(n) mod 2 == n mod 2
        admname = "2^(w+1) parity-admissible"
    else:
        adm = lambda w: 9 ** w
        admname = "9^w"
    print(f"\nAlphabet: {name}   (admissible = {admname})")
    print(f"{'w':>3} {'distinct':>10} {'repeated':>10} {'ambiguous':>10} {'amb/rep':>9} {'distinct/admissible':>20}")
    for line in b.splitlines():
        m = re.match(r"\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+([\d.]+)\s*$", line)
        if not m:
            continue
        w, M, dist, rep, amb, ambocc = (int(m.group(i)) for i in range(1, 7))
        a = adm(w)
        sat = dist / a if a > 0 else float("nan")
        ar = amb / rep if rep else float("nan")
        sats = f"{sat:.6f}" if a < 10**18 else "~0"
        print(f"{w:>3} {dist:>10} {rep:>10} {amb:>10} {ar:>9.4f} {sats:>20}")
