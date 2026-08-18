/* q1.c — Hofstadter Q-sequence, exact computation to n = 10^8.
 *
 * Tasks 1 + 2:
 *   - Q(1)=Q(2)=1, Q(n)=Q(n-Q(n-1))+Q(n-Q(n-2)), 1-indexed.
 *   - Storage uint32, arithmetic uint64.
 *   - Death check at every step: Q(n-1)>=n or Q(n-2)>=n  -> report + abort.
 *   - Invariant check Q(n)<=n at every step -> ANOMALY report if violated.
 *   - Prints Q(10^6), Q(10^7), Q(10^8), sum(Q(1..10^6)) mod 2^64,
 *     sum(Q(1..10^7)) mod 2^64 (plus supplementary sum to 10^8).
 *   - Distinct-value counts (exact, bitmap) for
 *       d(n)=Q(n)-Q(n-1)   (n>=2)
 *       s(n)=Q(n)+Q(n-1)-n (n>=2)
 *       e(n)=2Q(n)-n       (n>=1)
 *     at n <= 10^4, 10^5, 10^6, 10^7, 10^8, plus overall min/max.
 *     Bitmap covers [-2^27, 2^27): under the invariant Q(n)<=n<=10^8 all three
 *     abstractions are provably inside (|value| <= 10^8 < 2^27 = 134217728);
 *     an out-of-range value aborts loudly (it would itself imply an anomaly).
 *   - Dumps Q(1..10^7) as raw little-endian uint32 for the window analysis.
 *
 * Single-threaded. Peak RAM ~ 400 MB (Q) + 96 MB (3 bitmaps).
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <inttypes.h>
#include <time.h>

#define NMAX  100000000ULL
#define NPREF 10000000ULL

#define BOFF   ((int64_t)134217728)   /* 2^27 */
#define BRANGE ((size_t)268435456)    /* 2^28 values */
#define BWORDS (BRANGE/64)

static uint32_t *Q;

typedef struct {
    uint64_t *bm;
    uint64_t distinct;
    int64_t vmin, vmax;
    const char *name;
} Abst;

static inline void abst_add(Abst *a, int64_t v, uint64_t n){
    if (v < -BOFF || v >= BOFF){
        printf("FATAL: abstraction %s value %" PRId64 " at n=%" PRIu64
               " outside +/-2^27 bitmap (impossible unless invariant violated)\n",
               a->name, v, n);
        exit(3);
    }
    if (v < a->vmin) a->vmin = v;
    if (v > a->vmax) a->vmax = v;
    size_t idx = (size_t)(v + BOFF);
    uint64_t *w = &a->bm[idx >> 6];
    uint64_t bit = 1ULL << (idx & 63);
    if (!(*w & bit)){ *w |= bit; a->distinct++; }
}

int main(void){
    const uint32_t known15[15] = {1,1,2,3,3,4,5,5,6,6,6,8,8,8,10};
    clock_t t0 = clock();

    Q = (uint32_t*)malloc(sizeof(uint32_t)*(NMAX+1));
    if (!Q){ printf("alloc failure Q\n"); return 1; }
    Abst Ad = { (uint64_t*)calloc(BWORDS,8), 0, INT64_MAX, INT64_MIN, "d(n)=Q(n)-Q(n-1)" };
    Abst As = { (uint64_t*)calloc(BWORDS,8), 0, INT64_MAX, INT64_MIN, "s(n)=Q(n)+Q(n-1)-n" };
    Abst Ae = { (uint64_t*)calloc(BWORDS,8), 0, INT64_MAX, INT64_MIN, "e(n)=2Q(n)-n" };
    if (!Ad.bm || !As.bm || !Ae.bm){ printf("alloc failure bitmaps\n"); return 1; }

    const uint64_t thr[5] = {10000ULL,100000ULL,1000000ULL,10000000ULL,100000000ULL};
    uint64_t snap_d[5], snap_s[5], snap_e[5];
    int ti = 0;

    uint64_t sum = 0, csum6 = 0, csum7 = 0, csum8 = 0;
    uint64_t anomalies = 0, printed_anom = 0;

    for (uint64_t n = 1; n <= NMAX; n++){
        uint32_t qn;
        if (n <= 2){
            qn = 1;
        } else {
            uint64_t qm1 = Q[n-1], qm2 = Q[n-2];
            if (qm1 >= n || qm2 >= n){
                printf("DEATH at n=%" PRIu64 ": Q(n-1)=%" PRIu64 " Q(n-2)=%" PRIu64
                       " (argument index would drop below 1). Aborting.\n", n, qm1, qm2);
                return 2;
            }
            uint64_t v = (uint64_t)Q[n - qm1] + (uint64_t)Q[n - qm2];
            if (v > n){
                anomalies++;
                if (printed_anom < 20){
                    printf("ANOMALY at n=%" PRIu64 ": Q(n)=%" PRIu64 " > n\n", n, v);
                    printed_anom++;
                }
            }
            qn = (uint32_t)v;
        }
        Q[n] = qn;
        sum += qn;

        int64_t e = 2*(int64_t)qn - (int64_t)n;
        abst_add(&Ae, e, n);
        if (n >= 2){
            abst_add(&Ad, (int64_t)qn - (int64_t)Q[n-1], n);
            abst_add(&As, (int64_t)qn + (int64_t)Q[n-1] - (int64_t)n, n);
        }

        if (n == 1000000ULL)  csum6 = sum;
        if (n == 10000000ULL) csum7 = sum;
        if (ti < 5 && n == thr[ti]){
            snap_d[ti] = Ad.distinct; snap_s[ti] = As.distinct; snap_e[ti] = Ae.distinct;
            ti++;
        }
    }
    csum8 = sum;

    printf("=== TASK 1: sequence generation and cross-validation ===\n");
    int ok = 1;
    printf("computed Q(1..15) = [");
    for (int i = 0; i < 15; i++){
        printf("%u%s", Q[i+1], i==14?"":",");
        if (Q[i+1] != known15[i]) ok = 0;
    }
    printf("]\n");
    printf("Prefix check Q(1..15) vs known: %s\n", ok ? "PASS" : "FAIL");
    printf("Check Q(100000)==48157: %s (computed %u)\n",
           Q[100000]==48157 ? "PASS" : "FAIL", Q[100000]);
    printf("Q(10^6) = %u\n", Q[1000000]);
    printf("Q(10^7) = %u\n", Q[10000000]);
    printf("Q(10^8) = %u\n", Q[100000000]);
    printf("sum(Q(1..10^6)) mod 2^64 = %" PRIu64 "\n", csum6);
    printf("sum(Q(1..10^7)) mod 2^64 = %" PRIu64 "\n", csum7);
    printf("supplementary: sum(Q(1..10^8)) mod 2^64 = %" PRIu64 "\n", csum8);
    printf("death condition triggers: 0 (checked at every n, 3<=n<=10^8)\n");
    printf("invariant Q(n)<=n violations (ANOMALY): %" PRIu64 "\n", anomalies);

    printf("\n=== TASK 2: alphabet finiteness of local abstractions ===\n");
    printf("distinct values seen (exact bitmap counts); d,s over n>=2, e over n>=1\n");
    printf("%-22s %10s %10s %10s %10s %10s %12s %12s\n",
           "abstraction","n<=10^4","n<=10^5","n<=10^6","n<=10^7","n<=10^8","min(1e8)","max(1e8)");
    printf("%-22s %10" PRIu64 " %10" PRIu64 " %10" PRIu64 " %10" PRIu64 " %10" PRIu64 " %12" PRId64 " %12" PRId64 "\n",
           "d(n)=Q(n)-Q(n-1)", snap_d[0],snap_d[1],snap_d[2],snap_d[3],snap_d[4], Ad.vmin, Ad.vmax);
    printf("%-22s %10" PRIu64 " %10" PRIu64 " %10" PRIu64 " %10" PRIu64 " %10" PRIu64 " %12" PRId64 " %12" PRId64 "\n",
           "s(n)=Q(n)+Q(n-1)-n", snap_s[0],snap_s[1],snap_s[2],snap_s[3],snap_s[4], As.vmin, As.vmax);
    printf("%-22s %10" PRIu64 " %10" PRIu64 " %10" PRIu64 " %10" PRIu64 " %10" PRIu64 " %12" PRId64 " %12" PRId64 "\n",
           "e(n)=2Q(n)-n", snap_e[0],snap_e[1],snap_e[2],snap_e[3],snap_e[4], Ae.vmin, Ae.vmax);

    /* dump Q(1..10^7) for the window-determinism program */
    FILE *f = fopen("qprefix_1e7.u32","wb");
    if (!f){ printf("cannot open qprefix_1e7.u32 for write\n"); return 1; }
    if (fwrite(Q+1, sizeof(uint32_t), NPREF, f) != NPREF){ printf("short write\n"); return 1; }
    fclose(f);

    printf("\n[q1 done in %.1f s]\n", (double)(clock()-t0)/CLOCKS_PER_SEC);
    return 0;
}
