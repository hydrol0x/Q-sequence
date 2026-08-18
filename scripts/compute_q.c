/*
 * compute_q.c — exact-integer computation of the Hofstadter Q-sequence with
 * diagnostics for the research phase.
 *
 *     Q(1) = 1, Q(2) = 1,
 *     Q(n) = Q(n - Q(n-1)) + Q(n - Q(n-2))   for n >= 3;
 *     dies at n  iff  Q(n-1) >= n or Q(n-2) >= n.
 *
 * Exactness: all arithmetic is unsigned 64-bit; values are stored as uint32.
 * Storage is valid as long as Q(m) <= m (checked every step: an "ANOMALY" is
 * reported if Q(m) > m ever occurs, which doubles as a machine check of the
 * invariant `Q(m) <= m` — the exact statement equivalent to immortality).
 * Sums are formed in uint64 before the <= n check, so no overflow can occur
 * unobserved for N < 2^32.
 *
 * Outputs (to data/):
 *   records_absdev.txt : record values of |2Q(n) - n|   (n, 2Q-n signed)
 *   records_ratio.txt  : record values of Q(n)/n, n >= 3 (n, Q(n))
 *   records_jump.txt   : record values of |Q(n)-Q(n-1)|  (n, Q(n)-Q(n-1) signed)
 *   generations.txt    : per-dyadic-generation table (see header line)
 * and a summary to stdout, including checkpoint values + checksums for
 * independent cross-verification.
 *
 * Usage: compute_q N [datadir]
 */
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

typedef unsigned __int128 u128;
typedef __int128 i128;

static void print_i128(FILE *f, i128 v) {
    if (v < 0) { fputc('-', f); v = -v; }
    char buf[64]; int i = 0;
    if (v == 0) { fputc('0', f); return; }
    while (v > 0) { buf[i++] = '0' + (int)(v % 10); v /= 10; }
    while (i > 0) fputc(buf[--i], f);
}

int main(int argc, char **argv) {
    uint64_t N = (argc > 1) ? strtoull(argv[1], 0, 10) : 1000000000ULL;
    const char *dir = (argc > 2) ? argv[2] : "data";
    if (N < 3 || N >= (1ULL << 32)) { fprintf(stderr, "need 3 <= N < 2^32\n"); return 1; }

    uint32_t *q = malloc((N + 1) * sizeof(uint32_t));
    if (!q) { fprintf(stderr, "alloc failed (%llu bytes)\n", (unsigned long long)((N+1)*4)); return 1; }
    q[0] = 0; q[1] = 1; q[2] = 1;

    char path[512];
    snprintf(path, sizeof path, "%s/records_absdev.txt", dir); FILE *fdev = fopen(path, "w");
    snprintf(path, sizeof path, "%s/records_ratio.txt",  dir); FILE *frat = fopen(path, "w");
    snprintf(path, sizeof path, "%s/records_jump.txt",   dir); FILE *fjmp = fopen(path, "w");
    snprintf(path, sizeof path, "%s/generations.txt",    dir); FILE *fgen = fopen(path, "w");
    if (!fdev || !frat || !fjmp || !fgen) { fprintf(stderr, "cannot open output files in %s/\n", dir); return 1; }
    fprintf(fdev, "# record |2Q(n)-n|: n  2Q(n)-n\n");
    fprintf(frat, "# record Q(n)/n (n>=3): n  Q(n)\n");
    fprintf(fjmp, "# record |Q(n)-Q(n-1)|: n  Q(n)-Q(n-1)\n");

    /* records */
    uint64_t maxdev = 0;                 /* |2Q(n)-n| */
    uint64_t maxjump = 0;                /* |Q(n)-Q(n-1)| */
    uint64_t bestrn = 0, bestrd = 1;     /* max Q(n)/n as fraction bestrn/bestrd, n>=3 */

    /* per-generation stats, k = floor(log2 n): n in [2^k, 2^{k+1}) */
    enum { KMAX = 40 };
    uint64_t g_cnt[KMAX] = {0};
    uint64_t g_maxdev[KMAX] = {0};      uint64_t g_maxdev_n[KMAX] = {0};
    i128     g_sumdev[KMAX] = {0};      /* sum of (2Q(n)-n), signed */
    uint64_t g_maxrat_num[KMAX] = {0};  uint64_t g_maxrat_den[KMAX] = {0};
    uint64_t g_look_below[KMAX] = {0};  /* lookup index < 2^{k-1} (below parent gen) */
    uint64_t g_look_same[KMAX]  = {0};  /* lookup index >= 2^k (inside own gen)      */
    uint64_t g_look_par[KMAX]   = {0};  /* lookup index in parent gen [2^{k-1},2^k)  */

    /* checkpoints for cross-verification */
    const uint64_t cps[] = {1000000ULL, 10000000ULL, 100000000ULL, 500000000ULL, 1000000000ULL, 2000000000ULL};
    const int ncps = sizeof(cps)/sizeof(cps[0]);

    uint64_t anomaly = 0; /* count of n with Q(n) > n (never expected) */

    for (uint64_t n = 3; n <= N; n++) {
        uint64_t qn1 = q[n-1], qn2 = q[n-2];
        if (qn1 >= n || qn2 >= n) {
            printf("DEATH at n = %" PRIu64 ": Q(n-1)=%" PRIu64 ", Q(n-2)=%" PRIu64 "\n", n, qn1, qn2);
            printf("NOTE: any true death index exceeds 3e10; a small one means a bug.\n");
            return 2;
        }
        uint64_t i1 = n - qn1, i2 = n - qn2;           /* in [1, n-1] */
        uint64_t v = (uint64_t)q[i1] + (uint64_t)q[i2]; /* exact, < 2^33 */
        if (v > n) {                                    /* invariant Q(n) <= n check */
            anomaly++;
            if (anomaly < 10)
                printf("ANOMALY: Q(%" PRIu64 ") = %" PRIu64 " > n\n", n, v);
            if (v > 0xFFFFFFFFULL) { printf("FATAL: value overflow at n=%" PRIu64 "\n", n); return 3; }
        }
        q[n] = (uint32_t)v;

        /* deviation record */
        int64_t dev = (int64_t)(2*v) - (int64_t)n;
        uint64_t ad = (dev < 0) ? (uint64_t)(-dev) : (uint64_t)dev;
        if (ad > maxdev) { maxdev = ad; fprintf(fdev, "%" PRIu64 " %" PRId64 "\n", n, dev); }
        /* ratio record: v/n > bestrn/bestrd  <=>  v*bestrd > bestrn*n */
        if ((u128)v * bestrd > (u128)bestrn * n) {
            bestrn = v; bestrd = n; fprintf(frat, "%" PRIu64 " %" PRIu64 "\n", n, v);
        }
        /* jump record */
        int64_t j = (int64_t)v - (int64_t)qn1;
        uint64_t aj = (j < 0) ? (uint64_t)(-j) : (uint64_t)j;
        if (aj > maxjump) { maxjump = aj; fprintf(fjmp, "%" PRIu64 " %" PRId64 "\n", n, j); }

        /* generation stats */
        int k = 63 - __builtin_clzll(n);
        g_cnt[k]++;
        if (ad > g_maxdev[k]) { g_maxdev[k] = ad; g_maxdev_n[k] = n; }
        g_sumdev[k] += dev;
        if ((u128)v * g_maxrat_den[k] > (u128)g_maxrat_num[k] * n || g_maxrat_den[k] == 0) {
            g_maxrat_num[k] = v; g_maxrat_den[k] = n;
        }
        uint64_t lo = 1ULL << (k-1), hi = 1ULL << k;   /* parent gen = [lo, hi) */
        if (i1 < lo) g_look_below[k]++; else if (i1 >= hi) g_look_same[k]++; else g_look_par[k]++;
        if (i2 < lo) g_look_below[k]++; else if (i2 >= hi) g_look_same[k]++; else g_look_par[k]++;

        if ((n & ((1ULL<<26)-1)) == 0)
            fprintf(stderr, "  ... n = %" PRIu64 "  maxdev=%" PRIu64 " (%.5f of n)\n",
                    n, maxdev, (double)maxdev / (double)n);
    }

    printf("SURVIVES through N = %" PRIu64 "  (no death; %" PRIu64 " anomalies Q(n)>n)\n", N, anomaly);
    printf("Q(N) = %u   2Q(N)-N = %" PRId64 "\n", q[N], (int64_t)2*q[N]-(int64_t)N);
    printf("max |2Q(n)-n| = %" PRIu64 "   max |Q(n)-Q(n-1)| = %" PRIu64 "\n", maxdev, maxjump);
    printf("max Q(n)/n (n>=3) = %" PRIu64 "/%" PRIu64 " = %.6f\n", bestrn, bestrd, (double)bestrn/(double)bestrd);

    /* checkpoints: value + additive checksum for independent cross-checks */
    for (int c = 0; c < ncps; c++) {
        uint64_t cp = cps[c];
        if (cp > N) break;
        u128 sum = 0;
        for (uint64_t m = 1; m <= cp; m++) sum += q[m];
        printf("CHECK n=%" PRIu64 "  Q(n)=%u  sum(Q(1..n)) mod 2^64 = %" PRIu64 "\n",
               cp, q[cp], (uint64_t)sum);
    }

    fprintf(fgen, "# k  span=[2^k,2^{k+1})  count  max|2Q-n|  max|2Q-n|/2^k  at_n  "
                  "mean(2Q-n)  maxQ/n  lookups:below_parent  in_parent  in_own_gen\n");
    for (int k = 1; k < KMAX; k++) {
        if (!g_cnt[k]) continue;
        double meandev = (double)((i128)g_sumdev[k]) / (double)g_cnt[k];
        fprintf(fgen, "%2d  %" PRIu64 "  %" PRIu64 "  %.6f  %" PRIu64 "  ",
                k, g_cnt[k], g_maxdev[k], (double)g_maxdev[k]/(double)(1ULL<<k), g_maxdev_n[k]);
        print_i128(fgen, (i128)(g_sumdev[k]));
        fprintf(fgen, "  %.2f  %.6f  %" PRIu64 "  %" PRIu64 "  %" PRIu64 "\n",
                meandev,
                g_maxrat_den[k] ? (double)g_maxrat_num[k]/(double)g_maxrat_den[k] : 0.0,
                g_look_below[k], g_look_par[k], g_look_same[k]);
    }
    fclose(fdev); fclose(frat); fclose(fjmp); fclose(fgen);
    return 0;
}
