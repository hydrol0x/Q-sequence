# The Hofstadter Q-sequence: formal reductions, verified computation, and a route audit

```
Q(1) = 1,  Q(2) = 1,
Q(n) = Q(n − Q(n−1)) + Q(n − Q(n−2))   for n ≥ 3;
Q dies at n  iff  Q(n−1) ≥ n or Q(n−2) ≥ n.

Problem A (immortality):  every Q(n) is defined.
Problem B (asymptotics):  Q(n)/n → 1/2.
```

**Status: Problems A and B are not resolved by this work.** No proof of
immortality, no death index, and no unconditional proof of the limit was
found; every attempted route ends at a precisely identified obstruction.
What this repository delivers instead, in machine-checked or exactly
reproducible form:

1. **Machine-checked reductions** (Lean 4, core only, no `sorry`; the
   mathematics uses only the three standard axioms, and the ⊕-marked finite
   certificates additionally trust the `native_decide` evaluator, §2): the
   Q-sequence is unique; *Problem A is equivalent to the single statement
   `Q(n) ≤ n` for all n* (`UniformBound`), and equivalent to the verified
   engine never dying; exact deviation and lookup-location identities;
   **sharp half-exclusions** — under A no eventual linear bound on either
   side of ½ can hold, so `liminf Q(n)/n ≤ 1/2 ≤ limsup Q(n)/n`; **the
   full conditional-limit theorem** (Theorem C/Golomb, §5) and the
   machine-checked pinning **Gap B ⟺ `RatioCauchy`** (§9);
   spec-level finite certificates through 10⁸.
2. **Verified computation to 10⁹** with zero violations of `Q(n) ≤ n`,
   cross-validated by seven independent implementations, with the adversarial
   statistics (deviation growth, generation spillover, jump records) that any
   proposed proof must survive.
3. **A rigorous no-go theorem** — the two-parameter linear-envelope
   induction cannot close (Theorem D) — plus *data-level* refutations of the
   finite-state and renewal routes at all tested abstractions and scales
   (§8), and a scope theorem retiring the hardness route (Proposition E).
4. **A route audit** of the eight approach families from the task portfolio,
   each with its exact blocking statement.
5. **The remaining gaps stated exactly** (§9): Gap A and Gap B, each a single
   mathematical statement whose proof closes the corresponding problem.

Everything below distinguishes sharply between *proved* (Lean-checked or
full proof given here), *computed* (exact integer computation, reproducible,
finite), and *observed* (empirical trends in the computed range, used only as
route-blocking evidence, never as assumptions).

---

## 1. Formal statements (what exactly is to be proved)

The Lean formalization (this repository, `QSequence/`) fixes the objects:

* A **history** is a finite list `a` with `a[i] = Q(i+1)` such that every
  position `1 ≤ n ≤ a.length` obeys the base cases / recurrence with lookup
  indices in `[1, n−1]` (`IsHistory`, `QSequence/Spec.lean`). This is the
  honest carrier of "Q is defined on `[1, N]`": the death condition
  `Q(n−1) ≥ n ∨ Q(n−2) ≥ n` is exactly the negation of the in-range
  requirement, and `n − Q(n−1) = 0` is death, not an edge case
  (`history_pos` shows values are ≥ 1, so lookups can never exit `[1, n−1]`
  upward — the boundary bookkeeping is pinned once and for all).
* **Problem A** := for every `N` there is a history of length `N`
  (`ProblemA`).
* **Problem B** := in integer ε–N form: for every `k ≥ 1` eventually
  `|2Q(n) − n|·k < n` (`ProblemB`, contingent on A via the canonical value
  function `Qval`); the A-free conditional form is `ProblemB_conditional`.

No real numbers, no filters, no hidden analytic content: both problems are
arithmetic statements about finite lists.

## 2. Machine-checked results (Lean 4.33.0, core only)

All results below compile with **no `sorry`**; the axiom audit
(`#print axioms`) shows exactly `propext, Classical.choice, Quot.sound` for
the mathematics, plus the `native_decide` compiler axiom for the finite
certificates only (marked ⊕ below).

| Theorem (file) | Content |
|---|---|
| `history_pos`, `history_ge_two` (Basic) | history values are ≥ 1 (≥ 2 from position 3): lookup indices lie in `[1, n−1]` automatically from below-only failure |
| `deterministic` (Basic) | any two histories agree on their common prefix — **the** Q-sequence is unique |
| `isHistory_take` (Basic) | prefixes of histories are histories (death is forever, in contrapositive form) |
| `isHistory_extend` (Basic) | a history of length `m ≥ 2` extends iff the death condition fails at `m+1`; the new value is forced |
| **`problemA_iff_uniformBound`** (Basic) | **Problem A ⟺ `UniformBound`** := every value of every history obeys `Q(n) ≤ n` |
| `Qval_eq_valAt` (Basic) | the canonical value function agrees with every history (Problem B's statement is history-independent) |
| **`deviation_identity`** (Basic) | exact: `e(n) = e(n−Q(n−1)) + e(n−Q(n−2)) + (n − Q(n−1) − Q(n−2))` for `e(m) = 2Q(m) − m` |
| `lookup_first_formula`, `lookup_second_formula`, `lookup_gap` (Basic) | exact: `2·j₁ = (n+1) − e(n−1)`, `2·j₂ = (n+2) − e(n−2)`, `j₂ − j₁ = Q(n−1) − Q(n−2)` |
| `step_sound`, `step_isSome_of_longer`, `build_sound`, `build_isSome_of_history` (Faithful) | the computation engine is faithful to the specification, **both directions, every N** |
| **`aliveUpTo_iff_history`** (Faithful) | engine survival at `N` ⟺ a spec-history of length `N` exists |
| `Qeng_eq_valAt` (Faithful) | engine values = values of every history |
| **`problemA_iff_engine`** (Certificates) | Problem A ⟺ the engine never dies; with the above: **A ⟺ `∀N, aliveUpTo N` ⟺ `UniformBound`** |
| `history_1e7`, `history_upto_1e7` (Certificates) ⊕ | spec-level: histories of every length ≤ 10⁷ exist (the sequence provably does not die at or before 10⁷) |
| `Q_1e6`, `Q_1e7`, `Qval_1e7` (Certificates) ⊕ | every history reaching 10⁶ / 10⁷ has `Q(10⁶) = 512066`, `Q(10⁷) = 5124632` |
| `Q_4`, `Q_96` (Certificates) ⊕ | spec-level `Q(4) = 3`, `Q(96) = 64` (data anchors for Theorem D) |
| `nonmono_spec` (Certificates) ⊕ | spec-level `Q(16) = 9 < 10 = Q(15)`: Q is not monotone |
| `no_uniform_bound_below_3_4` (Certificates) ⊕ | no bound `Q(n) ≤ c·n` with `c < 3/4` holds on histories (witness `Q(4) = 3`) |
| `Qval_pos`, `Qval_le_self`, `Qval_rec` (Asymptotics) | under A, the canonical `Qval` is positive, `≤ id`, and satisfies the recurrence |
| **`not_eventually_ge_three_quarters`** (Asymptotics) | under A, `Q(m)/m ≥ 3/4` cannot hold for all large `m` — the machine-checked kernel of the `c = 1` endpoint exclusion in Theorem C |
| **`not_eventually_ge_of_gt_half`** (HalfExclusions) | under A, for **every** rational `c > 1/2`, `Q(m) ≥ c·m` cannot hold for all large `m` (iterated envelope refinement; sharpens the ¾ threshold to its sharp value ½) |
| **`not_eventually_le_of_lt_half`** (HalfExclusions) | under A, for **every** rational `c < 1/2`, `Q(m) ≤ c·m` cannot hold for all large `m` (level-doubling induction `2^j` vs. threshold growth `(q/(q−p))^j < 2^j`) |
| `frequently_lt_of_gt_half`, `frequently_gt_of_lt_half` (HalfExclusions) | the ∀∃ forms: under A, `liminf Q(n)/n ≤ 1/2 ≤ limsup Q(n)/n` |
| **`problemB_of_ratioCauchy`** (TheoremC) | **Theorem C in full**: under A, if the ratio sequence is Cauchy (`RatioCauchy`, integer cross-multiplied form) then `Q(n)/n → 1/2` (`ProblemB`) — both endpoints included, no assumption on the limit's location |
| **`problemB_iff_ratioCauchy`** (TheoremC) | under A, `ProblemB ⟺ RatioCauchy`: Gap B **is** "the ratio sequence is Cauchy", as a machine-checked equivalence |

The equivalence chain is the load-bearing item: **a proof of the single
statement `UniformBound` — a statement about finite lists only — resolves
Problem A**, and any resolution of Problem A must in particular prove it.
This pins the *exact strength* of what is missing (§9).

## 3. Verified computation to 10⁹

`scripts/compute_q.c` (exact `uint64` arithmetic, `uint32` storage, with the
storage validity *checked* at every step: any `Q(n) > n` would be reported;
none occurred, so the run itself is a machine check of `UniformBound` on
`n ≤ 10⁹`). Results (`data/run_1e9.log`):

* **Survives through N = 10⁹.** Zero violations of `Q(n) ≤ n`.
* `Q(10⁹) = 497429917` (`2Q−n = −5140166`).
* `max |2Q(n)−n| = 67 023 661` at `n = 989 523 521` (≈ 0.0677·n).
* `max |Q(n)−Q(n−1)| = 52 719 055` (at `n = 984 141 755`, a *downward* jump
  of ≈ 0.054·n): successive differences are enormous; "slowness"-type
  hypotheses fail catastrophically, not marginally.
* `max_{3≤n} Q(n)/n = 3/4`, attained at `n = 4` and **never attained
  again**: per-generation `max Q(n)/n` declines from 0.667 (early) through
  0.614 (gen 10) to **0.5345** (gen 29, partial: up to 10⁹) — a steady
  downward trend with small wiggles (e.g. 0.5813 → 0.5866 between gens
  12–13), never re-approaching earlier maxima. The ten largest ratios over
  `n ∈ [100, 5·10⁸]` all occur below `n = 1600` (criticality agent, §8 R6).
  Death requires `Q(n)/n ≥ 1`.

Cross-validation matrix (seven independent implementations — different
authors/languages/data layouts — agreeing exactly; the renewal agent
additionally re-derived its values in pure Python):

| value | C (this run) | Lean `native_decide` | Python ref | agent 1 (C) | agent 2 (C) | agent 3 (C) | agent 4 (C) |
|---|---|---|---|---|---|---|---|
| Q(10⁵) | 48157 | — | 48157 | 48157 | 48157 | 48157 | 48157 |
| Q(10⁶) | 512066 | **512066** (spec-level) | 512066 | 512066 | — | 512066 | 512066 |
| Q(10⁷) | 5124632 | **5124632** (spec-level) | 5124632 | 5124632 | — | 5124632 | 5124632 |
| Q(10⁸) | 50166508 | **50166508** (spec-level) | — | 50166508 | — | — | 50166508 |
| Q(5·10⁸) | 247777817 | — | — | — | — | — | 247777817 |
| Q(2²⁰) | — | — | — | — | 527047 | — | — |
| sum to 10⁷ mod 2⁶⁴ | 25000190971777 | — | — | 25000190971777 | — | 25000190971777 | — |

(agents 1–4 = the closure-search, generation-transfer, renewal-scan, and
criticality-statistics experiment agents; their exact code and raw outputs
are preserved in `experiments/` — see `experiments/README.md` — and the
headline numbers are reproduced in §8. The Lean values are theorems about
*every* spec-history, not about one program run.)

**Deviation growth (the empirical heart of the matter).** Per dyadic
generation `G_k = [2^k, 2^{k+1})` (`data/generations.txt`):

| k | max\|2Q−n\| / 2^k | max Q(n)/n in G_k |
|---|---|---|
| 10 | 0.370 | 0.6138 |
| 14 | 0.257 | 0.5822 |
| 18 | 0.214 | 0.5664 |
| 22 | 0.173 | 0.5507 |
| 26 | 0.154 | 0.5407 |
| 29 | **0.125** | **0.5345** |

The normalized deviation *decays*, supporting Problem B — but only like
`≈ 2^{−0.08k}` (a factor ~3 over 19 generations): fitted over generations
15–28 (criticality agent, exact per-generation moments),
`sd(e) ≈ n^{0.879}` and `max|e| ≈ n^{0.912}` — and the extreme-to-sd ratio
itself *grows* (4.9 → 8.2 over k = 10..28; the tails are heavy). Deviations
are *barely* sublinear. Any proof of Problem B must beat excursions of
relative size 0.125 at scale 10⁹; any death must grow them to relative
size 1.

**An exact spine that dissolves.** `Q(3·2^k) = 2^{k+1}` holds exactly for
`k ≤ 8` (`Q(24)=16, …, Q(768)=512`) and fails at `k = 9`
(`Q(1536) = 808 ≠ 1024`): exact self-similar substructure exists briefly and
is destroyed — a microcosm of why exact-structure methods fail here (§8, R5).

## 4. The exact structure identities and criticality

Machine-checked (`deviation_identity`, `lookup_*`): with `e(m) = 2Q(m) − m`,
`a = n − Q(n−1)`, `b = n − Q(n−2)`,

```
e(n) = e(a) + e(b) + (n − Q(n−1) − Q(n−2))            (I1)
     = e(a) + e(b) − (e(n−1) + e(n−2) − 3)/2          (I2, rewriting)
2a   = (n+1) − e(n−1),   2b = (n+2) − e(n−2)          (lookup location)
b − a = Q(n−1) − Q(n−2)  = d(n−1)                     (I3, lookup separation)
```

Reading: the recursion reads the sequence at the *half-scale midpoint*,
displaced by half the local deviation, at two points separated by exactly
the local difference `d(n−1)`; the new deviation is the *sum* of the two
half-scale deviations (reinforcement, gain 2 per generation) minus *half*
the local average deviation (damping, gain −1 per generation over the two
terms). The linearized per-generation gain is exactly `2 − 1 = 1`:
**the deviation dynamics is critical** — neither contracting (which would
prove B, hence bound A's danger away) nor expanding (which would suggest
death). Every naive envelope or contraction argument runs into this exact
`= 1`, and Theorem D makes that obstruction rigorous for the standard
induction template. The identities I1–I3 were additionally verified exactly
at every `n ≤ 5·10⁸` by an independent implementation (0 violations), and
the measured exponents and correlations (§8, R6) quantify how the critical
dynamics actually behaves: deviation scale `n^{0.88}`, lookup streams
numerically uncorrelated, damping 14.6% anti-aligned with reinforcement.

## 5. Theorem C (the conditional limit; known, included for completeness)

> **Theorem C.** Assume Problem A. If `Q(n)/n → c` exists, then `c = 1/2`.

**Now fully machine-checked** (`QSequence/TheoremC.lean`,
`problemB_of_ratioCauchy`; standard axioms only).  The Lean proof takes a
cleaner route than the classical case analysis below: the two **sharp
half-exclusions** (`HalfExclusions.lean`) supply, for every accuracy `1/k`,
one point `m₀` with ratio `< 1/2 + 1/(4k)` and one point `m₁` with ratio
`> 1/2 − 1/(4k)` beyond any threshold; the Cauchy estimate then transfers
these one-point bounds to *every* large `n`.  No fixed-point equation, no
case split on where the limit lies, and "the limit exists" is taken in the
honest integer Cauchy form (`RatioCauchy`), so the theorem is exactly the
conditional lemma with no hidden analytic content.  The sharp exclusions
themselves strengthen the endpoint lemmas of this section from thresholds
`3/4` (and the doubling constant `1/8`) to the sharp constant `1/2` on both
sides — under A, **no eventual bound `Q(m) ≥ c·m` with rational `c > 1/2`
and no eventual bound `Q(m) ≤ c·m` with rational `c < 1/2` can hold**; in
limit language, `liminf Q(n)/n ≤ 1/2 ≤ limsup Q(n)/n` unconditionally
under A.

The classical proof below is retained for exposition (its case analysis is
what the machine-checked route replaces). Per the task rules Theorem C is
*not progress* (the hard content of B is the existence of the limit). Under
A: `1 ≤ Q(n) ≤ n` (machine-checked equivalence), so `c ∈ [0,1]`.

*Case `0 < c < 1`.* Fix `ε ∈ (0, (1−c)/2)` and `M` with
`|Q(m)/m − c| ≤ ε` for `m ≥ M`. For `n` large, `a_n = n − Q(n−1)` and
`b_n = n − Q(n−2)` satisfy `a_n, b_n ≥ (1−c−2ε)n → ∞`, so both exceed `M`
and `Q(a_n)/n = (Q(a_n)/a_n)(a_n/n) ∈ [(c−ε)(1−c−2ε), (c+ε)(1−c+2ε)]`,
likewise for `b_n`. Hence `Q(n)/n → 2c(1−c)`, and by uniqueness of limits
`c = 2c(1−c)`; since `c ≠ 0`, `c = 1/2`.

*Case `c = 0` is impossible.* Take `ε = 1/8`, `M` with `Q(m) ≤ εm` for
`m ≥ M`, and `T = M + 2`. Let `L(x) = min{Q(m) : m ≥ x}` (a min of a set of
positive integers). For `t ≥ T` and any `m ≥ t`: `a_m = m − Q(m−1) ≥
m − ε(m−1) ≥ (1−ε)m ≥ (1−2ε)t`, and likewise `b_m ≥ (1−2ε)t`; so
`Q(m) = Q(a_m) + Q(b_m) ≥ 2L((1−2ε)t)`, giving

```
L(t) ≥ 2·L((1−2ε)t)      for all t ≥ T.
```

Iterating `j⋆ = ⌊log(t/T)/log(1/(1−2ε))⌋` times (each intermediate argument
stays ≥ `T` by the choice of `j⋆`, and `L ≥ 1` at the bottom):
`L(t) ≥ 2^{j⋆} ≥ ½·(t/T)^β` with
`β = log 2 / log(1/(1−2ε)) = log 2 / log(4/3) ≈ 2.41 > 1`.
But `L(t) ≤ Q(m_t) ≤ ε(t + M + 1)` for the least integer `m_t ≥ max(t, M)` —
linear. Contradiction for large `t`. ∎

*Case `c = 1` is impossible.* Take `ε = 1/4`, `M` with `Q(m) ≥ (1−ε)m` for
`m ≥ M`. For `n ≥ M + 2`: `a_n ≤ n − (1−ε)(n−1) ≤ εn + 1` and
`b_n ≤ εn + 2`; since `Q(m) ≤ m` always (A), `Q(n) = Q(a_n) + Q(b_n) ≤
a_n + b_n ≤ 2εn + 3 = n/2 + 3`. But `Q(n) ≥ (3/4)n`. Contradiction for
`n ≥ 13`. ∎  *(This step is machine-checked:
`not_eventually_ge_three_quarters` in `QSequence/Asymptotics.lean` proves,
under A, that `Q(m)/m ≥ 3/4` for all large `m` is impossible; the same
one-step argument works for any threshold `> 2/3`.)*

Note precisely where A is used: totality plus `Q ≤ id` (i.e. `UniformBound`).
This proof does **not** prove the limit exists; that is Gap B.

## 6. Theorem D (no-go for the two-parameter linear-envelope induction)

The route "prove `c₁n − d₁ ≤ Q(n) ≤ c₂n + d₂` by strong induction, with
`c₂ < 1`, settling Problem A beyond a finite check" is the natural
formalization of the two-parameter induction family (it is how the
Conolly/Tanny-family sequences are handled). Its inductive step, made
explicit, is:

> **Step(c₁,c₂,d₁,d₂,N₀):** for every `n ≥ N₀` and every function
> `f : {1,…,n} → ℤ_{≥1}` such that (i) `f(m)` lies in the envelope
> `E(m) = [max(1, c₁m − d₁), c₂m + d₂]` for all `m < n`, and (ii) `f`
> satisfies the Q-recurrence **at n** (`f(n) = f(n−f(n−1)) + f(n−f(n−2))`
> with lookups in `[1, n−1]`) — the value `f(n)` again lies in `E(n)`.

This is exactly what "the induction closes" means when the inductive
hypothesis is the envelope and the only structural input at `n` is the
recurrence. (Schemes whose inductive hypothesis carries *more* than the
envelope — window constraints, or use of the recurrence at earlier
positions `m < n` — are a different, stronger family not covered by the
theorem; the window family is route R1, blocked by data, §8.)

> **Theorem D.** Let `0 ≤ c₁ ≤ c₂ < 1` and `d₁, d₂ ≥ 0` be reals such that
> (a) `E(m)` contains an integer ≥ 1 for every `m ≥ 1` (necessary for the
> envelope to hold for any sequence at all, in particular for Q), and
> (b) the envelope admits the machine-verified values `Q(1) = 1` and
> `Q(96) = 64` (necessary for the induction to pass through its own base
> data). Then **Step(c₁,c₂,d₁,d₂,N₀) is false for every N₀**: for all
> sufficiently large `n` there is an envelope-consistent `f` satisfying the
> recurrence at `n` with `f(n) ∉ E(n)`.

*Proof.* Throughout, "choose `f(m)` maximal/minimal" means: take the
largest/smallest integer of `E(m)`. By (a) these exist, lie in `E(m)`, and
satisfy the two-sided estimates `⌊c₂m + d₂⌋ ≥ c₂m + d₂ − 1` (maximal) and
`max(1, ⌈c₁m − d₁⌉) ≤ max(1, c₁m − d₁ + 1)` (minimal): if any integer lies
in `E(m)`, then so do `⌊upper⌋` and `⌈max(1, lower)⌉`. Positions other than
the four that the recurrence at `n` reads are filled with an arbitrary
envelope integer.

**Case 1: `c₁ < 1/2`, `c₂ > 0`** (upper break). For large `n` set
`f(n−1) := max(3, minimal at n−1)` and `f(n−2) := max(3, minimal at n−2)`.
(Membership: when the max is the minimal choice this is (a); when the max is
`3`, the minimal integer was < 3, so 3 exceeds the lower edge, and
`3 ≤ c₂(n−1) + d₂` for large `n` since `c₂ > 0`.) Both are
`≤ c₁n + 4 < n − 1` for large `n`. Then the lookup indices satisfy
`a, b ≥ (1−c₁)n − 5` and `a, b ≤ n − 3` (no collision with `n−1, n−2`).
Choose `f(a) := ⌊c₂a + d₂⌋` and `f(b) := ⌊c₂b + d₂⌋`. Then

```
f(n) = f(a) + f(b) ≥ c₂(a+b) + 2d₂ − 2 ≥ 2c₂(1−c₁)n − K
```

for a constant `K` independent of `n`. Since `2c₂(1−c₁) − c₂ =
c₂(1 − 2c₁) > 0`, `f(n) − (c₂n + d₂) ≥ c₂(1−2c₁)n − K − d₂ → ∞`: the upper
envelope breaks for all large `n`. ∎(case)

**Case 2: `c₁ < 1/2`, `c₂ = 0`.** Then `c₁ = 0` (as `c₁ ≤ c₂`); the
envelope is `[1, d₂]` with, by (b) at `m = 96`, `d₂ ≥ 64`.
Set `f(n−1) = f(n−2) = 3`, so `a = b = n−3`, and `f(n−3) := ⌊d₂⌋`. Then
`f(n) = 2⌊d₂⌋ ≥ 2d₂ − 2 > d₂` since `d₂ ≥ 64`. Upper break. ∎(case)

**Case 3: `c₁ ≥ 1/2`, `c₂ > 1/2`** (lower break). For large `n` choose
`f(n−1), f(n−2)` **maximal** (`= ⌊c₂(n−1) + d₂⌋` etc.; both `≤ n − 1` since
`c₂ < 1` and `n` large). Then `(1−c₂)n − d₂ ≤ a, b ≤ (1−c₂)n + 3`,
both `→ ∞` and eventually distinct from `n−1, n−2`. Choose `f(a), f(b)`
**minimal**: `f(a) ≤ c₁a + 1 ≤ c₁((1−c₂)n + 3) + 1`, same for `b`. Then

```
f(n) ≤ 2c₁(1−c₂)n + K′,
```

and since `c₁(1 − 2(1−c₂)) = c₁(2c₂ − 1) > 0` (as `c₁ ≥ 1/2 > 0`),
`(c₁n − d₁) − f(n) ≥ c₁(2c₂−1)n − K′ − d₁ → ∞`: the lower envelope breaks.
∎(case)

**Case 4: `c₁ = c₂ = 1/2`** (the critical template). By (b) at `m = 96`:
`48 + d₂ ≥ 64`, so `d₂ ≥ 16`, hence `d₁ + d₂ ≥ 16`. Choose `f(n−1), f(n−2)`
minimal (`= ⌈(m)/2 − d₁⌉` at `m = n−1, n−2`; ≥ 3 for large `n`), giving
`n/2 + d₁ − 1/2 ≤ a` and `n/2 + d₁ ≤ b`, with `a, b ≤ (n+1)/2 + d₁ + 1 <
n − 2` for large `n` (so no collision with the fixed positions), and choose
`f(a), f(b)` maximal. Exact bookkeeping (each floor/ceiling loses < 1):

```
f(n) = f(a) + f(b) ≥ (a/2 + d₂ − 1) + (b/2 + d₂ − 1) ≥ n/2 + d₁ + 2d₂ − 5/2 ,
```

(also valid when `a = b`, with `f(n) = 2f(a)`). The upper envelope at `n`
allows `n/2 + d₂`; the excess is `d₁ + d₂ − 5/2 ≥ 16 − 5/2 > 0`. Upper
break. ∎(case)

Cases 1–4 cover `0 ≤ c₁ ≤ c₂ < 1` (`c₁ < 1/2` → 1 or 2; `c₁ ≥ 1/2` →
`c₂ ≥ c₁ ≥ 1/2`, hence 3 or 4). ∎

*Numerical verification.* `scripts/check_theorem_d.py` re-runs the four
constructions in exact rational arithmetic and confirms the break on a
parameter grid.  An independent adversarial audit re-implemented the
constructions from the proof text over 31 919 hypothesis-satisfying
parameter sets (boundaries and `c₁ = 1/2 ± 10⁻⁹` included) and found no
counterexample; as the margin coefficient is `c₂(1 − 2c₁)` (Case 1), the
"sufficiently large `n`" threshold scales like its inverse, so
near-critical templates (`c₁ = 1/2 − 10⁻⁶`) break only from `n ≈ 10⁹` on —
verified there and beyond.

**Reading Theorem D.** The two-parameter linear induction — the exact
mechanism the task portfolio proposes as "targeting an unconditional linear
bound `Q(n) ≤ cn` with `c < 1`" — cannot close, *no matter the constants*,
because the envelope alone leaves the recurrence free to place both lookups
adversarially. This sharpens the folklore fixed-point heuristic ("the
constants only balance at 1/2") into an unconditional statement, including
the critical template, whose failure is forced by the machine-verified value
`Q(96) = 64` alone. What is *not* excluded: inductions whose hypothesis
carries more information than a two-sided linear envelope (window
constraints — route R1, blocked by data; or genuinely new coordinates, §9).
Also `no_uniform_bound_below_3_4` (Lean): any usable `c₂` lies in
`[3/4, 1)`.

## 7. Proposition E (the hardness route, resolved in scope)

> **Proposition E.** (i) Problem A is a Π⁰₁ statement: death is witnessed by
> a finite exact computation (`aliveUpTo` is a total computable function;
> Lean: `problemA_iff_engine`). (ii) Consequently, if Problem A is
> independent of ZFC (or of PA), then Q is immortal. (iii) The
> Celaya–Ruskey undecidability of the *class* of nested recurrences yields
> no information about this instance.

*Proof.* (i) is the machine-checked equivalence. (ii): if Q died at some
`n₀`, the finite computation certifying `aliveUpTo n₀ = false` is a true
Σ₁ fact; by Σ₁-completeness PA proves it, so PA ⊢ ¬A, contradicting
independence. Hence independence implies no death index exists. (iii): an
undecidability result for a family `{recurrence, variable initial data}`
asserts no uniform algorithm decides all members; it is consistent with any
particular member being provable either way; and Problem A fixes the
initial data, leaving no encoding freedom inside the problem as posed. ∎

So the "hardness-oriented route" cannot produce a *third* outcome: any
independence proof would itself resolve Problem A affirmatively (without a
ZFC proof). This is a scope theorem, not progress on A; it retires the route
as a way of avoiding the dichotomy.

## 8. Route registry (approach families, status, blocking statements)

Each route lists: mechanism / what was actually done here / status /
the precise statement that blocks or would unblock it. "Blocked" means
*blocked as formulated* — with the exact reformulation obligation stated —
not "proved impossible in principle" (except D, which is a theorem).

**R1 — Finite closed constraint systems** (the V-sequence/BKT mechanism).
*Done:* exact computation of every natural local abstraction to 10⁷–10⁸
(closure-search agent; code+raw output preserved): alphabets of
`d(n) = Q(n)−Q(n−1)`, `s(n) = Q(n)+Q(n−1)−n`, `e(n) = 2Q(n)−n` grow without
saturation (4 080 633 / 2 799 985 / 4 721 573 distinct values by 10⁸;
ranges ≈ ±5·10⁶) — **the finite-alphabet precondition fails outright** for
exact windows. For finite coarsenings (`sign(e)`; `e mod 4`;
`(sign e, sign d)`): every window size `w ∈ {4,…,32}` exhibits explicit
ambiguity counterexamples (identical `w`-window, two different successors);
among windows that recur at all, 46–53% remain ambiguous at `w = 32`; the
`e mod 4` abstraction realizes the *entire* parity-admissible shift space
through `w = 16` (maximal disorder). *Status:* **blocked at all tested
abstractions/scales.** *Blocking statement:* every tested abstraction loses
the information that determines successors; a closed system would need a
new, finite, faithful local alphabet — none is known, and the unbounded
deviation alphabet is the obstruction the task itself flags ("statistical,
not exact" self-similarity).

**R2 — Two-parameter linear induction.** *Done:* Theorem D (§6), plus the
Lean floor `c ≥ 3/4`. *Status:* **closed by theorem** (within the template
family; the family is exactly the one proposed). *Unblock obligation:* an
inductive hypothesis strictly stronger than a two-sided linear envelope,
with a proof that the extra structure regenerates itself — no candidate
survived R1/R3 testing.

**R3 — Generation-transfer inequalities** (values on `[2^k, 2^{k+1})` from
`[2^{k−1}, 2^k)`). *Done:* exact spillover census (this run + transfer
agent, independently agreeing): 98.0–98.6% of lookups land in the parent
generation at k = 24–28 — but 1.4–2.0% do not (0.5–0.7% land *below* the
parent). Rigorous interval-arithmetic conditioning experiment (transfer
agent): seeding generation `G_19` with uncertainty ±E₀ and propagating the
recurrence's uncertainty *collapses totally within 15–49 steps* past the
seed boundary, for every E₀ ∈ {1, 8, 64}: widths hit the value cap, and from
step 24 on the lookup-index intervals reach below index 1, so the knowledge
state cannot even exclude death. Sanity check E₀ = 0 propagates exactly
(0 width forever), so the collapse is intrinsic, not instrumental. Mechanism
(measured): local oscillation — mean `|Q(n+1)−Q(n)|` ≈ 11 147 at scale 2¹⁹
(max 94 640), growing ×1.84 per generation (≈ n^0.88) — multiplies every
index error; absolute-error transfer is quantitatively impossible.
*Status:* **blocked in absolute-error form (measured, decisively).**
*Unblock obligation:* transfer inequalities in cancellation-respecting
coordinates (the interval bound double-counts the sign correlation between
lookup-index error and value error), robust to the 1.4–2% spillover, and
strong enough to beat an oscillation term growing like `n^0.88` — no such
coordinates are known (cf. R6 measurements).

**R4 — Diluted model `q(n) = q(n − q(n−1)) + f(n)` toward self-referential
`f`.** *Done:* not attempted beyond scoping (per the task's own rule that
diluted-model results do not transfer without proof). *Status:* open but
unworked here. *Precise obstacle:* in the diluted model the second term is
exogenous and slowly varying; in Q the "perturbation"
`f(n) = Q(n − Q(n−2))` has the same order of magnitude and the same
criticality as the main term (its deviation is `e(b)` with `2b = n+2−e(n−2)`
— §4), so no perturbative hierarchy exists to transfer along.

**R5 — Exact renewal events / morphic substructure.** *Done:* renewal-scan
agent (all equalities verified exactly; machinery validated against brute
force): longest exact repeated substring of `d` is **9 symbols** — at 10⁵,
10⁶, and 10⁷ alike (same witness, `d(375..383) = d(759..767)`); longest
exact dyadic alignment `d(2^k+i) = d(2^{k+1}+i)` is **0 symbols** for every
`k ∈ [10, 22]`; the 231 zeros of `e` below 10⁷ are followed by 231 pairwise
distinct 32-symbol `d`-windows (no renewal pattern); the only giant repeat
is the parity identity `e(n) ≡ n (mod 2)` (trivially forced by the
definition). The exact spine `Q(3·2^k) = 2^{k+1}` dies at `k = 9` (§3).
*Status:* **blocked at tested scales — no exact substructure exists to
build on.** *Unblock obligation:* exhibit any exact, unboundedly recurring
substructure; the data says none exists below 10⁷–10⁸.

**R6 — Derandomizing the probabilistic survival heuristic.** *Done:* the
exact criticality identities (§4, machine-checked in Lean, and verified
exactly at every `n ≤ 5·10⁸` by the criticality agent — 0 violations)
isolate what a derandomization must control; the agent measured the actual
deviation dynamics to 5·10⁸ (per-generation moments in exact `__int128`
arithmetic; values cross-validated): the deviation scale grows like `n^α`
with fitted `α = 0.879` (s.d.-based, generations 15–28; 0.882 over full
generations) and `α = 0.912` (generation-max-based); the per-generation
growth factor `sd_k/sd_{k−1}` is a strikingly stable **1.840–1.846** for
every full generation `k = 13..27` — the empirical signature of the critical
dynamics. The two lookup streams `e(a), e(b)` have per-generation
correlation decaying from +0.044 (k = 11) to **+0.00001** (k = 28): the
independence assumed by random-walk heuristics is *quantitatively accurate*
at large scale (consistent with the exact separation `b − a = d(n−1)`,
whose median is ≈ 0.44·sd(e) ≈ 1.8·10⁶ indices at k = 28). The
damping-vs-reinforcement correlation converges to **−0.1464** (stable to 4
decimals for k ≥ 22): the mean-reversion is real but weak — 14.6%
anti-alignment, nowhere near a deterministic contraction. *Status:*
**blocked by the statistics-to-worst-case wall, now with the wall
quantified**: survival needs `|e(n)| < n` *always*; the death boundary sits
121 sd(e) away at `n = 5·10⁸` but approaches at rate `n^{1−α} = n^{0.12}` in
sd units, while the observed extreme-to-sd ratio itself *grew* from 4.9 to
8.2 over k = 10..28 (heavy tails: `α_max − α_sd ≈ +0.03`), and the
per-generation `max|e(n)|/n` fell from 0.228 to 0.072 — margins widen even
as typical deviations swell. *No proven tail bound of any strength exists*
(a tail bound of strength `o(n)` is exactly Gap B, and `< n` is Gap A).
*Unblock obligation:* any unconditional tail estimate for `|e|` — this is
not a route to the gap, it *is* the gap.

**R7 — Undecidability / computation-encoding.** *Done:* Proposition E.
*Status:* **retired in scope**: for this fixed instance, "hardness" can only
mean independence, and independence would itself prove immortality. Encoding
computation requires initial-condition freedom the problem does not grant.

**R8 — Death search (disproof orientation).** *Done:* margins tracked to
10⁹ (this run) and 5·10⁸ (criticality agent, independent): the all-time
ratio record `Q(n)/n = 3/4` stands at `n = 4`; per-generation max ratio
declines steadily (with small wiggles) to 0.5345; the largest deviation excursions
(`data/records_absdev.txt`) grow like `n^0.92` while death needs an
excursion to `e(n) ≈ n`. The two lookup streams sample points separated by
`|d(n−1)|` (exact; §4), so a death-producing "resonance" would need the
deviation field to be simultaneously extreme across huge separations; no
repeating mechanism was found (R5) and no near-miss trend exists (margins
widen, not narrow). *Status:* alive in principle (death index > 10⁹ if it
exists — and > 3·10¹⁰ per the task statement's own bound); **no mechanism
candidate found.** *Unblock obligation:* a construction making `e` grow at
rate `Θ(n)` along a subsequence — nothing in the computed statistics
suggests one.

**Cross-cutting audit discipline.** Every number above traces to committed
code + raw output; every invariant used by any argument is either proved in
Lean (positivity, determinism, the identities, `Q ≤ id ⟺ A`) or was
machine-tested to ≥ 10⁸ before use (`Q(n) ≤ n`: 10⁹, zero violations;
`e(n) ≡ n mod 2`: 10⁷, zero violations — and trivially provable). The
adversarial checklist from the task (boundary bookkeeping; silent
`Q(m) < m` assumptions; circular use of Theorem C; treating the generation
structure as exact; unproven transfer from variants) was applied to each
route above — it is *why* R1–R3 are marked blocked rather than promising.

## 9. The remaining gaps, stated exactly

**Gap A** (its proof resolves Problem A; machine-checked equivalence
`problemA_iff_uniformBound` + `problemA_iff_engine`):

> **`UniformBound`:** for every finite list `a` with `IsHistory a` and every
> `1 ≤ n ≤ a.length`: `valAt a n ≤ n`.
>
> Equivalently (proved equivalent): the exact-integer engine `build N`
> never returns `none`.

Nothing weaker suffices (the equivalence is two-sided), and by
`no_uniform_bound_below_3_4` any linear strengthening must have slope
≥ 3/4. Computed status: true for all `n ≤ 10⁹` (zero violations), with the
per-generation margin trend-improving (max ratio 0.5345 in the last computed
generation). By Theorem D, no two-parameter linear-envelope induction proves
it; by R1's data, no tested finite local abstraction determines the sequence
well enough to certify it; by Proposition E, even an independence proof
would entail it.

**Gap B** (with Gap A, resolves Problem B; without it, resolves the
conditional form the task accepts):

> For every `k ≥ 1` there is `N₀` with `|2·Q(n) − n| · k < n` for all
> `n ≥ N₀` — i.e. `max_{m ≤ n} |2Q(m) − m| = o(n)`.
>
> Equivalently (machine-checked, `problemB_iff_ratioCauchy`): **the ratio
> sequence `Q(n)/n` is Cauchy** (`RatioCauchy`, integer cross-multiplied
> form: `∀ k ≥ 1, ∃ N, ∀ m,n ≥ N, |Q(m)·n − Q(n)·m|·k ≤ m·n`).

Theorem C — now fully machine-checked (`TheoremC.lean`) — shows the limit,
if it exists, is 1/2; Gap B *is* the existence, and no reduction of it
below itself was found: the machine-checked equivalence pins it as exactly
"the ratio fluctuations eventually fall below every `1/k`", nothing more
and nothing less. The sharp half-exclusions bound the gap from both sides:
under A the ratio *must* straddle 1/2 (every eventual one-sided linear
bound off ½ is refuted), so Gap B fails only if the ratio oscillates
across ½ with non-vanishing amplitude forever. Computed status: the
normalized deviation decays from 0.37 to 0.125 over generations 10→29 —
consistent with Gap B being true with `|e| ≈ n^{0.9}` — but the decay
observed is far too slow for any compactness/monotonicity shortcut, and R6's
measurements quantify the criticality any proof must tame.

## 10. Reproducibility and trust base

* **Lean:** `bash scripts/setup_lean.sh && lake build` re-checks every
  theorem including the `native_decide` certificates. Axioms:
  `propext, Classical.choice, Quot.sound`; each ⊕-marked certificate
  additionally depends on its per-call `native_decide` axiom (shown by
  `#print axioms` as `…._native.native_decide.ax_1_1`, of shape
  `decide (…) = true`), i.e. on trusting the compiled evaluator. No `sorry`
  anywhere. A future `theorem problemA : ProblemA` must be
  `native_decide`-free; the reductions here are.
* **C computation:** `gcc -O2 -o scripts/compute_q scripts/compute_q.c &&
  ./scripts/compute_q 1000000000 data` (≈ 4 GB RAM; exact integer
  arithmetic; storage-validity and `Q(n) ≤ n` checked every step; outputs in
  `data/`).
* **Python reference:** `python3 scripts/q_reference.py --upto 10000000
  --stats` (mirrors the engine; used as a third implementation).
* **Theorem D checker:** `python3 scripts/check_theorem_d.py` (exact
  rationals; re-runs the §6 constructions on a parameter grid).
* **Route experiments:** `experiments/` (independent implementations + raw
  outputs; see `experiments/README.md`).
* Checkpoint values and additive checksums for independent re-derivation
  are printed in `data/run_1e9.log` and §3.

## 11. Conclusion

Within this investigation: Problem A was reduced, with machine-checked
equivalences, to the single finite-history statement `UniformBound`
(`Q(n) ≤ n`), verified computationally to 10⁹ with trend-improving
margins; Problem B was pinned to Gap B, with the limit-*value* lemma now
**fully machine-checked** (Theorem C, `TheoremC.lean` — which assumes the
limit exists in integer Cauchy form, and is therefore not the A-free
conditional form the task accepts), Gap B itself machine-checked equivalent
to `RatioCauchy` (`problemB_iff_ratioCauchy`), the ratio proved to straddle
½ from both sides under A (sharp half-exclusions,
`HalfExclusions.lean`), and the criticality
obstruction made exact (`deviation_identity`, Theorem D); the natural
proof mechanisms — finite
closed constraint systems, linear-envelope inductions, absolute-error
generation transfer, exact renewal structure, hardness transfer — were each
either refuted by theorem, refuted by exact computation at the tested
scales, or resolved in scope. **A complete resolution of Problem A or B was
not achieved and is not claimed.** The precise frontier is Gap A / Gap B of
§9: any argument that controls `e(n) = 2Q(n) − n` below `n` (for A) or
below `εn` (for B) — in coordinates that respect the cancellations the
interval experiments show are being thrown away — would close the
corresponding problem, and nothing less will.
