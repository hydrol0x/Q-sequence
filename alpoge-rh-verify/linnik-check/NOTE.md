# Check of the in-repo proof of Linnik's theorem

Date: 2026-11-20. Part of the log in `../REPORT.md` and `../DEPENDENCY-ANALYSIS.md`.

**Why this piece.** It is one of the few intermediate results of the alpo.ge Lean code that is stated purely
in Mathlib terms, it is a famous theorem whose truth is not in doubt, and its proof is small (689 project
declarations), so it can be read. It is a spot check of whether the code does recognisable mathematics.
It says nothing direct about the main theorem.

**Status.** Done: reading (sections 1–4) and machine re-check (section 5). Both came out clean.

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

## 5. Machine re-check: PASS

Run 2026-11-20 22:31–23:25 UTC by a separate session in a 4-core, 15 GB container, from a fresh download of
the author's archive (SHA-256 `9631b4f0…c7fc`, matches). Its log is condensed in `machine-check-report.md`.

| Check | Result |
|---|---|
| `lake build …ThetaCorrespondence.Linnik` (Lean 4.33.1, Mathlib `0df444a3` from cache) | exit 0, 18:43, peak 8.2 GB; 517 project modules, 0 with errors, 196 with warnings |
| `#print axioms UpperTheory.Lit.linnik` | `[propext, Classical.choice, Quot.sound]` |
| Mathlib-only restatement `linnik_plain` (below), proved from the repo's theorem | elaborates unchanged; same three axioms |
| Export of `linnik_plain` (`lean4export` v4.33.0 built with 4.33.1) | 718,761,442 bytes, SHA-256 `80999437bcdcbdf144ad6ee77fc920d3bf91a3d5d7300c008a71559350226289`; declares exactly the three axioms |
| `nanoda_bin` 0.4.17 (independent Rust kernel, from Lean 4.36.0) | **accepts**, 81,832 declarations, 2:03, 761 MB |
| `lake comparator` (Lean 4.36.0, sandboxed) against a Mathlib-only challenge file stating `linnik_plain := sorry` | **exit 0**: statement matches, axioms permitted, Lean 4.36.0 kernel accepts |
| `lake comparator --paranoid` | `leanchecker-paranoid`, nanoda, con-leche (`--verified`), con-ron (`--verified`) and Lean's kernel all **accept**; lean4lean aborts on `unknown constant 'Decidable.intro'`, the known version mismatch (it fails the same way on a Mathlib-only export), so the overall exit code is 1 |
| `leanchecker` 4.33.1 on the Linnik module | exit 0 |
| Negative control A: statement of `linnik_plain` swapped for another proposition, proof kept | nanoda **rejects**; comparator **rejects** ("statement does not match") |
| Negative control B: proof of one lemma deep in the closure replaced by another theorem's proof | nanoda **rejects**; Lean 4.36.0 `leanchecker --from-export` **rejects** |
| Challenge export given as its own solution | comparator **rejects** ("Illegal axiom detected: 'sorryAx'") |

```lean
theorem linnik_plain : ∃ C L : ℝ, 0 < C ∧ 0 < L ∧ ∀ a q : ℕ, 1 ≤ a → 1 ≤ q → a.Coprime q →
    ∃ p : ℕ, p.Prime ∧ p ≡ a [MOD q] ∧ (p : ℝ) ≤ C * (q : ℝ) ^ L :=
  GlobalTheory.Published.linnik_iff_exists_prime.1 UpperTheory.Lit.linnik
```

So five kernels of four independent designs accept a proof of this statement, which mentions nothing but
Mathlib, and the same tools reject corrupted copies.

**Cross-check with the published export.** The record counts of this independently built export equal,
kind by kind, the closure of `UpperTheory.Lit.linnik` in the graph extracted from Sutherland's export:
1,289 inductive blocks, 50 opaque, 4 quotient primitives, 3 axioms, 556 theorems under `GlobalTheory`, and
theorems and definitions equal once `linnik_plain` and the four built-ins the exporter is asked to add
(`Nat.lor`, `Nat.xor`, `String.mk`, `String.mk._proof_1`) are accounted for (62,987 vs 62,985 + 2 theorems;
14,805 vs 14,802 + 3 definitions). For this part of the proof, his export and a build from the published
sources agree.

Deviations in the run: elan could not be installed there, so both official toolchain archives were unpacked
and used directly (versions and commits confirmed; SHA-256 of the 4.33.1 archive matches the earlier Tier A
run). The other 516 modules were not replayed one by one with `leanchecker`; the export-based checks cover
the whole closure.

Text scan of the full 517-file import closure (most of it not used by the Linnik proof): no `sorry`,
`admit`, `axiom`, `native_decide`, `macro`, `elab`, `syntax`, `unsafe`, `implemented_by`, `extern`,
`opaque`, `initialize` or `#eval`; `decide` 58 times; 2 `open private` (in an unrelated file).

## 6. Result

- The statement is Linnik's theorem in Mathlib terms.
- The proof is the classical one, every lemma statement in it was read and none found false, and its
  constants are no better than the literature's.
- It compiles from the published sources, depends on the three standard axioms, and its export is accepted
  by Lean's kernel (4.33.1 and 4.36.0), the hardened Lean checker, nanoda, con-leche and con-ron, which
  reject tampered copies.

What this does not show: anything about the other 1.26 million project declarations, beyond the fact that
in the one place where the output could be compared with known mathematics, it held up.
