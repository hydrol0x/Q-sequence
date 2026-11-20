# Build/verification log: Lean code published at alpo.ge on 2026-11-20

**Status: IN PROGRESS (interim, written 2026-11-20 ~17:30 UTC). Tier B is running; sections 4–6 are not final.**

This is a factual log of what was downloaded, compiled and checked, and under which axioms.
It makes no statement about the mathematics. Nothing here says the Riemann Hypothesis is proved.

## 1. Source and integrity

- Source used for every build result: the **author's original parts**, `https://alpo.ge/lean.tar.gz.part01` … `part14`,
  downloaded independently on two machines (the Tier B build pod and the Tier A container).
- Parts 01–13 are 18,000,000 bytes each, part 14 is 5,275,554 bytes. Per-part SHA-256 values are in
  `tierA-child-session-report.md`; the build pod got the same 14 values.
- Concatenated `lean.tar.gz`: **239,275,554 bytes, SHA-256 `9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc`**.
  This matches the size and hash stated in the mirror's README (that hash is the mirror's claim, not the author's).
- Mirror release tarball (`CocoSgt/riemann-hypothesis-lean`, tag `v2026-11-20`): same size, same SHA-256.
- Archive listing before extraction: 175,190 entries, all regular files (`-rw-r--r--`, owner 0/0), all under `lean/`;
  0 absolute paths, 0 `..` components, 0 symlinks/hardlinks.
  Contents: `lake-manifest.json`, `lakefile.toml`, `lean-toolchain`, and 175,187 files under `src/` (all `.lean`).
- Mirror clone at commit `7cbf7a0c32fca1badf05931879a37c3f8a2b03b4`. `diff -rq -x .git <author tree> <mirror>`:

  ```
  Only in mirror: .gitignore
  Only in mirror: README.md
  ```

  `src/`, `lakefile.toml`, `lean-toolchain`, `lake-manifest.json` are byte-identical.
- `find src -type f -print0 | LC_ALL=C sort -z | xargs -0 sha256sum | sha256sum` gives
  `5d2967ae86f7c55244c87da86cc0d2c046d3202e87234b05b954722b46cd627d` on the author's tree (computed on the build pod and
  in the Tier A container) and on the mirror checkout (computed in a third container).
- SHA-256: `lakefile.toml` `b831ad8c…ec4c`, `lean-toolchain` `3aac669c…db71`, `lake-manifest.json` `fee57ee9…4774`.
- 17,374,215 lines in the 175,187 `.lean` files.

## 2. Environment

| | Tier A | Tier B / C |
|---|---|---|
| Machine | cloud container, 4 vCPU (Intel Xeon @ 2.30GHz), 15 GB RAM | RunPod `cpu3m-32-256`, pod `m11vdyb9ph3zlx`, EU-RO-1: 32 vCPU of an AMD EPYC 9655 host, 256 GB RAM limit, 300 GB disk |
| OS | Ubuntu 24.04.5, kernel 6.18.44 | Debian 12 (image `python:3.12-bookworm`), kernel 6.8.0-147 |
| Lean | 4.33.1, commit `819816b2e0a3bf405af45ae5c7af2491d8f5bee6` | same (downloaded by elan 4.4.0 from `releases.lean-lang.org`) |
| Lake | 5.0.0-src+819816b | same |
| Mathlib | `0df444a360eaa60ab8c11dca51a86af692955474`, from `lake exe cache get` (8,690 files) | same |
| `lake-manifest.json` | unchanged after cache get | unchanged after cache get |
| Parallelism | Lake default | `LEAN_NUM_THREADS=32` (see section 7) |

Other package revisions on the build pod equal the manifest: Cli `6130a478`, LeanSearchClient `5f4d51b8`, Qq `92c15be1`,
aesop `3448c0bc`, batteries `4488d40d`, importGraph `16f02aa7`, plausible `b7eb3304`, proofwidgets `4be2e3d5`.

On the build pod everything that touches the untrusted code runs as an unprivileged user (`builder`) with a scrubbed
environment (`env -i`), because RunPod injects a pod-scoped `RUNPOD_API_KEY` into the container's root environment.

## 3. Tier A (statements and top reduction layer): PASS

Run in the 4-vCPU container on the author's tree. Full verbatim log: `tierA-child-session-report.md`.

- `lake build Statements`: exit 0, 12.45 s, peak RSS 6.8 GB.
- `lake build Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip`: exit 0, 12.82 s, peak RSS 7.0 GB, one style-linter warning (`haveI` vs `have`, `ClaimStrip.lean:66:4`).
- `lake build Formalism.GammaFactorNonvanishing.RhOfRight`: exit 0, 8.00 s, peak RSS 7.0 GB.
- `lake env lean TierA.lean` (file exactly as in the handoff): exit 0. Output:

```
def RiemannHypothesis : Prop :=
∀ (s : ℂ), riemannZeta s = 0 → (¬∃ n, s = -2 * (↑n + 1)) → s ≠ 1 → s.re = 1 / 2
def RiemannZetaZerosOnLine : Prop :=
∀ (s : ℂ), riemannZeta s = 0 → (¬∃ n, s = -2 * (↑n + 1)) → s ≠ 1 → s.re = 1 / 2
def DirichletLNonvanishingRightOfHalf : Prop :=
∀ (N : ℕ) [inst : NeZero N] (χ : DirichletCharacter ℂ N) (s : ℂ),
  1 / 2 < s.re → χ ≠ 1 ∨ s ≠ 1 → DirichletCharacter.LFunction χ s ≠ 0
def DirichletLZerosOnLine : Prop :=
∀ (N : ℕ) [inst : NeZero N] (χ : DirichletCharacter ℂ N) (s : ℂ),
  0 < s.re → s.re < 1 → DirichletCharacter.LFunction χ s = 0 → s.re = 1 / 2
def PrimitiveDirichletLZerosOnLine : Prop :=
∀ (N : ℕ) [inst : NeZero N] (χ : DirichletCharacter ℂ N),
  χ.IsPrimitive → ∀ (s : ℂ), 0 < s.re → s.re < 1 → DirichletCharacter.LFunction χ s = 0 → s.re = 1 / 2
'Claim.strip' depends on axioms: [propext, Classical.choice, Quot.sound]
'Claim.zeta' depends on axioms: [propext, Classical.choice, Quot.sound]
'Claim.zeta_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
```

- The three `example … := Iff.rfl` lines compiled with no output.
- `Formalism.VW.rh_of_right : (∀ (s : ℂ), 1 / 2 < s.re → s ≠ 1 → riemannZeta s ≠ 0) → RiemannHypothesis` depends on
  `[propext, Classical.choice, Quot.sound]`.
- `RiemannHypothesis` and `riemannZeta` are declared in `Mathlib.NumberTheory.LSeries.RiemannZeta`;
  `DirichletCharacter.LFunction` in `Mathlib.NumberTheory.LSeries.DirichletContinuation`.
- Tier A covers 4 of 175,187 files. These are conditional statements only; they say nothing about `Main`.

## 4. Tier B (full build): RUNNING

- Command: `lake build Main 2>&1 | tee build.log`, under `/usr/bin/time -v`, started 2026-11-20T17:08:50Z,
  restarted once at 17:11:47Z (see section 7).
- At 17:27:32Z: 3,014 of 175,187 repo modules built, 31 `lean` processes, 38 GB in use, `build.log` empty
  (no warnings or errors printed so far). Observed rate about 2.9 modules/s.
- Final result, wall time, peak RSS, job count, first error (if any): **pending**.

## 5. Axioms of the five theorems in `Main.lean`: PENDING (needs Tier B to finish)

## 6. Tier C (kernel replay): PENDING / will be partial

- `github.com/leanprover/lean4checker` is deprecated; its newest tag is `v4.29.0-rc8`, there is none for v4.33.1.
  The tool now ships in the toolchain as `leanchecker` (same v4.33.1 toolchain as the build); that is what is used.
- Measured on the build pod: `lake env leanchecker <module>` takes about 15–20 s and about 6.3 GB RSS per module
  (13 early `Formalism` modules and `Statements`: all exit 0). At that cost a replay of all 175,187 modules needs
  roughly 700+ core-hours, more than the budget for this run.
- In the Tier A container: `leanchecker` on `Statements`, `HalfPlane`, `ClaimStrip`, `RhOfRight`, one module per
  process: all exit 0. (All four in one process was OOM-killed at 13 GB in that 15 GB container: a resource failure.)
- `--fresh` (replaying Mathlib and everything else into an empty environment): not run so far.
- Second kernel (`nanoda_lib`, `lean4lean`): not attempted.

## 7. Surprising or noteworthy, stated factually

- **Disk:** Lake 5.0.0 writes a `.setup.json` per module under `.lake/build/ir/` listing every transitive import's
  artifacts. For modules importing `Mathlib` this is 5.1–5.4 MB each (8,690 entries) before counting in-repo imports.
  Across 175,187 modules that is on the order of 0.9 TB or more. The pod has 300 GB, so a janitor
  (`scripts/janitor.sh`) deletes a module's `.setup.json` once its `.olean` and `.trace` exist and the file is more than
  3 minutes old. These files are inputs to the `lean --setup` invocation, not build outputs. This is a deviation from
  a plain `lake build Main`.
- **Parallelism:** Lake has no `-j` flag and sized its pool from the host's 192 hardware threads rather than the pod's
  32 vCPUs. The first run (17:08:50Z–17:11:41Z, 2.5 minutes, peak 81 GB) was killed and restarted with
  `LEAN_NUM_THREADS=32`; already-built `.olean` files were kept.
- **Static text scan of all 175,187 files** (ripgrep, mirror checkout, byte-identical to the author's `src/`):
  0 hits for `sorry`, `admit`, `axiom`, `native_decide`, `ofReduceBool`, `reduceBool`, `trustCompiler`,
  `implemented_by`, `unsafe`, `opaque`, `skipKernelTC`, `debug.`, `IO.Process`, `IO.FS`, `readFile|writeFile`,
  `initialize`, `@[export`, `csimp`, `#eval`, `#exit`, `run_elab|run_meta`, `prelude`, `include_str`,
  `declare_syntax_cat`, top-level `syntax`.
  `extern` and `IO.`/`System.`/`Kernel.` hits are substrings of mathematical names (`ExternalProduct…`, a namespace
  called `IO`, `FormalGroupSystem.`, `.isKernel.`), except `Kernel.isDefEq` in `OwnStruct.lean`.
- **Metaprograms present:**
  - `Formalism/HermitianCurvature/HermitianCurvatureProofs/CutCptCopy.lean`: command `cpt_copy_thms` copies
    definitions and theorems under renamed names with `addDecl` (kernel-checked).
  - `Formalism/LocalToGlobal/NumberFieldFamilies/OwnStruct.lean`: tactic `kcopy` and command `#kcopy_probe`
    (the command was not mentioned in the handoff); uses `Kernel.isDefEq` and `g.assign`.
  - `Formalism/LocalToGlobal/IndefiniteReal/HeckeNonvanishing/Imports.lean`: tactic `kexactB` (`g.assign`).
  - `Development/AbelianVarietyTheory/Proofs/IwasawaDecomposition/ExistsGIs.lean:81`: an inline `run_tac` that
    assigns the goal from hypothesis `h`.
  - `Formalism/SharpRestriction/…/EvalFrameOrd.lean`: a `positivity` extension in `namespace Mathlib.Meta.Positivity`.
  - `BuildAid/D1–D5.lean`: `run_cmd Lean.modifyEnv … LibrarySuggestions.nameDenyListExt.addEntry`.
  - 87 `macro` lines in 64 files; the term-level ones (`kc%`, `kq%`, `kd%`, `cp`, `copyIsV%`, `copyDec%`, `TI`, `TF`)
    are `local` or `scoped`; the 21 unscoped ones are tactic macros.
- **Differences from the handoff's reading:** one notation is `scoped`, not `local`
  (`scoped infixl:70 " ⬝ " => HMul.hMul` in `namespace GlobalTheory.MixModel`,
  `Development/AbelianVarietyTheory/Definitions/TwistedInnerProducts/CovolOneIntegralAdd.lean:21`).
  `Main.lean` opens no namespace, but `Supplements/Kernels/MainTheorems.lean` has `open Complex DirichletCharacter`.
  There are declarations inside `namespace Std` (4 files), `namespace Real` (1), `namespace Complex` (1).
  Two in-repo `def LFunction` exist, in `GroundTheory.Automorphic.GodementJacquet` and `HeckeCharacter` namespaces.
- **Other counts:** 151 uses of `decide +kernel`; 220 `open private` lines; `set_option` appears 88,139 times in
  75,197 files (57,556 `maxHeartbeats`, 7,381 `synthInstance.maxHeartbeats`, 1,879
  `backward.isDefEq.respectTransparency`, 37 `allowUnsafeReducibility`, 1 `Elab.async`, no `debug.*`).
- **Import graph** (text scan of `import` lines): `Main`'s in-repo closure is all 175,187 modules.
  `Statements` 1, `ClaimStrip` 2, `RhOfRight` 1, `CritLine` 14,301 (2,553,287 lines), `MainConclusion` 175,174.
  Imports from outside the repo are `Mathlib…`, `Lean…` and `Batteries.Tactic.OpenPrivate` only.
- Not checked: network or filesystem access during builds (no syscall tracing), build determinism.

## Files

- `tierA-child-session-report.md`: verbatim Tier A log.
- `scripts/`: every script run on the build pod, plus `imports.py` (import-graph scan).
