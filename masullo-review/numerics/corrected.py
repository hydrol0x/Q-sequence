# Corrected direction of the shift.  Weil-normalised test function Phi on (1.24,1.56):
#   Phi(y) = 5*sqrt(y)*bump(y)   (this is the Phi for which the note's script computes  p^{-1/2} Phi(x/p), p=5)
# Operator A(Phi) o (p^{-1/2} U_p), U_p h(x)=h(px), equals A(psi) with psi(x) = p^{-1/2} Phi(p x)  (support (0.248,0.312)).
# Sum_rho M psi(rho-1/2) = Sum_rho F~(rho), F(x)=x^{-1/2} psi(x); by the functional equation = Sum_rho G~(rho),
#   G(x)=F(1/x)/x, supported in (5/1.56, 5/1.24) = (3.205, 4.032)  (contains the prime power 4).
import mpmath as mp, sys
mp.mp.dps = 25
a0, b0 = mp.mpf('1.24'), mp.mpf('1.56')
def bump(y):
    if y <= a0 or y >= b0: return mp.mpf(0)
    t = (2*y - (a0+b0))/(b0-a0)
    return mp.exp(1 - 1/(1 - t*t))
p = mp.mpf(5)
def F(x): return 5*bump(p*x)            # x^{-1/2} psi(x)
def G(x): return F(1/x)/x
a, b = p/b0, p/a0
def Gt(s): return mp.quad(lambda x: G(x)*x**(s-1), mp.linspace(a, b, 9))
def Ft(s): return mp.quad(lambda x: F(x)*x**(s-1), mp.linspace(1/b, 1/a, 9))
pole = Gt(1) + Gt(0)
prime = -sum(mp.mangoldt(n)*G(mp.mpf(n)) for n in range(2, 6)) if hasattr(mp,'mangoldt') else -(mp.log(2)*G(mp.mpf(4)) + mp.log(2)*G(mp.mpf(2)) + mp.log(3)*G(mp.mpf(3)) + mp.log(5)*G(mp.mpf(5)))
arch = -mp.quad(lambda x: G(x)*x/(x*x-1), mp.linspace(a, b, 9))
print("pole terms", mp.nstr(pole, 12)); print("prime-power term (n=4)", mp.nstr(prime, 12)); print("arch", mp.nstr(arch, 12))
print("Weil geometric side W(psi) =", mp.nstr(pole+prime+arch, 12))
N = int(sys.argv[1]); tot = mp.mpf(0); tot2 = mp.mpf(0)
for n in range(1, N+1):
    g = mp.zetazero(n).imag
    tot += 2*mp.re(Gt(mp.mpc(0.5, g)))
    tot2 += 2*mp.re(Ft(mp.mpc(0.5, g)))
print("sum over first", N, "zeros using G:", mp.nstr(tot, 12), " using F directly:", mp.nstr(tot2, 12))
