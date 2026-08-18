/* qrenewal.c
 *
 * Exact search for repeated / self-similar substructure in Hofstadter's
 * Q-sequence:  Q(1)=Q(2)=1,  Q(n) = Q(n-Q(n-1)) + Q(n-Q(n-2))  (1-indexed).
 *
 * Tasks (all exact; hashes are only used to LOCATE candidates, every equality
 * that is reported has been verified by direct element-by-element comparison
 * on the original arrays):
 *   1. compute Q(1..NMAX) with death-condition and Q(n)<=n invariant checks,
 *      print anchors and 64-bit checksums,
 *   2. longest exact repeated substring of d(n)=Q(n)-Q(n-1) (n=2..N) for
 *      N = 1e5, 1e6, 1e7 (binary search on length; rolling hash mod 2^64 and
 *      mod 2^61-1; every candidate verified by memcmp; final witness verified
 *      again elementwise; maximality re-checked at L+1),
 *   3. dyadic self-similarity: longest L with d(2^k+i)=d(2^(k+1)+i), i<L,
 *      k=10..22 (direct comparison, no hashing),
 *   4. zeros of e(n)=2Q(n)-n: count, largest gap, last 5, and the number of
 *      distinct 32-symbol d-windows following the first 1000 zeros,
 *   5. longest exact repeated substring of the parity sequence e(n) mod 2,
 *      n=1..NMAX (same exact machinery).
 *
 * Build:  gcc -O2 -Wall -Wextra -std=gnu11 -o qrenewal qrenewal.c
 * Usage:  ./qrenewal [NMAX]      (default 10000000)
 *         ./qrenewal selftest    (validates the LRS machinery against an
 *                                 O(M^2) brute force on three small cases)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <inttypes.h>
#include <time.h>

typedef struct { uint64_t h1, h2; uint32_t pos, pad; } Tup;
typedef struct { int found; uint32_t p1, p2; } Dec;

static size_t NMAX = 10000000;

static int32_t *Q;            /* Q[1..NMAX]                                  */
static int32_t *dd;           /* dd[n] = Q(n)-Q(n-1), n in [2,NMAX]          */
static int32_t *par;          /* par[n] = (2Q(n)-n) mod 2 in {0,1}, n>=1     */
static Tup *tup, *aux;        /* hash tuples + radix buffer                  */
static int32_t wins[1000][32];

static long    g_collisions = 0;  /* equal-(h1,h2) pairs that FAILED memcmp  */
static long    g_anomalies  = 0;
static int32_t g_dmin, g_dmax;
static size_t  g_par_viol, g_inv_viol;

static double now_s(void){
    struct timespec ts; clock_gettime(CLOCK_MONOTONIC, &ts);
    return (double)ts.tv_sec + 1e-9*(double)ts.tv_nsec;
}

/* ------------ hash arithmetic ------------------------------------------- */
/* hash1: polynomial mod 2^64 with odd base B1 (natural wrap-around).
   hash2: polynomial mod p = 2^61-1 with base B2.
   Equal substrings ALWAYS get equal (h1,h2); therefore a "no duplicate hash"
   answer is exact.  A "duplicate hash" answer is only accepted after memcmp. */
#define MP 2305843009213693951ULL      /* 2^61 - 1 (prime) */
static inline uint64_t mulmod(uint64_t a, uint64_t b){
    __uint128_t t = (__uint128_t)a * b;
    uint64_t r = (uint64_t)(t & MP) + (uint64_t)(t >> 61);
    if (r >= MP) r -= MP;
    return r;
}
static inline uint64_t addmod(uint64_t a, uint64_t b){ uint64_t r=a+b; if(r>=MP) r-=MP; return r; }
static inline uint64_t submod(uint64_t a, uint64_t b){ return a>=b ? a-b : a+(MP-b); }

#define B1 0x9E3779B97F4A7C15ULL   /* odd multiplier for hash1 (mod 2^64)  */
#define B2 1000003ULL              /* base for hash2 (mod 2^61-1)          */

/* ------------ LSD radix sort of tuples by full 64-bit h1 ---------------- */
static Tup *radix_by_h1(Tup *a, Tup *b, size_t n){
    for(int pass=0; pass<8; pass++){
        int sh = pass*8;
        size_t cnt[256]; memset(cnt, 0, sizeof cnt);
        for(size_t i=0;i<n;i++) cnt[(a[i].h1>>sh)&0xFFu]++;
        int skip = 0;
        for(int v=0; v<256; v++) if(cnt[v]==n){ skip=1; break; }
        if(skip) continue;                       /* all keys share this byte */
        size_t off[256], run=0;
        for(int v=0; v<256; v++){ off[v]=run; run+=cnt[v]; }
        for(size_t i=0;i<n;i++) b[off[(a[i].h1>>sh)&0xFFu]++] = a[i];
        Tup *t=a; a=b; b=t;
    }
    return a;   /* stable: within equal h1, original (ascending pos) order  */
}

static int cmp_h2pos(const void *x, const void *y){
    const Tup *p = (const Tup*)x, *q = (const Tup*)y;
    if(p->h2 != q->h2) return p->h2 < q->h2 ? -1 : 1;
    if(p->pos != q->pos) return p->pos < q->pos ? -1 : 1;
    return 0;
}

/* ------------ exact decision: does some length-L substring occur at two
   distinct positions of sym[first .. first+M-1] ?  ----------------------- */
static Dec decide(const int32_t *sym, uint32_t first, size_t M, size_t L){
    Dec R = {0,0,0};
    if(L==0 || L+1 > M) return R;
    size_t W = M - L + 1;                       /* number of windows */
    uint64_t pw1=1, pw2=1;                      /* B^{L-1} */
    for(size_t i=0;i+1<L;i++){ pw1*=B1; pw2=mulmod(pw2,B2); }
    uint64_t h1=0, h2=0;
    for(size_t i=0;i<L;i++){
        uint64_t s = (uint64_t)(uint32_t)sym[first+i] + 1;
        h1 = h1*B1 + s;
        h2 = addmod(mulmod(h2,B2), s);
    }
    tup[0].h1=h1; tup[0].h2=h2; tup[0].pos=first; tup[0].pad=0;
    for(size_t i=1;i<W;i++){
        uint64_t out = (uint64_t)(uint32_t)sym[first+i-1]   + 1;
        uint64_t in  = (uint64_t)(uint32_t)sym[first+i+L-1] + 1;
        h1 = (h1 - out*pw1)*B1 + in;
        h2 = addmod(mulmod(submod(h2, mulmod(out,pw2)), B2), in);
        tup[i].h1=h1; tup[i].h2=h2; tup[i].pos=first+(uint32_t)i; tup[i].pad=0;
    }
    Tup *s = radix_by_h1(tup, aux, W);
    size_t i=0;
    while(i<W){
        size_t j=i+1;
        while(j<W && s[j].h1==s[i].h1) j++;
        if(j-i >= 2){
            int allh2 = 1;
            for(size_t t=i+1;t<j;t++) if(s[t].h2 != s[i].h2){ allh2=0; break; }
            if(!allh2) qsort(s+i, j-i, sizeof(Tup), cmp_h2pos);
            size_t a = i;
            while(a<j){
                size_t b = a+1;
                while(b<j && s[b].h2==s[a].h2) b++;
                if(b-a >= 2){
                    /* group of equal (h1,h2): reference-vs-each, verified
                       EXACTLY by memcmp on the original symbol array */
                    for(size_t t=a+1;t<b;t++){
                        if(memcmp(sym+s[a].pos, sym+s[t].pos, L*sizeof(int32_t))==0){
                            R.found=1; R.p1=s[a].pos; R.p2=s[t].pos;
                            if(R.p1>R.p2){ uint32_t z=R.p1; R.p1=R.p2; R.p2=z; }
                            return R;
                        }
                        g_collisions++;
                    }
                    size_t g = b-a;
                    if(g<=64){    /* exhaustive fallback: all remaining pairs */
                        for(size_t u=a+1;u<b;u++)
                            for(size_t v=u+1;v<b;v++){
                                if(memcmp(sym+s[u].pos, sym+s[v].pos, L*sizeof(int32_t))==0){
                                    R.found=1; R.p1=s[u].pos; R.p2=s[v].pos;
                                    if(R.p1>R.p2){ uint32_t z=R.p1; R.p1=R.p2; R.p2=z; }
                                    return R;
                                }
                                g_collisions++;
                            }
                    } else {
                        g_anomalies++;
                        printf("ANOMALY: (h1,h2)-group of size %zu at L=%zu, ref-vs-each all failed exact compare\n", g, L);
                    }
                }
                a=b;
            }
        }
        i=j;
    }
    return R;
}

/* quiet binary search, used by selftest */
static size_t machine_lrs_quiet(const int32_t *sym, uint32_t first, size_t M){
    Dec d1 = decide(sym, first, M, 1);
    if(!d1.found) return 0;
    size_t lo=1, hi=M-1;
    while(lo<hi){
        size_t mid = lo + (hi-lo+1)/2;
        Dec dm = decide(sym, first, M, mid);
        if(dm.found) lo=mid; else hi=mid-1;
    }
    return lo;
}

/* O(M^2 * avgmatch) brute force, ground truth for selftest */
static size_t brute_lrs(const int32_t *sym, uint32_t first, size_t M,
                        uint32_t *bp1, uint32_t *bp2){
    size_t best=0; *bp1=*bp2=0;
    for(size_t p=0;p<M;p++){
        for(size_t q=p+1;q<M;q++){
            size_t maxl = M-q;
            if(maxl <= best) break;
            size_t l=0;
            while(l<maxl && sym[first+p+l]==sym[first+q+l]) l++;
            if(l>best){ best=l; *bp1=first+(uint32_t)p; *bp2=first+(uint32_t)q; }
        }
    }
    return best;
}

/* full reported longest-repeated-substring run with witness + verification */
static void lrs_task(const char *label, const int32_t *sym, uint32_t first, size_t M){
    double t0 = now_s();
    printf("[%s] M=%zu symbols at positions n=%u..%" PRIu64 "\n",
           label, M, first, (uint64_t)first + M - 1);
    Dec w1 = decide(sym, first, M, 1);
    if(!w1.found){ printf("[%s] RESULT: L=0 (all symbols distinct)\n", label); return; }
    size_t lo=1, hi=M-1;
    while(lo < hi){
        size_t mid = lo + (hi-lo+1)/2;
        Dec dm = decide(sym, first, M, mid);
        printf("  bsearch L=%zu -> %s\n", mid, dm.found ? "repeat" : "none");
        if(dm.found) lo=mid; else hi=mid-1;
    }
    Dec fin = decide(sym, first, M, lo);
    if(!fin.found){ printf("[%s] INTERNAL ERROR: final decide failed\n", label); g_anomalies++; return; }
    size_t bad=0;
    for(size_t t=0;t<lo;t++) if(sym[fin.p1+t] != sym[fin.p2+t]) bad++;
    Dec above = decide(sym, first, M, lo+1);
    printf("[%s] RESULT: L=%zu, witness n1=%u n2=%u (offset n2-n1=%u)\n",
           label, lo, fin.p1, fin.p2, fin.p2-fin.p1);
    printf("[%s] direct elementwise check: %s; decision at L+1=%zu: %s\n", label,
           bad ? "MISMATCH (ANOMALY)" : "exact equality confirmed",
           lo+1, above.found ? "repeat exists (ANOMALY: not maximal)" : "no repeat (maximality confirmed)");
    if(bad || above.found) g_anomalies++;
    if((size_t)(fin.p2 - fin.p1) < lo)
        printf("[%s] note: the two occurrences OVERLAP (offset %u < L), i.e. a block with exact period %u\n",
               label, fin.p2-fin.p1, fin.p2-fin.p1);
    size_t show = lo<40 ? lo : 40;
    printf("[%s] repeated block, first %zu of %zu symbols:", label, show, lo);
    for(size_t t=0;t<show;t++) printf(" %d", (int)sym[fin.p1+t]);
    printf("%s\n[%s] elapsed %.1f s\n", lo>show ? " ..." : "", label, now_s()-t0);
}

/* ------------ sequence computation with checks --------------------------- */
static void compute_all(void){
    Q[1]=1; Q[2]=1;
    g_inv_viol=0;
    for(size_t n=3;n<=NMAX;n++){
        int32_t a=Q[n-1], b=Q[n-2];
        if((int64_t)a >= (int64_t)n || (int64_t)b >= (int64_t)n){
            printf("DEATH CONDITION at n=%zu: Q(n-1)=%d Q(n-2)=%d -> index <= 0, sequence dies\n",
                   n, a, b);
            exit(2);
        }
        int32_t v = Q[n-(size_t)a] + Q[n-(size_t)b];
        Q[n]=v;
        if(v < 1 || (int64_t)v > (int64_t)n){
            g_inv_viol++;
            if(g_inv_viol<=10) printf("INVARIANT VIOLATION at n=%zu: Q=%d\n", n, v);
        }
    }
    g_dmin=INT32_MAX; g_dmax=INT32_MIN;
    for(size_t n=2;n<=NMAX;n++){
        int32_t diff = Q[n]-Q[n-1];   /* |diff| <= NMAX, always fits int32 */
        dd[n]=diff;
        if(diff<g_dmin) g_dmin=diff;
        if(diff>g_dmax) g_dmax=diff;
    }
    g_par_viol=0;
    for(size_t n=1;n<=NMAX;n++){
        int64_t e = 2*(int64_t)Q[n] - (int64_t)n;
        par[n] = (int32_t)(e & 1);              /* two's complement -> parity */
        if(par[n] != (int32_t)(n & 1)) g_par_viol++;
    }
}

static int cmp_win(const void *a, const void *b){ return memcmp(a, b, 32*sizeof(int32_t)); }

int main(int argc, char **argv){
    int selftest = 0;
    if(argc>1){
        if(strcmp(argv[1],"selftest")==0){ selftest=1; NMAX=5000; }
        else NMAX = (size_t)strtoull(argv[1], NULL, 10);
    }
    setvbuf(stdout, NULL, _IOLBF, 0);
    double T0 = now_s();

    Q   = malloc((NMAX+1)*sizeof *Q);
    dd  = calloc(NMAX+1, sizeof *dd);
    par = calloc(NMAX+1, sizeof *par);
    tup = malloc((NMAX+1)*sizeof *tup);
    aux = malloc((NMAX+1)*sizeof *aux);
    if(!Q||!dd||!par||!tup||!aux){ fprintf(stderr,"allocation failure\n"); return 1; }

    printf("== Hofstadter Q-sequence exact-substructure search ==\n");
    printf("NMAX=%zu, allocated %.0f MB\n", NMAX,
           ((double)(NMAX+1)*(sizeof*Q+sizeof*dd+sizeof*par) + 2.0*(NMAX+1)*sizeof(Tup))/1048576.0);

    compute_all();
    printf("Q computed in %.1f s\n", now_s()-T0);

    if(selftest){
        printf("\n---- selftest: LRS machinery vs O(M^2) brute force ----\n");
        uint32_t bp1,bp2;
        size_t bl, ml;

        bl = brute_lrs(dd, 2, 3000, &bp1, &bp2);
        ml = machine_lrs_quiet(dd, 2, 3000);
        printf("d-prefix M=3000:  brute L=%zu (witness %u,%u), machinery L=%zu -> %s\n",
               bl, bp1, bp2, ml, bl==ml?"PASS":"FAIL");
        int fail = (bl!=ml);

        bl = brute_lrs(par, 1, 500, &bp1, &bp2);
        ml = machine_lrs_quiet(par, 1, 500);
        printf("parity M=500:     brute L=%zu (witness %u,%u), machinery L=%zu -> %s\n",
               bl, bp1, bp2, ml, bl==ml?"PASS":"FAIL");
        fail |= (bl!=ml);

        size_t Mr=4000;
        int32_t *rnd = malloc((Mr+1)*sizeof *rnd);
        uint64_t st=12345;
        for(size_t i=0;i<=Mr;i++){
            st = st*6364136223846793005ULL + 1442695040888963407ULL;
            rnd[i]=(int32_t)((int)((st>>33)%7)-3);
        }
        memcpy(rnd+2900, rnd+500, 137*sizeof(int32_t));   /* plant repeat length 137 */
        bl = brute_lrs(rnd, 0, Mr, &bp1, &bp2);
        ml = machine_lrs_quiet(rnd, 0, Mr);
        printf("random+planted137 M=4000: brute L=%zu (witness %u,%u), machinery L=%zu -> %s\n",
               bl, bp1, bp2, ml, bl==ml?"PASS":"FAIL");
        fail |= (bl!=ml);
        free(rnd);
        printf("selftest %s (hash collisions filtered so far: %ld)\n",
               fail?"FAILED":"OK", g_collisions);
        return fail?9:0;
    }

    /* ---------------- Task 1 ------------------------------------------- */
    printf("\n---- Task 1: Q values, checks, checksums ----\n");
    {
        static const int32_t q15[15] = {1,1,2,3,3,4,5,5,6,6,6,8,8,8,10};
        int ok=1;
        for(int i=0;i<15;i++) if(Q[i+1]!=q15[i]) ok=0;
        printf("anchor Q(1..15) == [1,1,2,3,3,4,5,5,6,6,6,8,8,8,10]: %s\n", ok?"PASS":"FAIL");
        if(!ok) g_anomalies++;
        if(NMAX>=100000){
            printf("anchor Q(100000) = %d (expected 48157): %s\n",
                   Q[100000], Q[100000]==48157?"PASS":"FAIL");
            if(Q[100000]!=48157) g_anomalies++;
        }
        if(NMAX>=1000000)  printf("Q(10^6)  = %d\n", Q[1000000]);
        if(NMAX>=10000000) printf("Q(10^7)  = %d\n", Q[10000000]);
        uint64_t s=0;
        for(size_t n=1;n<=NMAX;n++){
            s += (uint64_t)Q[n];
            if(n==1000000)  printf("sum Q(1..10^6) mod 2^64 = %" PRIu64 "\n", s);
            if(n==10000000) printf("sum Q(1..10^7) mod 2^64 = %" PRIu64 "\n", s);
        }
        printf("sum Q(1..NMAX) mod 2^64 = %" PRIu64 "\n", s);
        printf("death-condition triggers: 0 (program aborts immediately if one occurs)\n");
        printf("invariant Q(n)<=n violations: %zu\n", g_inv_viol);
        printf("d(n)=Q(n)-Q(n-1) value range over n=2..%zu: [%d, %d]\n", NMAX, g_dmin, g_dmax);
    }

    /* ---------------- Task 2 ------------------------------------------- */
    printf("\n---- Task 2: longest exact repeated substring of d(n)=Q(n)-Q(n-1) ----\n");
    printf("(positions are n-indices of the first symbol of each occurrence; overlaps allowed)\n");
    {
        size_t Ns[3] = {100000, 1000000, 10000000};
        for(int t=0;t<3;t++){
            if(Ns[t] > NMAX) continue;
            char lab[64]; snprintf(lab, sizeof lab, "d N=%zu", Ns[t]);
            lrs_task(lab, dd, 2, Ns[t]-1);
            printf("\n");
        }
    }

    /* ---------------- Task 3 ------------------------------------------- */
    printf("---- Task 3: dyadic self-similarity, d(2^k+i) vs d(2^(k+1)+i) ----\n");
    printf("k   2^k       2^(k+1)    i-bound     L(exact)   first mismatch\n");
    for(int k=10;k<=22;k++){
        size_t s1=(size_t)1<<k, s2=(size_t)1<<(k+1);
        if(s2 > NMAX) break;
        size_t bound = NMAX - s2 + 1;      /* need s2+i <= NMAX */
        size_t L=0;
        while(L<bound && dd[s1+L]==dd[s2+L]) L++;
        if(L<bound)
            printf("%-3d %-9zu %-10zu %-11zu %-10zu d(%zu)=%d vs d(%zu)=%d\n",
                   k, s1, s2, bound, L, s1+L, (int)dd[s1+L], s2+L, (int)dd[s2+L]);
        else
            printf("%-3d %-9zu %-10zu %-11zu %-10zu (ran into boundary)\n", k, s1, s2, bound, L);
    }

    /* ---------------- Task 4 ------------------------------------------- */
    printf("\n---- Task 4: zeros of e(n)=2Q(n)-n ----\n");
    {
        uint32_t *zeros = malloc((NMAX/2+2)*sizeof *zeros);
        if(!zeros){ fprintf(stderr,"alloc failure (zeros)\n"); return 1; }
        size_t nz=0;
        for(size_t n=1;n<=NMAX;n++)
            if(2*(int64_t)Q[n] == (int64_t)n) zeros[nz++]=(uint32_t)n;
        printf("number of n <= %zu with e(n)=0: %zu\n", NMAX, nz);
        if(nz>0){
            printf("first zero: n=%u\n", zeros[0]);
            if(nz>=2){
                size_t gi=1; uint64_t gmax=0;
                for(size_t i=1;i<nz;i++){
                    uint64_t gap = (uint64_t)zeros[i]-zeros[i-1];
                    if(gap>gmax){ gmax=gap; gi=i; }
                }
                printf("largest gap between consecutive zeros: %" PRIu64 " (from n=%u to n=%u)\n",
                       gmax, zeros[gi-1], zeros[gi]);
            }
            printf("last 5 zeros <= %zu:", NMAX);
            for(size_t i = nz>5 ? nz-5 : 0; i<nz; i++) printf(" %u", zeros[i]);
            printf("\n");
            size_t consider = nz<1000 ? nz : 1000, K=0;
            for(size_t i=0;i<consider;i++){
                uint32_t z=zeros[i];
                if((size_t)z+32 <= NMAX){ memcpy(wins[K], dd+z+1, 32*sizeof(int32_t)); K++; }
            }
            qsort(wins, K, sizeof wins[0], cmp_win);
            size_t distinct = K?1:0, run=1, maxrun=K?1:0;
            for(size_t i=1;i<K;i++){
                if(memcmp(wins[i], wins[i-1], 32*sizeof(int32_t))==0){ run++; if(run>maxrun) maxrun=run; }
                else { distinct++; run=1; }
            }
            printf("32-symbol d-windows d(z+1..z+32) following the first %zu zeros: %zu DISTINCT (max multiplicity of any one window: %zu)\n",
                   K, distinct, maxrun);
        }
        free(zeros);
    }

    /* ---------------- Task 5 ------------------------------------------- */
    printf("\n---- Task 5: longest exact repeated substring of e(n) mod 2, n=1..%zu ----\n", NMAX);
    printf("computed check of the identity e(n) mod 2 == n mod 2 (since e(n)=2Q(n)-n): violations = %zu\n",
           g_par_viol);
    if(g_par_viol==0)
        printf("(so the parity sequence is exactly 1,0,1,0,... ; the repeat below is forced by this identity)\n");
    lrs_task("parity e mod 2", par, 1, NMAX);

    /* ---------------- summary ------------------------------------------ */
    printf("\n==== summary ====\n");
    printf("hash collisions found and rejected by exact comparison: %ld\n", g_collisions);
    printf("anomalies (death/invariant/anchor/verification failures): %ld + invariant violations %zu\n",
           g_anomalies, g_inv_viol);
    printf("total elapsed: %.1f s\n", now_s()-T0);
    return 0;
}
