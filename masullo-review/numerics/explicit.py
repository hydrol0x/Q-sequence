# Numerical check of the explicit formula for a test function supported in (p, 2p), p = 5,
# containing exactly one prime power (q = 7).  f(x) = phi(x/p) with phi a bump on (1.24, 1.56) c (1, 2).
# Weil/Bombieri form for f in C_c^infty(1, inf):
#   sum_rho ftilde(rho) = ftilde(1) + ftilde(0) - sum_n Lambda(n) f(n) - int_1^inf f(x) x/(x^2-1) dx,
#   ftilde(s) = int f(x) x^(s-1) dx.   (rho over ALL nontrivial zeros.)
import mpmath as mp, sys
mp.mp.dps = 25
a, b = mp.mpf('6.2'), mp.mpf('7.8')
def f(x):
    if x <= a or x >= b: return mp.mpf(0)
    t = (2*x - (a+b))/(b-a)            # in (-1,1)
    return mp.exp(1 - 1/(1 - t*t))     # smooth bump, f(7) = 1
def ft(s): return mp.quad(lambda x: f(x)*x**(s-1), mp.linspace(a, b, 9))
rhs_pole = ft(1) + ft(0)
rhs_prime = -mp.log(7)*f(mp.mpf(7))
rhs_arch = -mp.quad(lambda x: f(x)*x/(x*x-1), mp.linspace(a, b, 9))
rhs = rhs_pole + rhs_prime + rhs_arch
print("f~(1)+f~(0)          =", mp.nstr(rhs_pole, 12))
print("-log(7) f(7)         =", mp.nstr(rhs_prime, 12))
print("archimedean term     =", mp.nstr(rhs_arch, 12))
print("Weil geometric side  =", mp.nstr(rhs, 12))
N = int(sys.argv[1]); tot = mp.mpf(0)
for n in range(1, N+1):
    g = mp.zetazero(n).imag
    tot += 2*mp.re(ft(mp.mpc(0.5, g)))   # rho and conj(rho)
    if n in (50, 100, 200, 300, 400, 500, 600) or n == N:
        print("zeros used: %4d (height %8.2f)  sum over zeros = %s   last term size %s" % (n, g, mp.nstr(tot, 12), mp.nstr(abs(ft(mp.mpc(0.5, g))), 3)))
        sys.stdout.flush()
print("difference (zeros - geometric) =", mp.nstr(tot - rhs, 6))
