# Dependency analysis of the kernel export of the alpo.ge Lean code

Date: 2026-11-20. Companion to `REPORT.md`.

This describes the *structure* of the formal proof: which declarations the five theorems of `Main.lean`
depend on, how much of the published source that is, and how the dependencies are organised. It is a
structural description of a file. It makes no statement about whether the mathematics is right, and it
does not say the Riemann Hypothesis is proved.

## 1. What was analysed

- **Input:** the kernel export published by Andrew Sutherland at `https://math.mit.edu/~drew/grh/`
  (`solution.ndjson.zst`), made with `lean4export` (format 3.1.0) from his full build of the alpo.ge sources.
  This log did not produce the export: the full build here was stopped at 26% (see `REPORT.md`, section 4).
- **Checksums verified here** after download and decompression on the pod:
  - compressed: 7,699,933,588 bytes, SHA-256 `61a8938ad5f5e57397c1c0e3b954916af546d9004ade01c3555744a681b05381`
  - unpacked: 61,570,595,788 bytes, SHA-256 `5ea74b912147c5c93cc2b6d70cc727cf908df2f62ac6a20480a3fa02f6be244e`

  Both equal the values in his `SHA256SUMS`. This is the file that he reports `nanoda_bin` accepted.
- **What is not verified here:** that this export was generated from the published sources. That is his
  report. Indirect consistency: 802,314 declaration names written in the source appear in the export
  (section 4), and the statement definitions match the Mathlib-only challenge export reproduced here
  (`REPORT.md`, section 6).
- **Method.** `scripts/depgraph.cpp` reads the export once (90 s, 19 GB RAM), loads all expression nodes,
  and for each declaration walks its type and value to collect the constants it refers to. That gives an
  exact declaration-to-declaration graph. `scripts/domtree.cpp` computes the dominator tree and closure
  sizes. `scripts/analyze.py`, `dom.py`, `blocks.py`, `usage-refine.py` produce the tables in
  `dependency-data/`.
- Run as an unprivileged user that never compiled the submission. The export is data; nothing in it was
  executed.

A point about wording used below. "In the closure" means the declaration is *referenced*, directly or
through other declarations, by one of the five theorems. Lean's kernel needs every such declaration to
check the proof. It does not mean the declaration is mathematically essential: a lemma can be referenced and
still be avoidable.

## 2. The export in numbers

| | |
|---|---|
| Lines | 1,080,769,508 |
| Expression nodes | 1,065,214,335 |
| Names | 14,065,151 |
| Declarations (an inductive type with its constructors and recursor counted once) | 1,468,418 |
| Constant names | 1,484,733 |
| Dependency edges between declarations | 114,115,002 |
| Theorems / definitions / inductive blocks / opaque / quotient primitives | 1,246,110 / 214,241 / 7,969 / 91 / 4 |
| **Axioms** | **3: `propext`, `Classical.choice`, `Quot.sound`** |

- Every declaration in the file is reachable from the five theorems, except four built-ins that the exporter
  always adds (`Nat.lor`, `Nat.xor`, `String.mk`, `String.mk._proof_1`). File order is a topological order
  (no declaration refers to a later one). No reference is left unresolved.
- **Library versus project.** 209,514 declarations are constants of `import Mathlib` at the pinned commit
  (Mathlib, Batteries, Lean core and so on, identified by name against a clean Mathlib-only environment).
  The other **1,258,904 declarations (1,270,184 constant names) are the project's**: 1,075,031 theorems,
  178,305 definitions, 5,568 inductive blocks. No project declaration is an axiom or `opaque`.
- Sutherland's audit log gives 2,701,132 constants for the whole built environment. A Mathlib-only
  environment at the same commit has 771,129. So roughly 1.93 million constants belong to the project
  (including auto-generated ones), and about two thirds of them are in the closure.

## 3. The statements depend only on Mathlib

A second graph was extracted in which a theorem contributes only its *statement* (its type), not its proof.
In that graph the five theorems reach the following project declarations and nothing else:

| Theorem | Project declarations its statement depends on |
|---|---|
| `riemannHypothesis` | none (the statement is Mathlib's `RiemannHypothesis`) |
| `riemannZeta_eq_zero_re` | `RiemannZetaZerosOnLine` and its auto-generated `_proof_1` |
| `LFunction_ne_zero_of_half_lt_re` | `DirichletLNonvanishingRightOfHalf`, same `_proof_1` |
| `LFunction_eq_zero_re` | `DirichletLZerosOnLine`, same `_proof_1` |
| `LFunction_eq_zero_re_of_isPrimitive` | `PrimitiveDirichletLZerosOnLine`, same `_proof_1` |

Each statement reaches between 4,567 and 4,910 declarations in total, all of them library. So in this export
the five statements are written in Mathlib terms, with the four definitions of `Statements.lean` as the only
project content. None of the project's 178,305 definitions enters what is being claimed. This agrees with
the community's comparator result and was obtained here independently of it.

By contrast the intermediate statements are about project-defined objects. For example the statement of
`UpperTheory.FinalTheorems.everyCharacter_of_row` involves 1,507 project declarations.

## 4. How much of the published source is used

The source has 175,187 files, 17,374,215 lines, and 1,061,531 declarations found by a text scan
(`scripts/srcindex.py`).

| | In the closure | Total | Share |
|---|---|---|---|
| Declarations written in the source | 802,314 | 1,061,531 | 75.6% |
| of which theorems and lemmas | 647,869 | 818,755 | 79.1% |
| of which definitions | 136,264 | 212,819 | 64.0% |
| Files with at least one declaration in the closure | 146,232 | 175,187 | 83.5% |
| Lines in those files | 14,996,447 | 17,374,215 | 86.3% |

- **About a quarter of the written declarations (259,217) are not used by the final theorems.** 148,330 of
  them sit in 28,781 files that contribute nothing at all (2.38 million lines). The other 110,887 sit in files
  that are otherwise used. A further 174 unused files have no declarations (import-only files and the like).
- The unused files are small (median 44 lines) and spread widely. They are not one separate dead subtree.
  By directory, the largest amounts of unused text are:

  | Directory | Unused lines | of | Unused files | of |
  |---|---|---|---|---|
  | `Development/AbelianVarietyTheory/Proofs` | 1,192,612 | 7,436,698 | 18,301 | 95,418 |
  | `GroundTheory/HeightsAndTheta/Heights` | 146,159 | 626,821 | 1,558 | 6,348 |
  | `Development/AutomorphicSpectrum/Proofs` | 126,077 | 1,163,468 | 1,468 | 14,864 |
  | `Development/AbelianVarietyTheory/Definitions` | 92,223 | 508,569 | 476 | 2,198 |
  | `Formalism/PeriodIntegrals/UnitaryGroupMassFormula` | 80,399 | 430,489 | 812 | 3,615 |
  | `Development/AutomorphicArithmetic/AutomorphicVarieties` | 64,497 | 848,614 | 643 | 7,959 |
  | `Development/AbelianVarietyTheory/BlockTheory` | 45,093 | 104,027 | 327 | 753 |
  | `GroundTheory/PAdicHodge` | 38,757 | 64,317 | 129 | 226 |
  | `Development/AutomorphicArithmetic/DivisorFrames` | 34,987 | 44,504 | 301 | 383 |

- Areas that are mostly unused: `ReciprocityTheory/Chebotarev` (2 of 47 files used),
  `Formalism/WachLatticeTwists` (105 of 262), `GroundTheory/PAdicHodge` (97 of 226), `GroundTheory/Brauer`
  (7 of 20), `Formalism/SubspaceCounting` (12 of 32). Several small directories are entirely unused, for
  example `Formalism/WachLatticeTwists/HodgeTateChains` (28 files) and `CompanionTheory/RealGroups/BaseChange`
  (18 files). Full lists: `dependency-data/dir-usage-depth{1,2,3}.tsv`, `file-usage.tsv.gz`.
- **The structures Junyan Xu pointed out are confirmed dead:** `GlobalTheory.Fc.S0.GeneralHyps`,
  `GeneralHypU` and `GeneralHypV` are not in the closure.
- Of 1,577 names under `GlobalTheory.Published` in the source, 804 are in the closure and 773 are not
  (`dependency-data/published-used.txt`, `published-unused.txt`).

Limits of these counts. Attribution to files is by name. 8,725 project declarations (0.7%), mostly
auto-named instances, could not be attributed, so the count of unused files may be slightly too high.
Anonymous instances cannot be matched by name, so the "declarations written in the source" share is
slightly too low.

## 5. Shape of the proof: the dominator tree

A declaration D *dominates* E when every dependency path from the five theorems to E passes through D.
"Owns" below means the number of project declarations dominated. Those are the declarations that exist in
the closure only because of D. "Closure" is everything D reaches, shared or not.

### The top

```
riemannHypothesis  :=  rhOfAll  :=  Formalism.VW.rh_of_every allChi
allChi : UpperTheory.EveryCharacter  :=  UpperTheory.FinalTheorems.everyCharacter
```

- `Formalism.VW.rh_of_every` (from "every character" to `RiemannHypothesis`) has a closure of **6 project
  declarations**. The rest of that step is Mathlib. The definition `UpperTheory.EveryCharacter` involves 2
  project declarations and 4,800 library ones.
- **Everything else, 1,258,872 of the 1,258,904 project declarations, sits under the single theorem
  `UpperTheory.FinalTheorems.everyCharacter`.** All five theorems go through it.

### Under `everyCharacter`

`everyCharacter` applies `everyCharacter_of_row` to three inputs that the source calls literature
statements and proves inside the repository.

| Block (dominating theorem) | Owns | Share | Closure |
|---|---|---|---|
| `everyCharacter_of_row` | 956,863 | 76.0% | 1,169,085 |
| — `LiteratureTheorems.every_character_of_literature_of_vWin` | 836,572 | 66.5% | 1,053,702 |
| — — `Lit.every_character_of_theta_integrals_local_matching` | 537,861 | 42.7% | |
| — — — `Lit.nonempty_hyps_definite_side_of_closed_bound` | 447,188 | 35.5% | |
| — — `SelfIntersectionVolumeEstimates.topCovolSlim2_use_alt_alt` | 79,481 | 6.3% | |
| — — `Top.every_character_of_green_v_win` | 23,314 | 1.9% | |
| — — `LiteratureTheorems.theta_integrals_agree_and_local_matching_of_literature` | 14,111 | 1.1% | 60,549 |
| — `One.vwin_of_row` | 89,838 | 7.1% | 275,450 |
| `Gal.Int.galoisLocalGlobalStrong_recParameter` | 89,788 | 7.1% | 302,008 |
| — `Gal.Int.Geo.geometric_realization_of_weight_one` | 74,246 | 5.9% | |
| `Zero.LLC.recTExists` | 581 | 0.05% | 20,867 |
| Shared: used by more than one of the above (110,898 separate subtrees) | 212,220 | 16.9% | |

Reading this table:

- The proof is **not** a thin chain with a large amount of unrelated material hanging off it. Two thirds of
  the project declarations are used only through one theorem
  (`every_character_of_literature_of_vWin`), and inside it the largest single piece (43%) is the block named
  for theta integrals and local matching.
- The other two named inputs, an "automorphy window" block (`vwin_of_row`) and a Galois-representation
  block (`galoisLocalGlobalStrong_recParameter`), each own about 7% and each reach about a quarter of the
  project.
- The dominator tree is up to 49 levels deep. The longest dependency chain has 449 declarations, 195 of them
  project declarations.
- Smaller self-contained blocks under `every_character_of_literature_of_vWin` include: toroidal
  compactification (`GlobalTheory.TorKSField.toroidalForFanKS`, owns 7,166), the resolution-of-singularities
  algorithm (`FunctorialResolution.EmbeddedResolution.canonicalAlgorithmRules_isCorrect`, 5,322), Siegel
  toroidal charts (5,433), an arithmetic Hilbert–Samuel chain (5,445) and semi-abelian uniformisation
  (4,933). The full tree is in `dependency-data/dom-report.txt`, and the 400 largest owners in `owners.tsv`.

### Which source directory serves which block

Percent of each directory's closure declarations by block. A1 = theta/local-matching block, A2 = volume
estimates, A = rest of `every_character_of_literature_of_vWin`, B = `vwin_of_row`, C = rest of
`everyCharacter_of_row`, D = Galois-representation block, E = shared.

| Directory | Declarations in closure | A1 | A2 | A | B | C | D | E |
|---|---|---|---|---|---|---|---|---|
| `Development/AbelianVarietyTheory` | 518,072 | 48 | 4 | 21 | 3 | 1 | 6 | 17 |
| `Development/AutomorphicArithmetic` | 126,553 | 11 | 1 | 1 | 53 | 0 | 21 | 13 |
| `Formalism/LocalToGlobal` | 84,680 | 85 | 0 | 12 | 0 | 1 | 0 | 1 |
| `Development/AutomorphicSpectrum` | 81,967 | 4 | 34 | 11 | 1 | 7 | 10 | 33 |
| `Development/WeilBound` | 79,604 | 4 | 16 | 23 | 0 | 2 | 11 | 43 |
| `Formalism/SharpRestriction` | 62,579 | 91 | 0 | 6 | 1 | 1 | 0 | 1 |
| `Formalism/HermitianCurvature` | 46,896 | 99 | 0 | 1 | 0 | 0 | 0 | 0 |
| `Formalism/PeriodIntegrals` | 38,641 | 89 | 0 | 6 | 0 | 2 | 0 | 2 |
| `ReciprocityTheory/ReductiveGroups` | 36,259 | 43 | 3 | 44 | 0 | 1 | 0 | 10 |
| `GroundTheory/HeightsAndTheta` | 33,777 | 0 | 37 | 58 | 0 | 0 | 0 | 5 |
| `Development/EtaleCohomology` | 13,655 | 0 | 0 | 0 | 1 | 0 | 99 | 0 |
| `GroundTheory/AutomorphicForms` | 12,894 | 0 | 0 | 0 | 6 | 0 | 0 | 94 |
| `Development/ResolutionOfSingularities` | 10,191 | 0 | 0 | 96 | 0 | 0 | 0 | 4 |
| `GroundTheory/ProfiniteCohomology` | 10,036 | 0 | 0 | 0 | 0 | 69 | 0 | 31 |

Directory names do not predict the block. `Formalism/*` is almost entirely the theta block, `EtaleCohomology`
is entirely the Galois block, and the directory called `WeilBound` is mostly shared foundations.
Full table: `dependency-data/dir-by-block.tsv`.

## 6. The "literature" statements

The source collects statements of published theorems as constants `GlobalTheory.Published.X` and proves each
inside the repository as `X_of_literature`. `Main` depends on no axioms, so none of these is assumed.

- 396 top-level `GlobalTheory.Published.*` constants are in the closure (273 definitions, 122 theorems,
  1 inductive type).
- For 212 of them, some theorem in the closure has exactly that constant as its statement.
- The proofs differ a great deal in size. Each `_of_literature` theorem takes an argument of type
  `OpenLiteratureStatements`, and that type alone pulls in 2,285 project declarations. The second column
  leaves those out, so it is closer to the size of the proof itself (it also leaves out any foundations the
  proof happens to share with that type). Counts are project declarations; Mathlib is not counted.

  | Theorem | Closure | Without the hypothesis argument |
  |---|---|---|
  | `toroidal_compactification_of_literature` | 79,621 | 77,336 |
  | `siegel_toroidal_integral_of_literature` | 77,583 | 75,298 |
  | `base_change_definite_unitary_group_of_literature` | 66,372 | 64,087 |
  | `rallis_inner_product_convergent_of_literature` | 41,045 | 38,760 |
  | `siegel_weil_unitary_convergent_of_literature` | 37,138 | 34,853 |
  | `grothendieck_messing_of_literature` | 24,507 | 22,222 |
  | `kawamata_viehweg_of_literature` | 19,403 | 17,118 |
  | `nadel_vanishing_and_non_klt_divisor_of_literature` | 19,290 | 17,005 |
  | `local_langlands_gl_recT_exists_of_literature` | 18,976 | 16,691 |
  | `resolution_char_zero_of_literature` | 12,472 | 10,187 |
  | `global_artin_reciprocity_of_literature` | 8,240 | 5,955 |
  | `bhatt_scholze_integral_of_literature` | 7,290 | 5,005 |
  | `prismatic_dieudonne_hodge_of_literature` | 6,339 | 4,054 |
  | `clozel_purity_of_literature` | 6,060 | 3,775 |
  | `linnik_of_literature` | 2,975 | 690 |
  | `cheb_of_literature` | 2,574 | 289 |
  | `stone_von_neumann_of_literature` | 2,376 | 91 |

  All 176 are in `dependency-data/literature-closures.tsv`. The median without the hypothesis argument is
  about 6,000 declarations.

- **Most of these statements are about objects defined in the repository.** Number of project declarations a
  `Published` statement depends on (its own definitional content): none for 21 statements, 1–9 for 60,
  10–99 for 160, 100–999 for 130, and 1,000 or more for 25 (up to 2,088 for
  `RallisInnerProductConvergent`). Table: `dependency-data/published-statements.tsv`.

  Consequence: the *name* of such a statement tells you what it is meant to say. What it actually says
  depends on up to two thousand project definitions. The kernel check does not cover whether those match
  the literature. That does not affect the five final theorems, whose statements use Mathlib only
  (section 3). It does matter for anyone who wants to reuse an intermediate result or to read the proof as
  mathematics.

- **A few are stated in Mathlib terms only and can be read directly.** Examples, from the source:

  ```lean
  def Linnik : Prop :=
    ∃ C L : ℝ, 0 < C ∧ 0 < L ∧ ∀ a q : ℕ, 1 ≤ a → 1 ≤ q → a.Coprime q →
      (leastPrimeMod a q : ℝ) ≤ C * (q : ℝ) ^ L

  def ChevalleyUnits : Prop :=
    ∀ (E : Type) [Field E] [NumberField E] (m b : ℕ), 0 < m → 0 < b →
      ∃ a : ℕ, 0 < a ∧ a.Coprime b ∧ ∀ u : (𝓞 E)ˣ, (a : 𝓞 E) ∣ (u : 𝓞 E) - 1 → ∃ v : (𝓞 E)ˣ, u = v ^ m
  ```

  (`leastPrimeMod a q` is the infimum of the primes congruent to `a` mod `q`.) The in-repo proof
  `UpperTheory.Lit.linnik` has a closure of 689 project declarations (645 theorems, about 2.2 million
  expression nodes) plus 78,444 library declarations. It goes through a prime-counting statement for
  arithmetic progressions with an exceptional-character term (`GlobalTheory.Lin.PrimesRel`).
  These self-contained cases are the cheapest places for a specialist to compare a formal statement and its
  proof with the published theorem.

- The structure `UpperTheory.LiteratureTheorems.OpenLiteratureStatements` (three fields) is in the closure
  and is referenced directly by 199 declarations. `MainConclusion.lean` constructs it from in-repo theorems,
  as described in `REPORT.md`.

## 7. Library usage

- 209,514 library declarations are in the closure: Mathlib 199,979, Lean core (`Init`) 9,284, Batteries 238,
  others 13.
- **5,081 of Mathlib's 8,173 modules** contribute at least one declaration.
- By Mathlib area: Algebra 39,935; RingTheory 23,925; Analysis 21,383; CategoryTheory 18,957; Topology
  18,427; Data 16,045; Order 10,137; LinearAlgebra 9,872; MeasureTheory 8,866; NumberTheory 7,444;
  AlgebraicGeometry 6,665; GroupTheory 5,063; FieldTheory 3,243; RepresentationTheory 1,965; Geometry 1,377.
- Finer: `Mathlib.Algebra.Homology` 4,846; `CategoryTheory.Sites` 2,020; `NumberTheory.NumberField` 2,008;
  `Analysis.CStarAlgebra` 1,433; `NumberTheory.ModularForms` 1,229; `AlgebraicGeometry.EllipticCurve` 1,062;
  `NumberTheory.Padics` 941; `NumberTheory.LSeries` 741.
- Per-module counts: `dependency-data/library-modules-used.tsv`.

## 8. Other structural facts

- **Hubs.** The most referenced project declarations are small data structures:
  `Formalism.BasicNotions.D7` is referenced directly by 155,523 declarations, `D7.R` by 149,166,
  `Formalism.HC.HostRaw.instField` by 118,002.
- **Largest proof terms** (distinct expression nodes): `GlobalTheory.HeightCounting.SideCopy.LamCopy.lam_copy`
  5.5 million, `…SideCopy.sigSpan_copy` 4.6 million, `GlobalTheory.TwistChoice.goodTw_transfer` 2.5 million.
  Several of the largest have "copy" or "transfer" in the name.
- The sum over project declarations of distinct expression nodes is 2.50 billion; for library
  declarations it is 82 million. (The file has 1.07 billion nodes; sub-terms are shared between
  declarations.)
- Shortest-path distance from `riemannHypothesis`: most project declarations are 12 to 25 steps away, the
  farthest 52.

## 9. What this does and does not show

Shows, for this export:

- Three axioms, the standard ones. No project axiom or `opaque`.
- The five statements involve no project definition beyond `Statements.lean`.
- About three quarters of the written declarations and five sixths of the files are referenced by the final
  theorems. About a quarter of the declarations and 2.4 million lines are not.
- The proof funnels through one theorem and splits below it into a few large blocks and many shared
  foundations. The named "literature" results are proved in the repository, not assumed.

Does not show:

- That the export corresponds to the published sources (others' report), or that the kernel accepts it
  (others' report; not re-run here).
- That any intermediate statement says what its name suggests.
- That a referenced declaration is needed mathematically, or that an unreferenced one is wrong.
- Anything about the mathematical argument.

## 10. Reproducing

```
curl -O https://math.mit.edu/~drew/grh/solution.ndjson.zst && zstd -d --long=30 solution.ndjson.zst
g++ -O2 -std=c++17 -o depgraph scripts/depgraph.cpp
g++ -O2 -std=c++17 -pthread -o domtree scripts/domtree.cpp
./depgraph solution.ndjson full            # 90 s, 19 GB RAM
./depgraph solution.ndjson stmt stmt       # statements only
python3 scripts/srcindex.py                # index of declarations in the source tree
lake env lean scripts/modules.lean         # in a Mathlib-only project at the pinned commit
python3 -I scripts/analyze.py full <dir with the index files> full-out
python3 -I scripts/dom.py prep full full-out && ./domtree dom full full-out full-out/targets.ids
python3 -I scripts/dom.py report full full-out
python3 -I scripts/blocks.py <dir> out2 && python3 -I scripts/usage-refine.py <dir>
```

Paths inside the scripts are those of the pod they ran on and need adjusting.

## Files in `dependency-data/`

| File | Content |
|---|---|
| `report.txt` | main output: counts, closures, per-directory usage, library areas |
| `dom-report.txt` | dominator tree, largest owners, closure sizes of all `_of_literature` theorems |
| `blocks-report.txt`, `dir-by-block.tsv` | blocks and the directory-by-block table |
| `owners.tsv` | the 400 declarations that own the most |
| `dir-usage-depth{1,2,3}.tsv`, `file-usage.tsv.gz` | used and unused files, lines and declarations |
| `usage-refine.txt` | refined declaration counts by kind |
| `published-statements.tsv`, `published-used.txt`, `published-unused.txt` | the `GlobalTheory.Published` statements |
| `literature-closures.tsv` | closure size of each `_of_literature` theorem |
| `library-modules-used.tsv` | library modules with the number of declarations used from each |
