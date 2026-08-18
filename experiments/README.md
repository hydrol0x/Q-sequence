# Route-audit experiments (code + raw outputs)

Each subdirectory contains the exact source and raw output of one
independently written experiment from the research phase (REPORT.md §8).
Each implementation recomputes the Q-sequence from scratch (none share code
with `scripts/` or the Lean engine), checks the death condition and
`Q(n) ≤ n` at every step, and prints cross-validation checkpoint values;
all checkpoints agree across all implementations (REPORT.md §3).

| dir | route | headline result |
|---|---|---|
| `closure/` | R1: finite closed constraint systems | exact-abstraction alphabets grow without saturation (4.1M/2.8M/4.7M distinct values at 10⁸); every finite coarsening tested has ambiguous successors at every window size w ≤ 32 |
| `transfer/` | R3: generation-transfer inequalities | interval knowledge of a generation (±E₀, any E₀ ≥ 1) collapses totally within 15–49 steps; from step 24 death cannot even be excluded; mean adjacent jump ≈ 11k at scale 2¹⁹, growing ×1.84/generation |
| `renewal/` | R5: exact renewal / morphic substructure | longest exact repeat in d = 9 symbols (same at 10⁵, 10⁶, 10⁷); dyadic self-alignment length 0 for all k ∈ [10,22]; all 231 zero-crossing windows distinct |
| `criticality/` | R6: deviation dynamics / derandomization wall | sd(e) ≈ n^0.879, max\|e\| ≈ n^0.912; per-generation growth 1.840–1.846; lookup-stream correlation → +0.00001; damping anti-alignment −0.1464; identities I1–I3 exact at every n ≤ 5·10⁸ |

Reproduce: `gcc -O2 <file>.c && ./a.out` per directory (see each source
header / `run.sh` for arguments); single-threaded, ≤ 3 GB RAM each.
