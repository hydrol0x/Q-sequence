/* windows.c — Tasks 3 + 4: window determinism for coarse finite alphabets,
 * over the Hofstadter Q-sequence, n <= 10^7 (exact, no hashing collisions:
 * windows are packed 4 bits/symbol into a 128-bit key, w<=32 -> <=128 bits,
 * so keys are injective; the hash table compares full keys).
 *
 * Alphabets:
 *   sigma(n) = sign(2Q(n)-n) in {-1,0,+1}, coded {0,1,2}, defined n>=1
 *   t(n)     = (2Q(n)-n) mod 4 in {0,1,2,3}, defined n>=1
 *   pair(n)  = (sigma(n), sign(d(n))), d(n)=Q(n)-Q(n-1); 9 symbols, defined n>=2
 *
 * For each window size w in {4,8,12,16,20,24,28,32}:
 *   universe = window start positions p in [n0, N-w]  (every counted window has
 *   a successor symbol x_{p+w}; the single final w-window without successor is
 *   excluded). For that universe:
 *     distinct   = number of distinct w-windows observed
 *     repeated   = distinct windows occurring more than once (context column)
 *     ambiguous  = distinct windows followed by >=2 different successor symbols
 *     amb_pos    = number of positions whose window is ambiguous
 *     amb_frac   = amb_pos / positions   (occurrence-weighted ambiguous fraction)
 *
 * Single-threaded. Peak RAM ~ 750 MB (dominated by the 2^25-slot key table).
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <inttypes.h>
#include <time.h>

#define N 10000000LL
#define CAPMAX (1u<<25)

typedef unsigned __int128 u128;

static u128     *keys;
static uint32_t *cnts;
static uint16_t *smks;

static inline uint64_t mix64(uint64_t x){
    x ^= x >> 30; x *= 0xbf58476d1ce4e5b9ULL;
    x ^= x >> 27; x *= 0x94d049bb133111ebULL;
    x ^= x >> 31; return x;
}

static void run_alpha(const char *name, const uint8_t *arr, long long n0, int asize){
    static const int ws[8] = {4,8,12,16,20,24,28,32};
    printf("Alphabet: %s  (%d symbols, defined for n>=%lld, N=10^7)\n", name, asize, n0);
    printf("universe: window starts p in [%lld, N-w]; window=(x_p..x_{p+w-1}); successor=x_{p+w}\n", n0);
    printf("%3s %11s %10s %10s %10s %12s %10s\n",
           "w","positions","distinct","repeated","ambiguous","amb_pos","amb_frac");
    for (int wi = 0; wi < 8; wi++){
        int w = ws[wi];
        long long M = N - w - n0 + 1;
        /* table capacity: >= 2 * upper bound on distinct windows, capped at 2^25 */
        uint64_t poss = 1; int sat = 0;
        for (int i = 0; i < w; i++){
            poss *= (uint64_t)asize;
            if (poss > (uint64_t)4*CAPMAX){ sat = 1; break; }
        }
        uint64_t target = sat ? (uint64_t)M : (poss < (uint64_t)M ? poss : (uint64_t)M);
        uint32_t cap = 1024;
        while (cap < CAPMAX && (uint64_t)cap < 2*target) cap <<= 1;
        uint32_t capmask = cap - 1;
        memset(cnts, 0, (size_t)cap*sizeof(uint32_t));
        memset(smks, 0, (size_t)cap*sizeof(uint16_t));

        u128 kmask = (4*w >= 128) ? ~(u128)0 : (((u128)1 << (4*w)) - 1);
        u128 key = 0;
        for (int i = 0; i < w; i++) key = (key << 4) | arr[n0 + i];

        for (long long p = n0; p <= N - w; p++){
            unsigned succ = arr[p + w];
            uint64_t h = mix64((uint64_t)key) ^ mix64((uint64_t)(key >> 64) + 0x9E3779B97F4A7C15ULL);
            uint32_t i = (uint32_t)h & capmask;
            for (;;){
                if (cnts[i] == 0){ keys[i] = key; break; }
                if (keys[i] == key) break;
                i = (i + 1) & capmask;
            }
            cnts[i]++;
            smks[i] |= (uint16_t)(1u << succ);
            key = ((key << 4) | (u128)succ) & kmask;
        }

        uint64_t distinct = 0, rep = 0, amb = 0, ambocc = 0;
        for (uint32_t i = 0; i < cap; i++){
            if (!cnts[i]) continue;
            distinct++;
            if (cnts[i] > 1) rep++;
            if (__builtin_popcount((unsigned)smks[i]) >= 2){ amb++; ambocc += cnts[i]; }
        }
        printf("%3d %11lld %10" PRIu64 " %10" PRIu64 " %10" PRIu64 " %12" PRIu64 " %10.6f\n",
               w, M, distinct, rep, amb, ambocc, (double)ambocc/(double)M);
        fflush(stdout);
    }
    printf("\n");
}

int main(void){
    clock_t t0 = clock();
    FILE *f = fopen("qprefix_1e7.u32","rb");
    if (!f){ printf("missing qprefix_1e7.u32 (run q1 first)\n"); return 1; }
    uint32_t *q = (uint32_t*)malloc(sizeof(uint32_t)*(N+1));
    if (!q){ printf("alloc failure q\n"); return 1; }
    if (fread(q+1, sizeof(uint32_t), (size_t)N, f) != (size_t)N){ printf("short read\n"); return 1; }
    fclose(f);
    if (q[1]!=1 || q[2]!=1 || q[100000]!=48157){ printf("prefix sanity FAIL\n"); return 1; }

    uint8_t *sig = (uint8_t*)malloc(N+1);
    uint8_t *tm  = (uint8_t*)malloc(N+1);
    uint8_t *pr  = (uint8_t*)malloc(N+1);
    if (!sig || !tm || !pr){ printf("alloc failure symbols\n"); return 1; }
    for (long long n = 1; n <= N; n++){
        int64_t e = 2*(int64_t)q[n] - n;
        sig[n] = (uint8_t)(e > 0 ? 2 : (e == 0 ? 1 : 0));
        tm[n]  = (uint8_t)(((e % 4) + 4) & 3);
    }
    pr[1] = 15; /* unused sentinel */
    for (long long n = 2; n <= N; n++){
        int64_t d = (int64_t)q[n] - (int64_t)q[n-1];
        uint8_t ds = (uint8_t)(d > 0 ? 2 : (d == 0 ? 1 : 0));
        pr[n] = (uint8_t)(sig[n]*3 + ds);
    }

    keys = (u128*)    malloc((size_t)CAPMAX*sizeof(u128));
    cnts = (uint32_t*)malloc((size_t)CAPMAX*sizeof(uint32_t));
    smks = (uint16_t*)malloc((size_t)CAPMAX*sizeof(uint16_t));
    if (!keys || !cnts || !smks){ printf("alloc failure tables\n"); return 1; }

    printf("=== TASK 3: window determinism, n <= 10^7 ===\n\n");
    run_alpha("sigma(n)=sign(2Q(n)-n) in {-1,0,+1}", sig, 1, 3);
    run_alpha("t(n)=(2Q(n)-n) mod 4 in {0,1,2,3}",  tm,  1, 4);
    printf("=== TASK 4 (bonus): pair alphabet ===\n\n");
    run_alpha("(sigma(n), sign(d(n))), 3x3=9 symbols", pr, 2, 9);

    printf("[windows done in %.1f s]\n", (double)(clock()-t0)/CLOCKS_PER_SEC);
    return 0;
}
