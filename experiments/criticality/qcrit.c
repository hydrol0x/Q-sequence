/* qcrit.c — exact deviation-propagation statistics for the Hofstadter Q-sequence.
 *
 * Definition (1-indexed): Q(1)=Q(2)=1, Q(n) = Q(n-Q(n-1)) + Q(n-Q(n-2)) for n>=3.
 * Quantities:
 *   e(m) = 2Q(m) - m
 *   a = n - Q(n-1), b = n - Q(n-2)          (the two lookup positions)
 *   R(n) = e(a) + e(b)                       (reinforcement)
 *   D(n) = n - Q(n-1) - Q(n-2)               (damping term)
 *   S(n) = e(n-1) + e(n-2)
 *   d(n) = Q(n) - Q(n-1)
 * Exact identities (theorems; checked numerically as machinery test):
 *   (I1) e(n) = e(a) + e(b) + D(n)
 *   (I2) 2 D(n) = 3 - e(n-1) - e(n-2)   i.e.  2D = 3 - S
 *   (I3) b - a = Q(n-1) - Q(n-2)
 *
 * Arithmetic policy:
 *   - Q stored as uint32; all per-step quantities computed in exact int64;
 *   - all statistical accumulators are exact __int128 (sums of int64 products);
 *   - long double (x87 80-bit) is used ONLY in the final statistical summaries
 *     (divisions, sqrt, log2, Pearson correlations, least-squares fit).
 *   - extremal ratios (Q(n)/n, e(n)/n, |e(n)|/n) are compared EXACTLY by
 *     __int128 cross-multiplication; a conservative double prefilter only
 *     decides whether to run the exact comparison.
 *
 * Per-dyadic-generation statistics for G_k = [2^k, 2^(k+1)), k = 10..28
 * (top generation truncated at NMAX).
 *
 * Build: gcc -O3 -march=native -Wall -Wextra -o qcrit qcrit.c -lm
 * Run:   ./qcrit [NMAX]      (default 500000000)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <inttypes.h>
#include <math.h>
#include <time.h>
#include <sys/resource.h>

typedef __int128 i128;

#define HCAP (1u<<25)  /* |d| histogram capacity; ad>=HCAP counted as overflow (max still exact) */

static uint32_t *Q, *hist;

/* ---------- exact-fraction top-10 machinery ---------- */
typedef struct { int64_t num; uint64_t den; } Frac;

static int frac_gt(int64_t n1, uint64_t d1, int64_t n2, uint64_t d2) {
    return (i128)n1 * (i128)d2 > (i128)n2 * (i128)d1;   /* exact: dens > 0 */
}

static void top_insert(Frac *arr, int *cnt, double *thr, int64_t num, uint64_t den) {
    int c = *cnt;
    if (c == 10) {
        if (frac_gt(num, den, arr[9].num, arr[9].den)) {
            int i = 9;
            while (i > 0 && frac_gt(num, den, arr[i-1].num, arr[i-1].den)) i--;
            for (int j = 9; j > i; j--) arr[j] = arr[j-1];
            arr[i].num = num; arr[i].den = den;
        }
    } else {
        int i = c;
        while (i > 0 && frac_gt(num, den, arr[i-1].num, arr[i-1].den)) i--;
        for (int j = c; j > i; j--) arr[j] = arr[j-1];
        arr[i].num = num; arr[i].den = den;
        *cnt = c + 1;
    }
    if (*cnt == 10) {   /* conservative prefilter threshold slightly below exact 10th ratio */
        double t = (double)arr[9].num / (double)arr[9].den;
        *thr = t - fabs(t)*1e-12 - 1e-12;
    }
}

static uint64_t gcd_u64(uint64_t x, uint64_t y) { while (y) { uint64_t t = x % y; x = y; y = t; } return x; }

/* ---------- per-generation results ---------- */
typedef struct {
    int k; uint64_t lo, hi, cnt;
    long double mean_e, mean_abs, sd_e, sd_R, sd_D, sd_S, corr_ab, corr_RS;
    int64_t max_abs_e; uint64_t max_abs_e_n;
    int64_t q50, q90, q99, q100;
    uint64_t hist_over;
    int64_t mq_q; uint64_t mq_n;   /* argmax Q(n)/n in generation */
    int64_t me_v; uint64_t me_n;   /* argmax |e(n)|/n in generation */
    int varS_exact_ok;             /* exact __int128 check: SS_S == 4*SS_D (from I2) */
} Row;

static Row rows[40];
static int nrows = 0;

static long double sample_sd(uint64_t cnt, i128 sum2, int64_t sum) {
    i128 num = (i128)cnt * sum2 - (i128)sum * (i128)sum;      /* exact */
    long double v = (long double)num / ((long double)cnt * (long double)(cnt - 1));
    return sqrtl(v);
}

static long double pearson(uint64_t cnt, int64_t sx, int64_t sy, i128 sxx, i128 syy, i128 sxy) {
    i128 cov = (i128)cnt * sxy - (i128)sx * (i128)sy;         /* exact */
    i128 vx  = (i128)cnt * sxx - (i128)sx * (i128)sx;
    i128 vy  = (i128)cnt * syy - (i128)sy * (i128)sy;
    return (long double)cov / sqrtl((long double)vx * (long double)vy);
}

static double fit_slope(int kmin, int kmax, int use_max, double *intercept) {
    double sx = 0, sy = 0, sxx = 0, sxy = 0; int m = 0;
    for (int i = 0; i < nrows; i++) {
        int k = rows[i].k;
        if (k < kmin || k > kmax) continue;
        double y = use_max ? log2((double)rows[i].max_abs_e) : (double)log2l(rows[i].sd_e);
        sx += k; sy += y; sxx += (double)k * k; sxy += k * y; m++;
    }
    double a = (m * sxy - sx * sy) / (m * sxx - sx * sx);
    if (intercept) *intercept = (sy - a * sx) / m;
    return a;
}

int main(int argc, char **argv) {
    uint64_t NMAX = 500000000ULL;
    if (argc > 1) NMAX = strtoull(argv[1], NULL, 10);
    struct timespec t0, t1;
    clock_gettime(CLOCK_MONOTONIC, &t0);

    Q = malloc((size_t)(NMAX + 2) * sizeof(uint32_t));
    hist = calloc((size_t)HCAP, sizeof(uint32_t));
    if (!Q || !hist) { fprintf(stderr, "alloc failed\n"); return 1; }
    Q[1] = 1; Q[2] = 1;

    uint64_t death_checks = 0, death_anom = 0;
    uint64_t inv_checks = 0, inv_anom = 0;
    uint64_t idc_1e6 = 0, v1_1e6 = 0, v2_1e6 = 0, v3_1e6 = 0;
    uint64_t idc_all = 0, v1_all = 0, v2_all = 0, v3_all = 0;

    Frac topQ[10]; int nTopQ = 0; double thrQ = -1e300;
    Frac topE[10]; int nTopE = 0; double thrE = -1e300;

    uint64_t qn1 = Q[2], qn2 = Q[1];
    uint64_t n;

    /* ---- pre-generation segment: n = 3 .. 1023 (checks + extremals; no gen stats) ---- */
    uint64_t pre_hi = NMAX < 1023 ? NMAX : 1023;
    for (n = 3; n <= pre_hi; n++) {
        death_checks++;
        if (qn1 >= n || qn2 >= n) { death_anom++; fprintf(stderr, "DEATH at n=%" PRIu64 "\n", n); return 2; }
        uint64_t a = n - qn1, b = n - qn2;
        uint64_t Qa = Q[a], Qb = Q[b];
        uint64_t qn = Qa + Qb;
        inv_checks++;
        if (qn > n) inv_anom++;
        Q[n] = (uint32_t)qn;
        int64_t sn = (int64_t)n;
        int64_t en  = 2*(int64_t)qn  - sn;
        int64_t ea  = 2*(int64_t)Qa  - (int64_t)a;
        int64_t eb  = 2*(int64_t)Qb  - (int64_t)b;
        int64_t en1 = 2*(int64_t)qn1 - (sn - 1);
        int64_t en2 = 2*(int64_t)qn2 - (sn - 2);
        int64_t Rn = ea + eb;
        int64_t Dn = sn - (int64_t)qn1 - (int64_t)qn2;
        int64_t Sn = en1 + en2;
        idc_all++;
        int c1 = (en != Rn + Dn);
        int c2 = (2*Dn != 3 - Sn);
        int c3 = ((int64_t)b - (int64_t)a != (int64_t)qn1 - (int64_t)qn2);
        v1_all += c1; v2_all += c2; v3_all += c3;
        idc_1e6++; v1_1e6 += c1; v2_1e6 += c2; v3_1e6 += c3;
        if (n >= 100) {
            if ((double)(int64_t)qn > thrQ * (double)sn) top_insert(topQ, &nTopQ, &thrQ, (int64_t)qn, n);
            if ((double)en > thrE * (double)sn) top_insert(topE, &nTopE, &thrE, en, n);
        }
        qn2 = qn1; qn1 = qn;
    }

    /* ---- dyadic generations G_k = [2^k, min(2^(k+1)-1, NMAX)] ---- */
    for (int k = 10; (1ULL << k) <= NMAX; k++) {
        uint64_t lo = 1ULL << k;
        uint64_t hi = (1ULL << (k + 1)) - 1; if (hi > NMAX) hi = NMAX;

        int64_t sum_e = 0, sum_abs = 0, max_abs_e = 0; uint64_t max_abs_e_n = 0;
        i128 se2 = 0;
        int64_t sum_R = 0, sum_D = 0, sum_S = 0;
        i128 sR2 = 0, sD2 = 0, sS2 = 0, sRS = 0;
        int64_t sum_ea = 0, sum_eb = 0;
        i128 sa2 = 0, sb2 = 0, sab = 0;
        int64_t max_abs_d = 0; uint64_t hist_over = 0;
        int64_t gq_q = 0; uint64_t gq_n = 0; double gq_thr = -1e300;
        int64_t ge_v = -1; uint64_t ge_n = 0; double ge_thr = -1e300;

        for (n = lo; n <= hi; n++) {
            death_checks++;
            if (qn1 >= n || qn2 >= n) { death_anom++; fprintf(stderr, "DEATH at n=%" PRIu64 "\n", n); return 2; }
            uint64_t a = n - qn1, b = n - qn2;
            uint64_t Qa = Q[a], Qb = Q[b];
            uint64_t qn = Qa + Qb;
            inv_checks++;
            if (qn > n) inv_anom++;
            Q[n] = (uint32_t)qn;
            int64_t sn = (int64_t)n;
            int64_t en  = 2*(int64_t)qn  - sn;
            int64_t ea  = 2*(int64_t)Qa  - (int64_t)a;
            int64_t eb  = 2*(int64_t)Qb  - (int64_t)b;
            int64_t en1 = 2*(int64_t)qn1 - (sn - 1);
            int64_t en2 = 2*(int64_t)qn2 - (sn - 2);
            int64_t Rn = ea + eb;
            int64_t Dn = sn - (int64_t)qn1 - (int64_t)qn2;
            int64_t Sn = en1 + en2;
            int64_t d  = (int64_t)qn - (int64_t)qn1;

            idc_all++;
            int c1 = (en != Rn + Dn);
            int c2 = (2*Dn != 3 - Sn);
            int c3 = ((int64_t)b - (int64_t)a != (int64_t)qn1 - (int64_t)qn2);
            v1_all += c1; v2_all += c2; v3_all += c3;
            if (n <= 1000000ULL) { idc_1e6++; v1_1e6 += c1; v2_1e6 += c2; v3_1e6 += c3; }

            sum_e += en;
            int64_t ae = en < 0 ? -en : en;
            sum_abs += ae;
            if (ae > max_abs_e) { max_abs_e = ae; max_abs_e_n = n; }
            se2 += (i128)(en * en);
            sum_R += Rn; sum_D += Dn; sum_S += Sn;
            sR2 += (i128)(Rn * Rn); sD2 += (i128)(Dn * Dn); sS2 += (i128)(Sn * Sn);
            sRS += (i128)(Rn * Sn);
            sum_ea += ea; sum_eb += eb;
            sa2 += (i128)(ea * ea); sb2 += (i128)(eb * eb); sab += (i128)(ea * eb);

            int64_t ad = d < 0 ? -d : d;
            if (ad > max_abs_d) max_abs_d = ad;
            if ((uint64_t)ad >= HCAP) hist_over++; else hist[ad]++;

            if ((double)(int64_t)qn > gq_thr * (double)sn) {
                if (gq_n == 0 || frac_gt((int64_t)qn, n, gq_q, gq_n)) {
                    gq_q = (int64_t)qn; gq_n = n;
                    double t = (double)qn / (double)n; gq_thr = t - t*1e-12;
                }
            }
            if ((double)ae > ge_thr * (double)sn) {
                if (ge_n == 0 || frac_gt(ae, n, ge_v, ge_n)) {
                    ge_v = ae; ge_n = n;
                    double t = (double)ae / (double)n; ge_thr = t - t*1e-12 - 1e-15;
                }
            }
            if ((double)(int64_t)qn > thrQ * (double)sn) top_insert(topQ, &nTopQ, &thrQ, (int64_t)qn, n);
            if ((double)en > thrE * (double)sn) top_insert(topE, &nTopE, &thrE, en, n);

            qn2 = qn1; qn1 = qn;
        }

        /* flush generation row */
        Row *r = &rows[nrows++];
        uint64_t cnt = hi - lo + 1;
        r->k = k; r->lo = lo; r->hi = hi; r->cnt = cnt;
        r->mean_e   = (long double)sum_e / (long double)cnt;
        r->mean_abs = (long double)sum_abs / (long double)cnt;
        r->sd_e = sample_sd(cnt, se2, sum_e);
        r->sd_R = sample_sd(cnt, sR2, sum_R);
        r->sd_D = sample_sd(cnt, sD2, sum_D);
        r->sd_S = sample_sd(cnt, sS2, sum_S);
        r->corr_ab = pearson(cnt, sum_ea, sum_eb, sa2, sb2, sab);
        r->corr_RS = pearson(cnt, sum_R, sum_S, sR2, sS2, sRS);
        r->max_abs_e = max_abs_e; r->max_abs_e_n = max_abs_e_n;
        r->hist_over = hist_over;
        r->mq_q = gq_q; r->mq_n = gq_n;
        r->me_v = ge_v; r->me_n = ge_n;
        {   /* exact integer machinery check from I2 over the WHOLE generation: SS_S == 4*SS_D */
            i128 ssd = (i128)cnt * sD2 - (i128)sum_D * (i128)sum_D;
            i128 sss = (i128)cnt * sS2 - (i128)sum_S * (i128)sum_S;
            r->varS_exact_ok = (sss == 4 * ssd);
        }
        {   /* |d| quantiles: q = smallest v with #{|d|<=v} >= ceil(q*cnt); q100 = exact max */
            uint64_t t50 = (cnt + 1) / 2;
            uint64_t t90 = (9 * cnt + 9) / 10;
            uint64_t t99 = (99 * cnt + 99) / 100;
            uint64_t cum = 0; int64_t q50 = -1, q90 = -1, q99 = -1;
            for (uint32_t vv = 0; vv < HCAP; vv++) {
                cum += hist[vv];
                if (q50 < 0 && cum >= t50) q50 = vv;
                if (q90 < 0 && cum >= t90) q90 = vv;
                if (q99 < 0 && cum >= t99) { q99 = vv; break; }
            }
            r->q50 = q50; r->q90 = q90; r->q99 = q99; r->q100 = max_abs_d;
        }
        {   /* clear only the touched histogram prefix */
            uint64_t used = (uint64_t)(max_abs_d < (int64_t)HCAP ? max_abs_d + 1 : (int64_t)HCAP);
            memset(hist, 0, (size_t)used * sizeof(uint32_t));
        }
        clock_gettime(CLOCK_MONOTONIC, &t1);
        fprintf(stderr, "gen k=%2d done (n<=%" PRIu64 ")  %.1fs\n", k, hi,
                (t1.tv_sec - t0.tv_sec) + (t1.tv_nsec - t0.tv_nsec) * 1e-9);
    }

    clock_gettime(CLOCK_MONOTONIC, &t1);
    double elapsed = (t1.tv_sec - t0.tv_sec) + (t1.tv_nsec - t0.tv_nsec) * 1e-9;

    /* =================== output =================== */
    printf("== Hofstadter Q-sequence: exact deviation-propagation statistics ==\n");
    printf("NMAX = %" PRIu64 "\n", NMAX);
    printf("arithmetic: uint32 storage; exact int64 per step; exact __int128 accumulators;\n"
           "            long double (x87 80-bit) ONLY in final summaries (divide/sqrt/log2/corr/fit);\n"
           "            extremal ratios compared exactly by __int128 cross-multiplication.\n\n");

    /* ---- cross-validation ---- */
    printf("[cross-validation]\n");
    {
        static const uint32_t q15[16] = {0,1,1,2,3,3,4,5,5,6,6,6,8,8,8,10};
        int ok = 1;
        printf("Q(1..15) computed = [");
        for (int i = 1; i <= 15; i++) { printf("%u%s", Q[i], i < 15 ? "," : ""); if (Q[i] != q15[i]) ok = 0; }
        printf("]  expected match: %s\n", ok ? "PASS" : "FAIL");
        struct { uint64_t nn; uint32_t expect; } cks[] = {
            {100000ULL, 48157u}, {1000000ULL, 512066u}, {10000000ULL, 5124632u},
            {100000000ULL, 50166508u}, {500000000ULL, 247777817u},
        };
        for (size_t i = 0; i < sizeof(cks)/sizeof(cks[0]); i++) {
            if (cks[i].nn <= NMAX)
                printf("Q(%-9" PRIu64 ") = %-9u  expected %-9u  %s\n", cks[i].nn, Q[cks[i].nn],
                       cks[i].expect, Q[cks[i].nn] == cks[i].expect ? "PASS" : "FAIL");
        }
        if (NMAX >= 100000000ULL) printf("computed Q(10^8)   = %u\n", Q[100000000ULL]);
        if (NMAX >= 500000000ULL) printf("computed Q(5*10^8) = %u\n", Q[500000000ULL]);
    }

    /* ---- anomaly + identity checks ---- */
    printf("\n[anomaly and identity checks]\n");
    printf("death checks (Q(n-1)>=n or Q(n-2)>=n), n=3..NMAX : %" PRIu64 " checks, %" PRIu64 " anomalies\n", death_checks, death_anom);
    printf("invariant Q(n)<=n, n=3..NMAX                     : %" PRIu64 " checks, %" PRIu64 " violations\n", inv_checks, inv_anom);
    printf("identities I1,I2,I3 exact, n<=10^6 (n=3..10^6)   : %" PRIu64 " n checked each; violations I1=%" PRIu64 " I2=%" PRIu64 " I3=%" PRIu64 "\n",
           idc_1e6, v1_1e6, v2_1e6, v3_1e6);
    printf("identities I1,I2,I3 exact, ALL n=3..NMAX         : %" PRIu64 " n checked each; violations I1=%" PRIu64 " I2=%" PRIu64 " I3=%" PRIu64 "\n",
           idc_all, v1_all, v2_all, v3_all);
    {
        int allok = 1;
        for (int i = 0; i < nrows; i++) if (!rows[i].varS_exact_ok) allok = 0;
        printf("per-generation exact __int128 check SS(S)==4*SS(D) (consequence of I2, all n>=1024): %s\n",
               allok ? "0 violations" : "VIOLATIONS PRESENT");
    }

    /* ---- T1: e(n) per generation ---- */
    printf("\n[T1] e(n)=2Q(n)-n per generation G_k=[2^k,2^(k+1)) (k=28 truncated at NMAX)\n");
    printf("%3s %11s %14s %13s %10s %12s %13s %9s %9s\n",
           "k", "cnt", "mean(e)", "mean|e|", "max|e|", "argmax n", "sd(e)", "sd_ratio", "log2r");
    for (int i = 0; i < nrows; i++) {
        Row *r = &rows[i];
        char rat[32] = "--", lg[32] = "--";
        if (i > 0) {
            long double ratio = r->sd_e / rows[i-1].sd_e;
            snprintf(rat, sizeof rat, "%.5Lf", ratio);
            snprintf(lg, sizeof lg, "%.5Lf", log2l(ratio));
        }
        printf("%3d %11" PRIu64 " %14.4Lf %13.4Lf %10" PRId64 " %12" PRIu64 " %13.4Lf %9s %9s\n",
               r->k, r->cnt, r->mean_e, r->mean_abs, r->max_abs_e, r->max_abs_e_n, r->sd_e, rat, lg);
    }

    /* ---- T2: reinforcement vs damping ---- */
    printf("\n[T2] R(n)=e(a)+e(b), D(n)=n-Q(n-1)-Q(n-2), S(n)=e(n-1)+e(n-2)\n");
    printf("%3s %13s %13s %13s %16s %14s\n", "k", "sd(R)", "sd(D)", "sd(S)", "corr(e(a),e(b))", "corr(R,S)");
    for (int i = 0; i < nrows; i++) {
        Row *r = &rows[i];
        printf("%3d %13.4Lf %13.4Lf %13.4Lf %16.6Lf %14.6Lf\n",
               r->k, r->sd_R, r->sd_D, r->sd_S, r->corr_ab, r->corr_RS);
    }

    /* ---- T3: |d| quantiles ---- */
    printf("\n[T3] |d(n)|=|Q(n)-Q(n-1)| quantiles (q = smallest v with #{|d|<=v} >= ceil(q*cnt); q100 exact max)\n");
    printf("%3s %8s %8s %8s %10s %10s\n", "k", "q50", "q90", "q99", "q100=max", "hist_over");
    for (int i = 0; i < nrows; i++) {
        Row *r = &rows[i];
        printf("%3d %8" PRId64 " %8" PRId64 " %8" PRId64 " %10" PRId64 " %10" PRIu64 "\n",
               r->k, r->q50, r->q90, r->q99, r->q100, r->hist_over);
    }

    /* ---- T4: extremal ratios per generation ---- */
    printf("\n[T4] per-generation extremal ratios (exact argmax)\n");
    printf("%3s %12s %12s %14s | %12s %12s %14s\n", "k", "maxQ/n", "at n", "Q(n)", "max|e|/n", "at n", "|e(n)|");
    for (int i = 0; i < nrows; i++) {
        Row *r = &rows[i];
        printf("%3d %12.9f %12" PRIu64 " %14" PRId64 " | %12.9f %12" PRIu64 " %14" PRId64 "\n",
               r->k, (double)r->mq_q / (double)r->mq_n, r->mq_n, r->mq_q,
               (double)r->me_v / (double)r->me_n, r->me_n, r->me_v);
    }

    /* ---- top-10 lists over n in [100, NMAX] ---- */
    printf("\n[top 10] largest Q(n)/n over n in [100, NMAX]\n");
    for (int i = 0; i < nTopQ; i++) {
        uint64_t g = gcd_u64((uint64_t)topQ[i].num, topQ[i].den);
        printf("%2d. n=%-10" PRIu64 " Q(n)=%-10" PRId64 " Q/n = %" PRId64 "/%" PRIu64 " (reduced %" PRId64 "/%" PRIu64 ") = %.9f\n",
               i + 1, topQ[i].den, topQ[i].num, topQ[i].num, topQ[i].den,
               topQ[i].num / (int64_t)g, topQ[i].den / g, (double)topQ[i].num / (double)topQ[i].den);
    }
    printf("\n[top 10] largest e(n)/n over n in [100, NMAX]  (e=2Q-n)\n");
    for (int i = 0; i < nTopE; i++) {
        int64_t nm = topE[i].num; uint64_t dn = topE[i].den;
        uint64_t g = gcd_u64((uint64_t)(nm < 0 ? -nm : nm), dn); if (g == 0) g = 1;
        printf("%2d. n=%-10" PRIu64 " e(n)=%-9" PRId64 " Q(n)=%-10" PRId64 " e/n = %" PRId64 "/%" PRIu64 " (reduced %" PRId64 "/%" PRIu64 ") = %.9f\n",
               i + 1, dn, nm, (nm + (int64_t)dn) / 2, nm, dn, nm / (int64_t)g, dn / g, (double)nm / (double)dn);
    }

    /* ---- fits ---- */
    printf("\n[fits] least squares on log2(y) vs k (y per generation; slope = alpha in y ~ n^alpha)\n");
    {
        double c;
        double a_sd  = fit_slope(15, 28, 0, &c);
        printf("alpha_sd   (k=15..28): %.5f   (intercept %.4f => sd(e) ~ 2^%.4f * (2^k)^%.5f)\n", a_sd, c, c, a_sd);
        double a_sd2 = fit_slope(15, 27, 0, &c);
        printf("alpha_sd   (k=15..27): %.5f\n", a_sd2);
        double a_mx  = fit_slope(15, 28, 1, &c);
        printf("alpha_max  (k=15..28): %.5f   (max|e| ~ n^alpha)\n", a_mx);
        double a_mx2 = fit_slope(15, 27, 1, &c);
        printf("alpha_max  (k=15..27): %.5f\n", a_mx2);
    }

    /* ---- summary ---- */
    printf("\n[summary quantities at largest generation k=%d, G=[%" PRIu64 ",%" PRIu64 "]]\n",
           rows[nrows-1].k, rows[nrows-1].lo, rows[nrows-1].hi);
    {
        Row *L = &rows[nrows-1];
        long double margin = (long double)L->me_v / (long double)L->me_n;
        printf("sd(e)                = %.4Lf\n", L->sd_e);
        printf("max|e|               = %" PRId64 "  (at n=%" PRIu64 ")\n", L->max_abs_e, L->max_abs_e_n);
        printf("max|e(n)|/n          = %.9Lf  (at n=%" PRIu64 ", |e|=%" PRId64 ")  => factor below death boundary |e|/n=1: %.2Lf\n",
               margin, L->me_n, L->me_v, 1.0L / margin);
        printf("max|e|/sd(e)         = %.3Lf  (observed extreme in sample-sd units)\n",
               (long double)L->max_abs_e / L->sd_e);
        printf("NMAX/sd(e)           = %.1Lf  (sd units needed to reach |e| ~ n at n=NMAX)\n",
               (long double)NMAX / L->sd_e);
        long double cmin = 2, cmax = -2;
        for (int i = 0; i < nrows; i++) {
            if (rows[i].corr_ab < cmin) cmin = rows[i].corr_ab;
            if (rows[i].corr_ab > cmax) cmax = rows[i].corr_ab;
        }
        printf("corr(e(a),e(b))      : min %.6Lf, max %.6Lf over k=10..%d; at k=%d: %.6Lf\n",
               cmin, cmax, L->k, L->k, L->corr_ab);
        printf("corr(R,S)            : at k=%d: %.6Lf\n", L->k, L->corr_RS);
    }

    struct rusage ru; getrusage(RUSAGE_SELF, &ru);
    printf("\nwall time: %.1f s   peak RSS: %.3f GiB\n", elapsed, ru.ru_maxrss / 1048576.0);

    free(Q); free(hist);
    return 0;
}
