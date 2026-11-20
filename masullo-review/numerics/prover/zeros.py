# cache imaginary parts of the first N nontrivial zeros of zeta
import mpmath as mp, sys, json
mp.mp.dps = 20
N = int(sys.argv[1])
g = [float(mp.zetazero(n).imag) for n in range(1, N+1)]
json.dump(g, open(sys.argv[2], 'w'))
print(N, g[0], g[-1])
