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

This repository currently contains a **faithful formalization scaffold**, not a
resolution. Concretely:

| Item | State |
|------|-------|
| Faithful specification of `Q` (`IsHistory`) | ✅ defined, compiles |
| Exact statements `ProblemA`, `ProblemB`, `ProblemB_conditional` | ✅ stated as `Prop`s (no `sorry`, no custom axioms) |
| Fast computation engine (`build`, `aliveUpTo`, `Qeng`) | ✅ defined, matches A005185 |
| Engine ⟷ spec agreement, finite window | ✅ `native_decide` up to `n = 10⁵` (`engine_faithful_100k`) |
| Immortality certificate, finite | ✅ `native_decide` up to `n = 10⁶` (`alive_1e6`) |
| **Problem A (proof)** | ❌ open — target `theorem problemA : ProblemA` |
| **Problem B (proof)** | ❌ open — target `theorem problemB (h : ProblemA) : ProblemB h` |
| Determinism lemma | ◻️ stated (`Deterministic`), unproven |
| Engine ⟷ spec agreement, general `N` | ◻️ obligation for research phase |

The `native_decide` theorems are **finite certificates**, not a proof of
Problem A. They exist to (a) pin the engine's faithfulness to the specification
on a large window and (b) provide reproducible data. See "Trust base" below.

## Layout

```
QSequence/
  Engine.lean   -- computable exact-integer engine (Option/Array), for native_decide
  Spec.lean     -- faithful mathematical spec (IsHistory) + exact Problem A/B statements
  Checks.lean   -- Bool checker `checkHistory` verifying the spec rule pointwise
  Verify.lean   -- native_decide theorems: engine⟷spec (1e5), immortality (1e6), value/non-monotonicity
scripts/
  q_reference.py -- fast exact-integer Python impl (mirrors the engine) + diagnostics
  setup_lean.sh  -- reinstall the exact toolchain without elan (see below)
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
lake build                     # builds everything and re-runs the native_decide proofs (~60s)
```

`lake build` is the full verification: it re-checks every theorem, including the
`native_decide` certificates (which recompile and re-run the underlying
computation).

Numeric experiments (much faster than `native_decide` for exploration):

```bash
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
- The `native_decide` theorems in `Verify.lean` additionally depend on
  `Lean.ofReduceBool` and the native-compilation axiom (visible in
  `#print axioms`). They add the C compiler + runtime to the trusted base.
  They are **finite** and are not, and cannot be, a proof of Problem A.
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
