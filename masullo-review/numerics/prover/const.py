# test of the conjectural asymptotic  E_K(rho) ~ (e^gamma log K / zeta'(rho)) * exp(-Ei((1-rho) log K))  at the first zeros
import mpmath as mp, numpy as np
mp.mp.dps = 25
Kmax = 10**7
sieve = np.ones(Kmax+1, dtype=bool); sieve[:2] = False
for i in range(2, int(Kmax**0.5)+1):
    if sieve[i]: sieve[i*i::i] = False
primes = np.nonzero(sieve)[0].astype(np.float64); logp = np.log(primes)
for n in (1, 2, 5):
    rho = mp.zetazero(n); t = float(rho.imag)
    cs = np.cumsum(np.log1p(-np.exp(-(0.5+1j*t)*logp)))
    pred = mp.euler - mp.log(mp.diff(mp.zeta, rho))
    print("zero", n, "gamma =", t, " predicted constant  gamma_E - log zeta'(rho) =", mp.nstr(pred, 8))
    for K in (10**3, 10**4, 10**5, 10**6, 10**7):
        k = int(np.searchsorted(primes, K, side='right'))
        d = complex(cs[k-1]) + complex(mp.ei((1-rho)*mp.log(K))) - np.log(np.log(K))
        print("   K=%-9d  log E_K + Ei((1-rho)log K) - loglog K = %s   (mod 2 pi i: imag %.5f)" % (K, np.round(d, 5), (d.imag+np.pi) % (2*np.pi) - np.pi))
