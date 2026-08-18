# Hofstadter Q-sequence — Lean formalization scaffold

A Lean 4 project set up to **state and (eventually) resolve** the two open
problems about the Hofstadter Q-sequence, plus a fast reference implementation
for numeric experiments.

The sequence (1-indexed):

```
Q(1) = 1,  Q(2) = 1,
Q(n) = Q(n − Q(n−1)) + Q(n − Q(n−2))   for n ≥ 3.
```

`Q(n)` is defined iff both lookup indices `n − Q(n−1)` and `n − Q(n−2)` lie in
`[1, n−1]`. Since all values are positive the upper bound is automatic; the
sequence **dies at n** iff `Q(n−1) ≥ n` or `Q(n−2) ≥ n`.

**Problem A (immortality).** Every `Q(n)` is defined — the sequence never dies.

**Problem B (asymptotics).** `Q(n)/n → 1/2` as `n → ∞`.

This is OEIS [A005185](https://oeis.org/A005185). Both problems are hard: the
self-similarity is only *statistical*, so finite-state / exact-substructure
methods that closed nearby problems (V-sequence, parity-perturbed variants) do
not directly apply, and any death index (if one exists) exceeds `3 × 10¹⁰`, far
beyond any finite computation.

## Status

This repository contains a **faithful formalization with machine-checked
reductions and certificates, plus a full research-phase report** — not a
resolution of either problem.  See **[REPORT.md](REPORT.md)** for the complete
account: proved reductions, verified computation to 10⁹, a rigorous no-go
theorem for the envelope-induction route plus data-level refutations of the
finite-state and renewal routes, an audit of eight proof routes, and the
exact remaining gaps.

| Item | State |
|------|-------|
| Faithful specification of `Q` (`IsHistory`) | ✅ defined, compiles |
| Exact statements `ProblemA`, `ProblemB`, `ProblemB_conditional` | ✅ stated as `Prop`s (no `sorry`, no custom axioms) |
| Determinism (uniqueness of Q) | ✅ **proved** (`deterministic`, `Basic.lean`) |
| Positivity / boundary bookkeeping | ✅ **proved** (`history_pos`: lookups can only exit `[1,n−1]` downward) |
| **Problem A ⟺ `UniformBound` (`Q(n) ≤ n`) ⟺ engine never dies** | ✅ **proved** (`problemA_iff_uniformBound`, `problemA_iff_engine`) |
| Exact deviation & lookup identities | ✅ **proved** (`deviation_identity`, `lookup_*`) |
| Engine ⟷ spec agreement, **general `N`, both directions** | ✅ **proved** (`Faithful.lean`) |
| Spec-level immortality certificates | ✅ 10⁷ (`history_1e7`) and 10⁸ (`history_1e8`), via `native_decide` |
| Spec-level values | ✅ `Q(10⁶)=512066`, `Q(10⁷)=5124632`, `Q(10⁸)=50166508`, `Q(4)=3`, `Q(96)=64`, `Q(16)<Q(15)` |
| No linear bound below ¾ | ✅ **proved** (`no_uniform_bound_below_3_4`) |
| `Qval` recurrence + first asymptotic exclusion under A | ✅ **proved** (`Qval_rec`, `not_eventually_ge_three_quarters`) |
| Computation, exact to 10⁹ | ✅ survives; **0 violations of `Q(n) ≤ n`**; stats in `data/` |
| Two-parameter envelope induction | ❌ **cannot close — no-go proved** (REPORT.md, Theorem D) |
| **Problem A (proof)** | ❌ open — reduced exactly to `UniformBound` (REPORT.md §9, Gap A) |
| **Problem B (proof)** | ❌ open — the limit-*value* lemma (existence assumed) is proved on paper with endpoint exclusions (REPORT.md Theorem C); the gap is existence itself: `|2Q(n)−n| = o(n)` (Gap B) |

The `native_decide` theorems are **finite certificates**, not a proof of
Problem A. Thanks to `Faithful.lean` they now certify the *specified*
sequence, not merely the engine. See "Trust base" below.

## Layout

```
REPORT.md       -- full research report: reductions, computation, no-go theorems,
                   route audit, exact remaining gaps
QSequence/
  Engine.lean   -- computable exact-integer engine (Option/Array), for native_decide
  Spec.lean     -- faithful mathematical spec (IsHistory) + exact Problem A/B statements
  Basic.lean    -- positivity, determinism, take/extend, A ⟺ UniformBound,
                   deviation & lookup identities
  Faithful.lean -- engine ⟷ spec faithfulness, both directions, every N
  Checks.lean   -- Bool checker `checkHistory` verifying the spec rule pointwise
  Verify.lean   -- native_decide theorems: engine⟷spec (1e5), immortality (1e6), value/non-monotonicity
  Certificates.lean    -- spec-level certificates: 10⁷ immortality, values, ¾ floor
  Asymptotics.lean     -- Qval recurrence under A; Q(m)/m ≥ 3/4 cannot hold eventually
  BigCertificates.lean -- spec-level 10⁸ immortality + Q(10⁸)
experiments/    -- route-audit experiments: independent code + raw outputs (see its README)
data/           -- outputs of the 10⁹ run: records, per-generation tables, log
scripts/
  q_reference.py     -- fast exact-integer Python impl (mirrors the engine) + diagnostics
  compute_q.c        -- exact C computation to 10⁹ with adversarial statistics
  check_theorem_d.py -- exact-rational check of the REPORT.md Theorem D constructions
  setup_lean.sh      -- reinstall the exact toolchain without elan (see below)
```

### The exact statements (in `QSequence/Spec.lean`)

- `ProblemA : Prop := ∀ N, ∃ a : List Nat, IsHistory a ∧ a.length = N`
- `ProblemB (h : ProblemA) : Prop` — integer ε–N form of `Q(n)/n → 1/2`:
  `∀ k ≥ 1, ∃ N₀, ∀ n ≥ N₀, |2·Q(n) − n|·k < n` (i.e. `|Q(n)/n − 1/2| < 1/(2k)`),
  using `Int.natAbs` to avoid reals. Contingent on Problem A (needs the
  canonical value `Qval`).
- `ProblemB_conditional : Prop := ∀ h : ProblemA, ProblemB h` — the
  A-free conditional the task permits ("if `Q` is immortal then `Q(n)/n → 1/2`"),
  to be proved **without assuming the limit exists**.

`IsHistory a` says the list `a` (0-based backing, `a[i] = Q(i+1)`) is a genuine
prefix: every position obeys the base cases / recurrence with **in-range**
lookups. This is the honest carrier of "Q is defined on `[1, a.length]`", with
the death condition (`Q(n−1) ≥ n` or `Q(n−2) ≥ n`) built in as the negation of
the in-range requirement `valAt a (n−1) < n ∧ valAt a (n−2) < n`.

## Build & reproduce

Toolchain: **Lean 4.33.0** (pinned in `lean-toolchain`). This sandbox blocks the
elan installer and the GitHub API, but allows GitHub *release-asset* downloads,
so the toolchain is installed from the prebuilt tarball rather than via elan:

```bash
bash scripts/setup_lean.sh     # puts lean/lake on PATH (no elan needed)
lake build                     # builds everything and re-runs the native_decide proofs
                               # (~1 min + a few minutes for the 10⁸ certificates)
```

`lake build` is the full verification: it re-checks every theorem, including the
`native_decide` certificates (which recompile and re-run the underlying
computation).

Numeric experiments (much faster than `native_decide` for exploration):

```bash
gcc -O2 -o scripts/compute_q scripts/compute_q.c
./scripts/compute_q 1000000000 data                        # exact run to 10⁹ (~4 GB RAM):
                                                           # survival, Q(n) ≤ n check, records,
                                                           # per-generation tables → data/
python3 scripts/q_reference.py --upto 100000000            # survival + Q(N)
python3 scripts/q_reference.py --upto 10000000 --stats     # deviation / jump diagnostics
python3 scripts/q_reference.py --values 24 16 1000         # specific values
```

Example diagnostics at `N = 10⁷` (illustrating the difficulty — the deviation is
still *growing* and fluctuations are large):

```
max |2Q(n) − n|        = 732635  at n = 9187467      (≈ 0.073·N, still rising)
monotonicity failures  = 4992973 (Q is non-monotone)
max downward jump      = 661641,  max upward jump = 631083   (unbounded)
range of Q(n)+Q(n−1)−n = [−402982, 436832]                  (widening)
```

## Trust base

- The specification (`Spec.lean`) and all `Prop` statements use only `propext`,
  `Classical.choice`, `Quot.sound` (standard) — check with `#print axioms`.
- The `native_decide` theorems (`Verify.lean`, `Certificates.lean`,
  `BigCertificates.lean`) additionally depend on per-call `native_decide`
  axioms, shown by `#print axioms` as `…._native.native_decide.ax_1_1`
  (each of shape `decide (…) = true`). They add the compiled evaluator
  (compiler + runtime) to the trusted base. They are **finite** and are
  not, and cannot be, a proof of Problem A.
- A future `theorem problemA : ProblemA` must be `native_decide`-free (no finite
  computation resolves an index `> 3 × 10¹⁰`); it should reduce to `propext`,
  `Classical.choice`, `Quot.sound` only.

## Scaling notes (for the research phase)

- `native_decide` on the engine: `aliveUpTo N` verified to `10⁶` in ~1.6s and
  `10⁷` in ~11s (~1s per `10⁶` terms, ~100 MB). `10⁸` is feasible (~2 min);
  the death-index lower bound `3 × 10¹⁰` is out of computational reach.
- Kernel `decide` is impractical here (array recursion exceeds `maxRecDepth`);
  use `native_decide`, or a structural reformulation, for computation.
- No Mathlib: the Mathlib build-cache hosts are blocked in this sandbox, so the
  project is intentionally **core-Lean only**. Real-analysis limits are encoded
  in the integer ε–N form above rather than via `Filter.Tendsto`.
