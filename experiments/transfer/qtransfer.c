/* qtransfer.c
 *
 * Interval-arithmetic error-propagation experiment for the Hofstadter
 * Q-sequence "generation structure".
 *
 *   Q(1)=Q(2)=1,  Q(n) = Q(n-Q(n-1)) + Q(n-Q(n-2)),  1-indexed.
 *   Generations G_k = [2^k, 2^{k+1}).
 *
 * Phase 1: exact Q(1..2^LOGN) as uint32, with death-condition and Q(n)<=n
 *          checks at every step; cross-validation values printed.
 * Phase 2: exact "spillover" rates: for n in G_k, how often the lookup
 *          indices i1=n-Q(n-1), i2=n-Q(n-2) fall below 2^{k-1} or at/above 2^k.
 * Phase 3: rigorous interval over-approximation of error propagation.
 *          Seeds: lo(n)=hi(n)=Q(n) for n<=2^SEEDLOG, EXCEPT the seed
 *          generation G_{SEEDLOG-1}=[2^{SEEDLOG-1},2^SEEDLOG) gets
 *          lo=max(1,Q-E0), hi=Q+E0.  For n>2^SEEDLOG:
 *            I1=[n-hi(n-1), n-lo(n-1)], I2=[n-hi(n-2), n-lo(n-2)],
 *            clipped to [1,n-1] (clip events counted),
 *            lo(n)=min lo over I1 + min lo over I2,
 *            hi(n)=max hi over I1 + max hi over I2.
 *          Range min/max via two incrementally-updated segment trees,
 *          O(log n) per query.  hi is saturated at 2^32-2 (events counted).
 *
 * Validation built in:
 *   - known prefix Q(1..15) and Q(100000)=48157;
 *   - segment-tree queries vs direct scan on random ranges;
 *   - full naive-array reference implementation compared on a prefix
 *     (whole run when N is small);
 *   - E0=0 must reproduce lo=hi=Q exactly at every step;
 *   - containment lo(n)<=Q(n)<=hi(n) checked at every step.
 *
 * Single-threaded.  Peak RAM ~671 MB at LOGN=25.
 * Usage: ./qtransfer [LOGN [SEEDLOG]]     (defaults 25 20)
 */
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

static uint32_t LOGN = 25u, SEEDLOG = 20u;
static uint32_t NN, SEED_END, FUZZ_LO;
static uint32_t *Q, *tmin, *tmax;

#define SATHI 0xFFFFFFFEu   /* saturation cap for hi */

static double now_s(void){ return (double)clock() / (double)CLOCKS_PER_SEC; }

/* ---- segment trees: leaves NN..2NN-1 hold positions 1..NN ---- */
static inline uint32_t leafi(uint32_t p){ return NN + p - 1u; }

static void tree_set(uint32_t p, uint32_t vlo, uint32_t vhi){
  uint32_t i = leafi(p);
  tmin[i] = vlo; tmax[i] = vhi;
  for (i >>= 1; i >= 1u; i >>= 1){
    uint32_t a = tmin[2u*i], b = tmin[2u*i+1u];
    tmin[i] = (a < b) ? a : b;
    a = tmax[2u*i]; b = tmax[2u*i+1u];
    tmax[i] = (a > b) ? a : b;
  }
}
static uint32_t rmin(uint32_t a, uint32_t b){ /* positions a..b inclusive */
  uint32_t res = UINT32_MAX;
  uint32_t l = NN + a - 1u, r = NN + b;
  while (l < r){
    if (l & 1u){ uint32_t v = tmin[l++]; if (v < res) res = v; }
    if (r & 1u){ uint32_t v = tmin[--r]; if (v < res) res = v; }
    l >>= 1u; r >>= 1u;
  }
  return res;
}
static uint32_t rmax(uint32_t a, uint32_t b){
  uint32_t res = 0u;
  uint32_t l = NN + a - 1u, r = NN + b;
  while (l < r){
    if (l & 1u){ uint32_t v = tmax[l++]; if (v > res) res = v; }
    if (r & 1u){ uint32_t v = tmax[--r]; if (v > res) res = v; }
    l >>= 1u; r >>= 1u;
  }
  return res;
}

static void seed_vals(uint32_t p, uint32_t E0, uint32_t *plo, uint32_t *phi){
  uint32_t lo = Q[p], hi = Q[p];
  if (p >= FUZZ_LO && p < SEED_END){
    lo = (Q[p] > E0) ? (Q[p] - E0) : 1u;   /* floor at 1 */
    hi = Q[p] + E0;
  }
  *plo = lo; *phi = hi;
}

/* naive-array reference implementation (identical semantics) */
static void naive_interval(uint32_t E0, uint32_t nmax, uint32_t *vlo, uint32_t *vhi){
  for (uint32_t p = 1u; p <= SEED_END; p++) seed_vals(p, E0, &vlo[p], &vhi[p]);
  for (uint32_t n = SEED_END + 1u; n <= nmax; n++){
    int64_t a1 = (int64_t)n - vhi[n-1u], b1 = (int64_t)n - vlo[n-1u];
    int64_t a2 = (int64_t)n - vhi[n-2u], b2 = (int64_t)n - vlo[n-2u];
    if (a1 < 1) a1 = 1;
    if (b1 > (int64_t)n - 1) b1 = (int64_t)n - 1;
    if (a2 < 1) a2 = 1;
    if (b2 > (int64_t)n - 1) b2 = (int64_t)n - 1;
    uint32_t m1 = UINT32_MAX, M1 = 0u, m2 = UINT32_MAX, M2 = 0u;
    for (int64_t i = a1; i <= b1; i++){ uint32_t x = vlo[i]; if (x < m1) m1 = x; x = vhi[i]; if (x > M1) M1 = x; }
    for (int64_t i = a2; i <= b2; i++){ uint32_t x = vlo[i]; if (x < m2) m2 = x; x = vhi[i]; if (x > M2) M2 = x; }
    uint64_t lo64 = (uint64_t)m1 + m2, hi64 = (uint64_t)M1 + M2;
    if (hi64 > (uint64_t)SATHI) hi64 = (uint64_t)SATHI;
    vlo[n] = (uint32_t)lo64; vhi[n] = (uint32_t)hi64;
  }
}

/* ---- Phase 1 ---- */
static int phase1(void){
  double t0 = now_s();
  printf("== PHASE 1: exact Q(1..2^%u) ==\n", LOGN);
  Q[1] = 1u; Q[2] = 1u;
  uint64_t qgtn = 0u; uint32_t first_qgtn = 0u;
  for (uint32_t n = 3u; n <= NN; n++){
    uint32_t qa = Q[n-1u], qb = Q[n-2u];
    if (qa == 0u || qb == 0u || qa >= n || qb >= n){
      printf("  DEATH at n=%u: Q(n-1)=%u Q(n-2)=%u -> lookup index outside [1,n-1]\n", n, qa, qb);
      return 1;
    }
    Q[n] = Q[n - qa] + Q[n - qb];
    if (Q[n] > n){ qgtn++; if (!first_qgtn) first_qgtn = n; }
  }
  static const uint32_t k15[15] = {1,1,2,3,3,4,5,5,6,6,6,8,8,8,10};
  int pref = 1;
  for (int i = 0; i < 15; i++) if (Q[i+1] != k15[i]) pref = 0;
  printf("  prefix Q(1..15) check: %s\n", pref ? "PASS" : "FAIL");
  int q1e5 = 1;
  if (NN >= 100000u){
    q1e5 = (Q[100000] == 48157u);
    printf("  Q(100000) = %u (expected 48157): %s\n", Q[100000], q1e5 ? "PASS" : "FAIL");
  }
  if (NN >= (1u<<20)){
    uint64_t s = 0u;
    for (uint32_t i = 1u; i <= (1u<<20); i++) s += Q[i];
    printf("  Q(2^20) = %u\n", Q[1u<<20]);
    printf("  sum(Q(1..2^20)) mod 2^64 = %llu\n", (unsigned long long)s);
  }
  if (NN >= (1u<<24)) printf("  Q(2^24) = %u\n", Q[1u<<24]);
  printf("  death-condition violations: 0 (sequence defined up to n=2^%u)\n", LOGN);
  printf("  Q(n)>n violations: %llu%s\n", (unsigned long long)qgtn,
         qgtn ? " (ANOMALY!)" : "");
  printf("  [%.2f s]\n\n", now_s() - t0);
  fflush(stdout);
  return (pref && q1e5 && qgtn == 0u) ? 0 : 2;
}

/* ---- Phase 2: exact spillover ---- */
static void phase2(void){
  double t0 = now_s();
  uint32_t klo = (LOGN >= 25u) ? 15u : ((SEEDLOG > 5u) ? SEEDLOG - 5u : 3u);
  printf("== PHASE 2: exact lookup spillover, G_k=[2^k,2^(k+1)) ==\n");
  printf("  For n in G_k, lookups i1=n-Q(n-1), i2=n-Q(n-2) (2*2^k lookups per generation).\n");
  printf("  'below' = lookup < 2^(k-1);  'above' = lookup >= 2^k;  else it is inside G_(k-1).\n");
  printf("   k |    #below     frac_below |    #above     frac_above |  #n any-outside   frac_n\n");
  for (uint32_t k = klo; k < LOGN; k++){
    uint32_t gs = 1u << k, ge = 1u << (k+1u);
    uint32_t lob = 1u << (k-1u);
    uint64_t below = 0, above = 0, nany = 0;
    for (uint32_t n = gs; n < ge; n++){
      uint32_t i1 = n - Q[n-1u], i2 = n - Q[n-2u];
      int b1 = (i1 < lob), b2 = (i2 < lob), u1 = (i1 >= gs), u2 = (i2 >= gs);
      below += (uint64_t)(b1 + b2); above += (uint64_t)(u1 + u2);
      if (b1 | b2 | u1 | u2) nany++;
    }
    uint64_t tot = 2ull * (uint64_t)(ge - gs);
    printf("  %2u | %9llu  %11.6f | %9llu  %11.6f | %12llu  %9.6f\n",
      k, (unsigned long long)below, (double)below/(double)tot,
         (unsigned long long)above, (double)above/(double)tot,
         (unsigned long long)nany, (double)nany/(double)(ge-gs));
  }
  printf("  [%.2f s]\n\n", now_s() - t0);
  fflush(stdout);
}

/* ---- Phase 3: one interval run ---- */
static void run_interval(uint32_t E0){
  double t0 = now_s();
  printf("== PHASE 3: interval propagation, E0 = %u  (fuzz +-E0 on G_%u=[2^%u,2^%u), all earlier seeds exact) ==\n",
         E0, SEEDLOG-1u, SEEDLOG-1u, SEEDLOG);
  /* init leaves */
  for (uint32_t i = NN; i < 2u*NN; i++){ tmin[i] = UINT32_MAX; tmax[i] = 0u; }
  for (uint32_t p = 1u; p <= SEED_END; p++){
    uint32_t lo, hi; seed_vals(p, E0, &lo, &hi);
    tmin[leafi(p)] = lo; tmax[leafi(p)] = hi;
  }
  for (uint32_t i = NN - 1u; i >= 1u; i--){
    uint32_t a = tmin[2u*i], b = tmin[2u*i+1u]; tmin[i] = (a<b)?a:b;
    a = tmax[2u*i]; b = tmax[2u*i+1u]; tmax[i] = (a>b)?a:b;
  }
  /* segment-tree query self-test vs direct scan */
  {
    srand(12345u + E0);
    uint64_t bad = 0;
    for (int t = 0; t < 1000; t++){
      uint32_t len = 1u + (uint32_t)(rand() % 4000);
      if (len > SEED_END) len = SEED_END;
      uint32_t a = 1u + ((uint32_t)rand() % (SEED_END - len + 1u));
      uint32_t b = a + len - 1u;
      uint32_t m = UINT32_MAX, M = 0u;
      for (uint32_t i = a; i <= b; i++){
        uint32_t x = tmin[leafi(i)]; if (x < m) m = x;
        x = tmax[leafi(i)]; if (x > M) M = x;
      }
      if (rmin(a,b) != m || rmax(a,b) != M) bad++;
    }
    printf("  segtree selftest (1000 random ranges vs direct scan): %s\n", bad ? "FAIL" : "PASS");
  }
  /* naive reference on a prefix (whole run when N small) */
  uint32_t vsteps = (NN <= (1u<<18)) ? (NN - SEED_END) : ((E0 >= 64u) ? 800u : 2500u);
  uint32_t vend = SEED_END + vsteps;
  uint32_t *vlo = (uint32_t*)malloc(((size_t)vend + 2u) * sizeof(uint32_t));
  uint32_t *vhi = (uint32_t*)malloc(((size_t)vend + 2u) * sizeof(uint32_t));
  if (!vlo || !vhi){ fprintf(stderr, "malloc failed (naive)\n"); exit(1); }
  naive_interval(E0, vend, vlo, vhi);
  uint64_t vmis = 0;

  /* per-generation stats */
  uint64_t maxw[40] = {0}, sumw[40] = {0}, cntg[40] = {0};
  for (uint32_t p = FUZZ_LO; p < SEED_END; p++){   /* seed generation G_{SEEDLOG-1} */
    uint64_t w = (uint64_t)tmax[leafi(p)] - tmin[leafi(p)];
    uint32_t k = SEEDLOG - 1u;
    if (w > maxw[k]) maxw[k] = w;
    sumw[k] += w; cntg[k]++;
  }
  cntg[SEEDLOG]++;  /* n=2^SEEDLOG is an exact seed (width 0) belonging to G_SEEDLOG */

  uint64_t clip_low = 0, clip_high = 0, nclip = 0, nsat = 0, cont_bad = 0, e0mis = 0;
  uint32_t first_clip = 0, first_sat = 0, first_halfn = 0;

  for (uint32_t n = SEED_END + 1u; n <= NN; n++){
    uint32_t lo1 = tmin[leafi(n-1u)], hi1 = tmax[leafi(n-1u)];
    uint32_t lo2 = tmin[leafi(n-2u)], hi2 = tmax[leafi(n-2u)];
    int64_t a1 = (int64_t)n - hi1, b1 = (int64_t)n - lo1;
    int64_t a2 = (int64_t)n - hi2, b2 = (int64_t)n - lo2;
    int cl = 0;
    if (a1 < 1){ clip_low++; cl = 1; a1 = 1; }
    if (b1 > (int64_t)n - 1){ clip_high++; cl = 1; b1 = (int64_t)n - 1; }
    if (a2 < 1){ clip_low++; cl = 1; a2 = 1; }
    if (b2 > (int64_t)n - 1){ clip_high++; cl = 1; b2 = (int64_t)n - 1; }
    if (cl){ nclip++; if (!first_clip) first_clip = n; }
    uint32_t m1 = rmin((uint32_t)a1, (uint32_t)b1), M1 = rmax((uint32_t)a1, (uint32_t)b1);
    uint32_t m2 = rmin((uint32_t)a2, (uint32_t)b2), M2 = rmax((uint32_t)a2, (uint32_t)b2);
    uint64_t lo64 = (uint64_t)m1 + m2, hi64 = (uint64_t)M1 + M2;
    if (hi64 > (uint64_t)SATHI){ nsat++; if (!first_sat) first_sat = n; hi64 = (uint64_t)SATHI; }
    uint32_t lon = (uint32_t)lo64, hin = (uint32_t)hi64;
    if (lon > Q[n] || hin < Q[n]) cont_bad++;
    tree_set(n, lon, hin);
    uint64_t w = (uint64_t)hin - lon;
    if (!first_halfn && w >= (uint64_t)(n/2u)) first_halfn = n;
    uint32_t k = 31u - (uint32_t)__builtin_clz(n);
    if (k >= SEEDLOG && k <= LOGN - 1u){
      if (w > maxw[k]) maxw[k] = w;
      sumw[k] += w; cntg[k]++;
    }
    if (n <= vend && (lon != vlo[n] || hin != vhi[n])) vmis++;
    if (E0 == 0u && (lon != Q[n] || hin != Q[n])) e0mis++;
  }
  free(vlo); free(vhi);

  printf("  naive-reference check on first %u computed n: %s (%llu mismatches)\n",
         vsteps, vmis ? "FAIL" : "PASS", (unsigned long long)vmis);
  if (E0 == 0u)
    printf("  E0=0 exactness sanity check (lo=Q=hi at every computed n): %s (%llu mismatches)\n",
           e0mis ? "FAIL" : "PASS", (unsigned long long)e0mis);
  printf("  containment lo(n)<=Q(n)<=hi(n) violations: %llu (must be 0)\n",
         (unsigned long long)cont_bad);

  printf("  width ramp checkpoints (leaf values after run):\n");
  const uint64_t offs[] = {1,2,5,10,100,1000,10000,100000,1000000};
  for (size_t j = 0; j < sizeof(offs)/sizeof(offs[0]); j++){
    uint64_t nn64 = (uint64_t)SEED_END + offs[j];
    if (nn64 > (uint64_t)NN) break;
    uint32_t n = (uint32_t)nn64;
    uint32_t lo = tmin[leafi(n)], hi = tmax[leafi(n)];
    printf("    n=2^%u+%-8llu lo=%-10u hi=%-10u width=%-10u Q(n)=%u\n",
           SEEDLOG, (unsigned long long)offs[j], lo, hi, hi-lo, Q[n]);
  }
  for (uint32_t e = SEEDLOG + 1u; e <= LOGN; e++){
    uint32_t n = 1u << e;
    uint32_t lo = tmin[leafi(n)], hi = tmax[leafi(n)];
    printf("    n=2^%-11u lo=%-10u hi=%-10u width=%-10u Q(n)=%u\n", e, lo, hi, hi-lo, Q[n]);
  }

  printf("  per-generation interval widths (hi-lo):\n");
  printf("     k |      max_width |      mean_width | maxw(G_k)/maxw(G_(k-1)) | meanw ratio\n");
  for (uint32_t k = SEEDLOG - 1u; k <= LOGN - 1u; k++){
    double mean = cntg[k] ? (double)sumw[k] / (double)cntg[k] : 0.0;
    char r1[32], r2[32];
    if (k == SEEDLOG - 1u){ strcpy(r1, "(seed)"); strcpy(r2, "(seed)"); }
    else {
      if (maxw[k-1u]) snprintf(r1, sizeof r1, "%.4g", (double)maxw[k]/(double)maxw[k-1u]);
      else strcpy(r1, maxw[k] ? "inf" : "0/0");
      double pm = cntg[k-1u] ? (double)sumw[k-1u]/(double)cntg[k-1u] : 0.0;
      if (pm > 0.0) snprintf(r2, sizeof r2, "%.4g", mean/pm);
      else strcpy(r2, mean > 0.0 ? "inf" : "0/0");
    }
    printf("    %2u | %14llu | %15.6g | %23s | %s\n",
           k, (unsigned long long)maxw[k], mean, r1, r2);
  }
  printf("  clipping to [1,n-1]: low-side events=%llu, high-side events=%llu, distinct n clipped=%llu, first clipped n=%u\n",
         (unsigned long long)clip_low, (unsigned long long)clip_high,
         (unsigned long long)nclip, first_clip);
  printf("  hi-saturation (hi capped at %u): events=%llu, first n=%u\n",
         SATHI, (unsigned long long)nsat, first_sat);
  printf("  first n with width >= n/2 (vacuous scale): %u\n", first_halfn);
  printf("  [%.2f s]\n\n", now_s() - t0);
  fflush(stdout);
}

int main(int argc, char **argv){
  double T0 = now_s();
  if (argc >= 2) LOGN = (uint32_t)atoi(argv[1]);
  if (argc >= 3) SEEDLOG = (uint32_t)atoi(argv[2]);
  if (LOGN < 6u || LOGN > 27u || SEEDLOG < 3u || SEEDLOG >= LOGN){
    fprintf(stderr, "bad params: LOGN in [6,27], SEEDLOG in [3,LOGN-1]\n");
    return 1;
  }
  NN = 1u << LOGN; SEED_END = 1u << SEEDLOG; FUZZ_LO = SEED_END >> 1u;
  printf("Hofstadter Q generation-transfer interval experiment\n");
  printf("N = 2^%u = %u; seeds exact on [1, 2^%u] except +-E0 fuzz on G_%u = [2^%u, 2^%u); propagate to 2^%u\n",
         LOGN, NN, SEEDLOG, SEEDLOG-1u, SEEDLOG-1u, SEEDLOG, LOGN);
  {
    size_t bytes = ((size_t)NN + 2u)*sizeof(uint32_t) + 2u*((size_t)2u*NN)*sizeof(uint32_t);
    printf("approx peak RAM: %.0f MB (single-threaded)\n\n", (double)bytes/1048576.0);
  }
  Q    = (uint32_t*)malloc(((size_t)NN + 2u) * sizeof(uint32_t));
  tmin = (uint32_t*)malloc((size_t)2u * NN * sizeof(uint32_t));
  tmax = (uint32_t*)malloc((size_t)2u * NN * sizeof(uint32_t));
  if (!Q || !tmin || !tmax){ fprintf(stderr, "malloc failed\n"); return 1; }
  int rc = phase1();
  if (rc){ fprintf(stderr, "phase1 validation failed (rc=%d) - aborting\n", rc); return rc; }
  phase2();
  const uint32_t E0s[4] = {0u, 1u, 8u, 64u};
  for (int i = 0; i < 4; i++) run_interval(E0s[i]);
  printf("TOTAL time: %.2f s\n", now_s() - T0);
  return 0;
}
