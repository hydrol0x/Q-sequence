/* jumpstats.c
 * Supplementary measurement: local oscillation of the exact Q-sequence.
 * For each generation G_k=[2^k,2^{k+1}), k=15..24, report
 *   max |Q(n+1)-Q(n)|, mean |Q(n+1)-Q(n)|,
 *   and the max spread max-min of Q over sliding windows of size w in {3,17,129}
 *   (window sizes = 2*E0+1 for E0 = 1, 8, 64: the value spread a +-E0 index
 *    uncertainty is forced to absorb in one lookup, before any compounding).
 * Also: width of the FIRST interval step for each E0, predicted from exact Q:
 *   at n0=2^20+1: I1 is the singleton {n0-Q(2^20)} (2^20 is an exact seed),
 *   I2 is the window [n0-Q(2^20-1)-E0, n0-Q(2^20-1)+E0] (2^20-1 is fuzzed).
 *   Predicted width = spread over I1 of [lo,hi] seeds + spread over I2 of
 *   [lo,hi] seeds, where a seed position carries +-E0 only if it lies in
 *   [2^19, 2^20).  Must reproduce the measured width(2^20+1) in results.txt.
 * Single-threaded, ~134 MB.
 */
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

int main(void){
  const uint32_t LOGN = 25u, NN = 1u << 25;
  uint32_t *Q = (uint32_t*)malloc(((size_t)NN + 2u) * sizeof(uint32_t));
  if (!Q){ fprintf(stderr, "malloc failed\n"); return 1; }
  Q[1] = 1u; Q[2] = 1u;
  for (uint32_t n = 3u; n <= NN; n++){
    uint32_t qa = Q[n-1u], qb = Q[n-2u];
    if (qa >= n || qb >= n){ fprintf(stderr, "death at %u\n", n); return 1; }
    Q[n] = Q[n - qa] + Q[n - qb];
  }
  printf("Local oscillation of exact Q per generation G_k=[2^k,2^(k+1)):\n");
  printf("  k |   max|dQ| |  mean|dQ| | maxspread w=3 | maxspread w=17 | maxspread w=129\n");
  const uint32_t ws[3] = {3u, 17u, 129u};
  for (uint32_t k = 15u; k <= LOGN - 1u; k++){
    uint32_t gs = 1u << k, ge = 1u << (k+1u);
    uint64_t mx = 0, sm = 0;
    for (uint32_t n = gs; n + 1u < ge; n++){
      int64_t d = (int64_t)Q[n+1u] - Q[n];
      uint64_t a = (uint64_t)(d < 0 ? -d : d);
      if (a > mx) mx = a;
      sm += a;
    }
    uint64_t sp[3] = {0,0,0};
    for (int j = 0; j < 3; j++){
      uint32_t w = ws[j];
      for (uint32_t s = gs; s + w <= ge; s++){
        uint32_t mn = UINT32_MAX, mxx = 0;
        for (uint32_t i = s; i < s + w; i++){
          if (Q[i] < mn) mn = Q[i];
          if (Q[i] > mxx) mxx = Q[i];
        }
        uint64_t d = mxx - mn;
        if (d > sp[j]) sp[j] = d;
      }
    }
    printf(" %2u | %9llu | %9.2f | %13llu | %14llu | %15llu\n",
           k, (unsigned long long)mx, (double)sm/(double)(ge-gs-1u),
           (unsigned long long)sp[0], (unsigned long long)sp[1], (unsigned long long)sp[2]);
  }
  /* first-step width prediction at n0 = 2^20+1 for E0 in {1,8,64} */
  printf("\nFirst-step width at n0=2^20+1 predicted from exact Q (must equal measured):\n");
  const uint32_t n0 = (1u<<20) + 1u;
  uint32_t i1 = n0 - Q[1u<<20];             /* singleton lookup (2^20 seeded exact) */
  uint32_t c2 = n0 - Q[(1u<<20) - 1u];      /* center of fuzzed lookup window */
  const uint32_t E0s[3] = {1u, 8u, 64u};
  for (int j = 0; j < 3; j++){
    uint32_t E0 = E0s[j];
    uint32_t a = c2 - E0, b = c2 + E0;
    uint32_t mn = UINT32_MAX, mx = 0, tmn = UINT32_MAX, tmx = 0;
    for (uint32_t i = a; i <= b; i++){
      int fz = (i >= (1u<<19) && i < (1u<<20));
      uint32_t lov = fz ? ((Q[i] > E0) ? Q[i] - E0 : 1u) : Q[i];
      uint32_t hiv = fz ? (Q[i] + E0) : Q[i];
      if (lov < mn) mn = lov;
      if (hiv > mx) mx = hiv;
      if (Q[i] < tmn) tmn = Q[i];
      if (Q[i] > tmx) tmx = Q[i];
    }
    int fz1 = (i1 >= (1u<<19) && i1 < (1u<<20));
    uint32_t w1 = fz1 ? 2u*E0 : 0u;   /* singleton lookup: its own value fuzz only */
    uint64_t w = (uint64_t)w1 + (uint64_t)(mx - mn);
    printf("  E0=%-3u lookup1 index %u (in fuzz region: %s, contributes width %u);\n"
           "         lookup2 window [%u,%u] (entirely %s 2^19): true Q spread %u, seeded spread %u\n"
           "         -> predicted width(2^20+1) = %llu\n",
           E0, i1, fz1 ? "yes" : "no", w1,
           a, b, (b < (1u<<19)) ? "below" : "not below", tmx - tmn, mx - mn,
           (unsigned long long)w);
  }
  free(Q);
  return 0;
}
