# Check of the in-repo proof of Linnik's theorem

Date: 2026-11-20. Part of the log in `../REPORT.md` and `../DEPENDENCY-ANALYSIS.md`.

**Why this piece.** It is one of the few intermediate results of the alpo.ge Lean code that is stated purely
in Mathlib terms, it is a famous theorem whose truth is not in doubt, and its proof is small (689 project
declarations), so it can be read. It is a spot check of whether the code does recognisable mathematics.
It says nothing direct about the main theorem.

**Status.** The reading is done (sections 1–4). The machine re-check (section 5) is running in a separate
session and is not yet reported.

## 1. What was checked

- Theorem: `UpperTheory.Lit.linnik : GlobalTheory.Published.Linnik`, in
  `src/Development/AutomorphicArithmetic/ThetaCorrespondence/Linnik.lean`.
- Its kernel-level dependency closure (from the published export, see `../DEPENDENCY-ANALYSIS.md`):
  689 project declarations (645 theorems, 44 definitions, no inductive types), in 102 files with 14,932 lines
  in total, plus 78,444 library declarations. `declarations.tsv` lists them, `files.txt` the files.
- 511 of the 689 are hand-written; the rest are auto-generated auxiliaries. Their statements are in
  `statements.txt`.
- To compile it, 517 of the project's 175,187 modules are needed (`import-closure.txt`).

## 2. The statement

```lean
def primesInProgression (a q : ℕ) : Set ℕ := {p | p.Prime ∧ p ≡ a [MOD q]}
noncomputable def leastPrimeMod (a q : ℕ) : ℕ := sInf (primesInProgression a q)
def Linnik : Prop :=
  ∃ C L : ℝ, 0 < C ∧ 0 < L ∧ ∀ a q : ℕ, 1 ≤ a → 1 ≤ q → a.Coprime q →
    (leastPrimeMod a q : ℝ) ≤ C * (q : ℝ) ^ L
```

- The file imports only Mathlib. This is Linnik's theorem.
- The one possible loophole is that the infimum of an empty set of naturals is 0. It is closed: the same file
  proves `linnik_iff_exists_prime`, the equivalence with "there is a prime p ≡ a mod q with p ≤ C·q^L", and
  the proof of `linnik` goes through that form.

## 3. The route

The proof follows the classical one (as in Iwaniec–Kowalski chapter 18, with Gallagher's method for the
density estimate). Declarations in each part's closure in brackets; parts share lemmas.

| Step | Top theorem | Content |
|---|---|---|
| Explicit formula [355] | `explicit_formula_dirichlet_zeros_right_half` | truncated Perron, contour shifted to real part −1/2 at a height avoiding zeros, residues; only zeros with real part ≥ 1/2 are kept and the rest go into an error with a factor q³ |
| Sum over zeros [317] | `exists_sum_characters_finsum_zeros_rpow_re_sub_one_le` | log-free zero-density estimate for all characters mod q: Turán's second power-sum theorem, Gallagher's lemma, a large sieve, Brun–Titchmarsh |
| Exceptional zero [160] | `exceptionalDirichletZero_unique_zeroFreeRegion` | classical zero-free region, Landau–Page uniqueness, simple zero, an elementary lower bound for L(1,χ) |
| Repulsion [84] | `one_sub_re_ge_of_exceptional_zero_repulsion` | Deuring–Heilbronn, by a power-sum argument with a Fejér-kernel positivity lemma |
| Assembly | `psiAP_relative`, `pi_rel_of_psi_rel`, `linnik` | relative-error formula for ψ(u; M, b), then for π, then the least prime |

Every one of these statements is in Mathlib terms plus eleven small project definitions (zero sets,
multiplicity, the exceptional-zero predicate, `Li`).

## 4. Reading

**Lemma-by-lemma audit (four automated readers, reports in `reader-reports/`).** Each was given one part,
told the code was untrusted, and asked to judge every in-closure statement as true, unclear, false or
vacuous, to read the main proofs, and to flag unusual constructs. Nothing was compiled by them.

| Part | Files | Hand-written statements judged | False / vacuous / cannot tell | Verdict |
|---|---|---|---|---|
| Exceptional zero, zero-free region | 27, all read in full | 135 | 0 | sound |
| Zero-density / sum over zeros | 33, all but parts of two read in full | 146 | 0 | sound |
| Explicit formula | 24, 22 read in full | about 120 | 0 | sound |
| Repulsion and assembly | 18, all read in full | about 109 | 0 | sound |

Things the readers established that bear on "is this too good to be true":

- No constant is better than the literature's. Several are visibly worse: Brun–Titchmarsh with 48 (the truth
  is 2), the large sieve with 1/δ + 2πN, Turán's theorem with 16e² (literature 8e), the exceptional-zero gap
  c/(M² log M) (literature about 1/(√M log² M)), and the explicit formula's error with q³.
- Quantifier orders are right: absolute constants are chosen before the modulus and the height.
- Lean's junk values (division by zero, the pole of the principal character's L-function, sums over
  infinite sets) are guarded where they could matter.
- Readers re-derived by hand, among others: the zero-free-region constants in all three cases, the layer
  decomposition turning the density estimate into the zero-sum bound, the Fejér induction, and the lower
  bound for the main term when an exceptional zero is present.
- Flags were cosmetic only: file and namespace names unrelated to the content (the von Mangoldt function is
  called `abelian₂`; the Linnik proof lives under `AbelianVarietyTheory` and `ThetaCorrespondence`), wrapper
  theorems proved by `first | exact … | apply …`, an unused hypothesis, small lemmas proved twice.

**My own reading.**

- The five main intermediate statements and all definitions in `ZerosDisc.lean`: standard theorems, correctly
  quantified.
- The central proof `psiAP_relative` (lines 294–427 of `ChebyshevPsiProgressionRelativeError.lean`), in full.
  It sets V = log u, m = log M, L = 10m + √V, T = exp(8m + √V); applies the explicit formula and the zero-sum
  bound at that T; uses the zero-free region when there is no exceptional zero, and otherwise chooses the
  zero-free width from repulsion (`etaChoice`), bounds the main term from below by u·min(1, (1−β)L)/4
  (`mainLower`), and uses the gap 1−β ≥ c/(M² log M) so that the error terms stay below the main term. The
  hypotheses of each input are discharged explicitly and the final step is linear arithmetic. This matches
  the textbook argument.
- Scan of the 102 files: no `sorry`, `admit`, `axiom`, `native_decide`, custom tactic, macro, `elab`,
  `run_tac`, `open private`, `unsafe`, new inductive type, structure, class or instance. One `decide`, on
  `(Finset.range 1).filter (Nat.Coprime 1) = {0}`. The only compiler option is `maxHeartbeats 1000000`
  (28 times). No numeral of ten or more digits. Tactics used are the ordinary ones (`linarith` 1,142 times,
  `simp` 746, `positivity` 503, `ring` 352, `nlinarith` 267).

**Limits of the reading.** It is a reading of source text by me and by four instances of the same model,
not by a human specialist, and not a replay. Mathlib lemmas were taken to mean what their names say. A
reader can miss an error; what the reading does show is that every statement in the chain is one a number
theorist would recognise as true, and that the chain is the known proof.

## 5. Machine re-check

Requested from a separate session in an environment that can install Lean: build the 517 modules with Lean
4.33.1, print the axioms, prove a Mathlib-only restatement, export it, check the export with the independent
kernel `nanoda_bin` from Lean 4.36.0, and confirm that the kernel rejects deliberately corrupted copies.

**Not yet reported.** This section will be filled in when it is.
