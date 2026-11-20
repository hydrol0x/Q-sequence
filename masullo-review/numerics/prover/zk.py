# Z_K(phi) = sum_rho M phi(rho-1/2) * prod_{p<=K} (1 - p^{-rho})   (first N zeros, all on the critical line)
# compared (small K) with the unconditional Weil side  sum_{n | P_K} mu(n) W(phi^{(n)}),  phi^{(n)}(x)=n^{-1/2} phi(n x)
import numpy as np, json, sys, math, itertools
import mpmath as mp
D = '/tmp/claude-0/-home-user-Q-sequence/85c7cd58-d569-5e27-bf4a-0ff8a903944a/scratchpad/prover/'
gam = np.array(json.load(open(D+'zeros400.json')))
u0, h = 0.35, 0.30                       # phi(x) = g(log x), supp phi = (e^0.05, e^0.65) = (1.051, 1.916)
M = 200001
u = np.linspace(u0-h, u0+h, M); du = u[1]-u[0]
v = (u-u0)/h
g = np.zeros(M); inn = np.abs(v) < 1
g[inn] = np.exp(1 - 1/(1 - v[inn]**2))
def Mphi(s):                             # M phi(s) = int g(u) e^{su} du  (trapezoid, spectrally accurate)
    return np.sum(g*np.exp(s*u))*du
def phi(x):
    if x <= 0: return 0.0
    w = (math.log(x)-u0)/h
    return math.exp(1-1/(1-w*w)) if abs(w) < 1 else 0.0
c = np.array([Mphi(1j*t) for t in gam])  # M phi(i gamma)
print("supp phi = (%.4f, %.4f);  M phi(1/2)=%.8f  M phi(-1/2)=%.8f" % (math.exp(u0-h), math.exp(u0+h), Mphi(0.5).real, Mphi(-0.5).real))
print("|M phi(i gamma_n)| for n=1,2,3,100,200,400:", [float('%.3e' % abs(c[i])) for i in (0,1,2,99,199,399)])

# ---- primes
Kmax = 10**7
sieve = np.ones(Kmax+1, dtype=bool); sieve[:2] = False
for i in range(2, int(Kmax**0.5)+1):
    if sieve[i]: sieve[i*i::i] = False
primes = np.nonzero(sieve)[0].astype(np.float64)
logp = np.log(primes)
checkpoints = [1, 2, 3, 5, 7, 11, 13, 100, 1000, 10**4, 10**5, 10**6, 3*10**6, 10**7]
idx = [int(np.searchsorted(primes, K, side='right')) for K in checkpoints]   # number of primes <= K
# dense set of K for the sup/inf: every 200th prime
dense_idx = np.arange(0, len(primes)+1, 200)
logE_ck = np.zeros((len(gam), len(checkpoints)), dtype=complex)
logE_dn = np.zeros((len(gam), len(dense_idx)), dtype=complex)
for j, t in enumerate(gam):
    cs = np.concatenate(([0], np.cumsum(np.log1p(-np.exp(-(0.5+1j*t)*logp)))))
    logE_ck[j] = cs[idx]; logE_dn[j] = cs[dense_idx]
E_ck = np.exp(logE_ck)
print("\n K        Z_K(400 zeros)     Z_K(first 200)    term of rho_1 pair    |E_K(rho_1)|    |E_K(rho_2)|")
for k, K in enumerate(checkpoints):
    terms = 2*(c*E_ck[:, k]).real
    print("%-9d %16.8f %16.8f %16.8f %14.6f %14.6f" % (K, terms.sum(), terms[:200].sum(), terms[0], abs(E_ck[0, k]), abs(E_ck[1, k])))
Zd = 2*(c[:, None]*np.exp(logE_dn)).real.sum(axis=0)
Kd = np.concatenate(([1.0], primes))[dense_idx]
for lo, hi in [(1, 1e3), (1e3, 1e4), (1e4, 1e5), (1e5, 1e6), (1e6, 1e7)]:
    m = (Kd >= lo) & (Kd <= hi)
    print("K in [%.0e,%.0e]: min Z_K = %.5f, max Z_K = %.5f" % (lo, hi, Zd[m].min(), Zd[m].max()))

# ---- asymptotic check for a single zero:  log E_K(rho) + [Ei((1-rho) log K) - Ei((1-rho) log 2)] - loglog K  should stay bounded (RH + simple zero)
mp.mp.dps = 20
print("\n K     log E_K(rho1)                 -(Ei((1-rho)logK)-Ei((1-rho)log2))      difference - loglogK")
rho = mp.mpc(0.5, gam[0])
for k, K in enumerate(checkpoints[7:], start=7):
    li = mp.ei((1-rho)*mp.log(K)) - mp.ei((1-rho)*mp.log(2))
    d = complex(logE_ck[0, k]) + complex(li)
    print("%-9d %-30s %-36s %s" % (K, np.round(logE_ck[0, k], 5), np.round(complex(-li), 5), np.round(d - math.log(math.log(K)), 5)))

# ---- Weil side for small K (unconditional identity for the sum over ALL zeros)
def W(n):
    pole = (Mphi(0.5).real/n + Mphi(-0.5).real) if n > 1 else (Mphi(0.5).real + Mphi(-0.5).real)
    if n == 1:
        arch = np.sum(g*np.exp(1.5*u)/(np.exp(2*u)-1))*du
        pr = 0.0
        for q in range(2, 3):
            pass
        # prime powers in supp phi: none (support inside (1,2))
    else:
        arch = np.sum(g*np.exp(0.5*u)*n/(n*n-np.exp(2*u)))*du
        pr = 0.0
        # prime powers p^m with n/p^m in supp phi
        for q in range(2, n+1):
            # is q a prime power?
            f = mp.factorint(q) if hasattr(mp, 'factorint') else None
            ps = [p for p in range(2, q+1) if q % p == 0 and all(p % r for r in range(2, int(p**0.5)+1))]
            if len(ps) == 1:
                pr += math.log(ps[0])*(n*q)**-0.5*phi(n/q)
    return pole - pr - arch
smallp = [2, 3, 5, 7, 11, 13]
print("\n K   Weil side sum_{n|P_K} mu(n) W(phi^(n))    zero side (400 zeros)   pole part Mphi(1/2)prod(1-1/p)")
for r in range(0, len(smallp)+1):
    ps = smallp[:r]; tot = 0.0
    for m in range(0, r+1):
        for S in itertools.combinations(ps, m):
            n = int(np.prod(S)) if S else 1
            tot += (-1)**m * W(n)
    K = ps[-1] if ps else 1
    k = checkpoints.index(K)
    print("%-3d %20.8f %30.8f %20.8f" % (K, tot, 2*(c*E_ck[:, k]).real.sum(), Mphi(0.5).real*np.prod([1-1/p for p in ps])))
