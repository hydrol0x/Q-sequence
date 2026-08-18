/* Independent re-derivation of the Hofstadter Q-sequence, written ONLY from:
   Q(1)=1, Q(2)=1, Q(n)=Q(n-Q(n-1))+Q(n-Q(n-2)) for n>=3;
   dies at n iff Q(n-1)>=n or Q(n-2)>=n.
   Checks the death condition and Q(n)<=n at every step.
   Author: audit agent (fresh implementation, no repo code consulted). */
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

int main(int argc, char **argv) {
    uint64_t N = (argc > 1) ? strtoull(argv[1], NULL, 10) : 100000000ULL;
    uint32_t *q = malloc((N + 1) * sizeof(uint32_t));
    if (!q) { fprintf(stderr, "alloc failed\n"); return 1; }
    q[1] = 1; q[2] = 1;
    uint64_t sum1e7 = 1 + 1;         /* running sum mod 2^64 for n<=1e7 */
    uint64_t viol = 0, viol1e7 = 0;  /* count of n with Q(n)>n */
    for (uint64_t n = 3; n <= N; n++) {
        /* death check exactly as defined */
        if ((uint64_t)q[n-1] >= n || (uint64_t)q[n-2] >= n) {
            printf("DIES at n=%llu (Q(n-1)=%u, Q(n-2)=%u)\n",
                   (unsigned long long)n, q[n-1], q[n-2]);
            return 2;
        }
        uint64_t a = n - q[n-1], b = n - q[n-2];
        if (a < 1 || a > n-1 || b < 1 || b > n-1) {   /* paranoia */
            printf("RANGE BUG at n=%llu a=%llu b=%llu\n",
                   (unsigned long long)n,(unsigned long long)a,(unsigned long long)b);
            return 3;
        }
        uint64_t v = (uint64_t)q[a] + (uint64_t)q[b];
        if (v > n) { viol++; if (n <= 10000000ULL) viol1e7++;
            if (viol < 5) printf("VIOLATION Q(%llu)=%llu > n\n",
                                 (unsigned long long)n,(unsigned long long)v); }
        if (v > 0xFFFFFFFFULL) { printf("uint32 overflow at n=%llu\n",(unsigned long long)n); return 4; }
        q[n] = (uint32_t)v;
        if (n <= 10000000ULL) sum1e7 += v;
    }
    uint64_t probes[] = {4,15,16,24,48,96,768,1536,100000,1000000,10000000,100000000};
    for (int i = 0; i < 12; i++) {
        uint64_t p = probes[i];
        if (p <= N) printf("Q(%llu) = %u\n", (unsigned long long)p, q[p]);
    }
    printf("sum Q(1..1e7) mod 2^64 = %llu\n", (unsigned long long)sum1e7);
    printf("violations Q(n)>n, n<=1e7: %llu ; n<=N: %llu\n",
           (unsigned long long)viol1e7, (unsigned long long)viol);
    printf("survived to N=%llu\n", (unsigned long long)N);
    return 0;
}
