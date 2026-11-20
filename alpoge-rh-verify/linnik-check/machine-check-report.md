<!-- Condensed from the report of the separate session that ran the machine check (a Claude session in a 4-core, 15 GB cloud container). Its full log stayed in that container. -->

# Machine check of `UpperTheory.Lit.linnik`: log

Run 2026-11-20 22:31–23:25 UTC. Factual log; no opinion on the mathematics. Nothing pushed anywhere.

## Inputs
- Archive from alpo.ge: 239,275,554 bytes, SHA-256 `9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc` (matches). Listing: 175,190 regular files under `lean/`, no links, no absolute or `..` paths.
- Lean 4.33.1 (commit `819816b2e0a3bf405af45ae5c7af2491d8f5bee6`) from `lean-4.33.1-linux.tar.zst`, 570,405,234 bytes, SHA-256 `890afd185370f85666025b883914ab4f4b339136f8c96167b69cfb62aecaf235`.
- Lean 4.36.0 (commit `611c117bfaf7b7ae1cfcf246ce6fba31e8f509e9`) from `lean-4.36.0-linux.tar.zst`, 607,649,028 bytes, SHA-256 `2b7ab1ed8b92d2e6abfaf41344823b510064dbc9c0260cac73eb496ab2dea6eb`.
- Mathlib `0df444a3…` via `lake exe cache get` (8,690 files, exit 0, 1:33).
- elan was not installed (running its installer was blocked by that session's permission layer); both toolchains were used directly through `PATH`.

## Build
`lake build Development.AutomorphicArithmetic.ThetaCorrespondence.Linnik` under `/usr/bin/time -v`: exit 0, wall 18:43, peak RSS 8.19 GB, 9,222 jobs. 517 project modules: 0 with errors, 196 with warnings, 321 clean (same from the build log and the `.trace` files). No message mentions `sorry`. Warning kinds (1,502 lines): unused variable 276; "this tactic is never executed" 272; unused-tactic linter about 260; "Try this" 230; unused section variables 199; unused simp argument 102; deprecations 127.

## Check file (outside the tree)
`lake env lean --tstack=400000 --root=<dir> -o LinnikCheck.olean LinnikCheck.lean`: exit 0, 5.5 s, 7.36 GB. Output:

```
'UpperTheory.Lit.linnik' depends on axioms: [propext, Classical.choice, Quot.sound]
def GlobalTheory.Published.Linnik : Prop :=
∃ C L,
  0 < C ∧ 0 < L ∧ ∀ (a q : ℕ), 1 ≤ a → 1 ≤ q → a.Coprime q → ↑(GlobalTheory.Published.leastPrimeMod a q) ≤ C * ↑q ^ L
def GlobalTheory.Published.leastPrimeMod : ℕ → ℕ → ℕ :=
fun a q => sInf (GlobalTheory.Published.primesInProgression a q)
def GlobalTheory.Published.primesInProgression : ℕ → ℕ → Set ℕ :=
fun a q => {p | Nat.Prime p ∧ p ≡ a [MOD q]}
GlobalTheory.T.primesInProgressions_relativeError : GlobalTheory.Lin.PrimesRel
'GlobalTheory.T.primesInProgressions_relativeError' depends on axioms: [propext, Classical.choice, Quot.sound]
'linnik_plain' depends on axioms: [propext, Classical.choice, Quot.sound]
```

`linnik_plain` was given exactly as `GlobalTheory.Published.linnik_iff_exists_prime.1 UpperTheory.Lit.linnik` and elaborated unchanged.

## Export
`lean4export` v4.33.0 (`15f6055e`) built with Lean 4.33.1; `LEAN_PATH=$(lake env printenv LEAN_PATH):<dir> lean4export LinnikCheck -- linnik_plain <names>` (exit 0, 44 s, 7.9 GB). Extra names: Quot Quot.mk Quot.lift Quot.ind propext Quot.sound Classical.choice Nat Nat.zero Nat.succ Nat.add Nat.sub Nat.mul Nat.div Nat.mod Nat.gcd Nat.beq Nat.ble Nat.land Nat.lor Nat.xor Nat.shiftLeft Nat.shiftRight Nat.pow Nat.log2 String String.ofList Char Char.ofNat List String.mk (a first export without `String.mk` was refused by comparator for that reason and regenerated).

- 718,761,442 bytes, 13,358,843 lines, SHA-256 `80999437bcdcbdf144ad6ee77fc920d3bf91a3d5d7300c008a71559350226289`.
- Axioms declared: `propext`, `Quot.sound`, `Classical.choice`; all `isUnsafe=false`; nothing else. No non-safe definitions, no unsafe opaques.
- Records: theorem 62,987; definition 14,805; inductive 1,289; opaque 50; quot 4; expressions 12,760,599. 556 theorems under `GlobalTheory.*`.

## Kernels
- `nanoda_bin` 0.4.17 with config `{"export_file_path": …, "use_stdin": false, "permitted_axioms": ["propext","Classical.choice","Quot.sound"], "unpermitted_axiom_hard_error": true, "nat_extension": true, "string_extension": true, "pp_declars": ["linnik_plain"], "pp_to_stdout": true, "print_success_message": true}`: exit 0, "Checked 81832 declarations with no errors", 2:03, 761 MB. Its printout of the checked statement:
  `theorem linnik_plain : Exists (fun (C : Real) => Exists (fun (L : Real) => And (LT.lt (OfNat.ofNat 0) C) (And (LT.lt (OfNat.ofNat 0) L) (forall (a q : Nat), LE.le (OfNat.ofNat 1) a → LE.le (OfNat.ofNat 1) q → Nat.Coprime a q → Exists (fun (p : Nat) => And (Nat.Prime p) (And (Nat.ModEq q p a) (LE.le (Nat.cast p) (HMul.hMul C (HPow.hPow (Nat.cast q) L))))))))) := _`
- `lake comparator` (Lean 4.36.0; bubblewrap sandbox works there; no `--inadvisably-no-sandbox`). Challenge: a Mathlib-only file `theorem linnik_plain : <same statement> := sorry`, exported the same way (69,694,780 bytes). Config: theorem `linnik_plain`, permitted axioms the three standard ones. Exit 0 in 3:31: "Lean default kernel accepts the solution", "Your solution is okay!".
- `lake comparator --paranoid`: leanchecker-paranoid accepts; nanoda accepts; con-leche accepts ("accepted 79134 declarations (--verified)"); con-ron accepts (79,134, `--verified`); Lean default kernel accepts; lean4lean errors with `at Nat.mod: (kernel) unknown constant 'Decidable.intro'`, giving overall exit 1 (10:19). lean4lean fails identically after 2 s on the Mathlib-only challenge export; `Decidable.intro` does not exist in Lean 4.33.1. No usable lean4lean result.
- `lake env leanchecker Development.AutomorphicArithmetic.ThetaCorrespondence.Linnik` (4.33.1): exit 0, 1:02, 6.75 GB. The other 516 modules were not run individually.

## Negative controls
- A: `linnik_plain`'s type replaced by the type of `GlobalTheory.LogDerivZeros.main`, proof kept. nanoda: exit 101 (assertion `self.def_eq(u, v)` in `check_declar`). Comparator: exit 1, "Challenge and solution theorem statement do not match: 'linnik_plain'".
- B: the proof of `GlobalTheory.LogDerivZeros.norm_logDeriv_le` replaced by the proof of `GlobalTheory.LogDerivZeros.norm_one_sub_conj_mul`, type kept. nanoda: exit 101 (same assertion). Lean 4.36.0 `leanchecker --from-export`: exit 1 (type mismatch).
- The challenge export given as its own solution: comparator exit 1, "Illegal axiom detected: 'sorryAx'".

## Text scan of the 517-file import closure (90,571 lines; only external import is Mathlib)
Raw regex counts including comments: sorry 0, admit 0, axiom 0, native_decide 0, kcopy 0, kexactB 0, run_tac 0, run_cmd 0, macro 0, macro_rules 0, elab 0, elab_rules 0, syntax 0, unsafe 0, implemented_by 0, extern 0, csimp 0, opaque 0, initialize 0, #eval 0, reduceBool/trustCompiler 0; decide 58 (25 files); notation/infix 1; open private 2 (both in `Formalism/GL3MeanSquares/HookFormulaTorsion/GlobalBoundRefinements.lean`); instance 181 (26 files); inductive 2; structure 146 (56 files); class 1; theorem/lemma 3,402; def/abbrev 3,870. `set_option`: maxHeartbeats 1000000 ×33, synthInstance.maxHeartbeats 400000 ×17, maxHeartbeats 800000 ×5, maxHeartbeats 4000000 ×1, three linter options ×1 each.

## Passed / failed / not run
- Passed: archive hash and listing; build of the single target; axioms; `linnik_plain`; export declares only the three axioms; accept by nanoda, Lean 4.36.0 kernel with statement match, leanchecker-paranoid, con-leche, con-ron; leanchecker 4.33.1 on the Linnik module; both negative controls rejected.
- Failed: `lake comparator --paranoid` overall exit 1, solely from lean4lean's version mismatch.
- Not run: elan install; lean4lean result; `leanchecker` on the other 516 modules individually; `Main`.
