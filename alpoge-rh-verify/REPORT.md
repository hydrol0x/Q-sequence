# Build/verification log: Lean code published at alpo.ge on 2026-11-20

**Status: FINAL for this log (2026-11-20). The full build was stopped on purpose at 26% (section 4), so this
log does not contain a first-hand full build, axiom check of `Main`, or kernel replay. Section 8 records what
other people have reported publicly; none of it is this log's own result. `DEPENDENCY-ANALYSIS.md` holds the
analysis of the published kernel export that replaced the rest of the build.**

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
- Repeated first-hand on the Tier B pod at 20:00 UTC, using the `.olean` files produced by the (partial) Tier B build:
  `lake env lean TierA.lean` exit 0 (9.69 s, peak RSS 6.8 GB) with output identical to the block above.
  `#check` output there: `Claim.strip : Claim.HalfPlane → Claim.Strip`, `Claim.zeta : Claim.HalfPlane → Claim.Zeta`,
  `Claim.zeta_iff : Claim.Zeta ↔ RiemannHypothesis`.

## 4. Tier B (full build): STOPPED AT 26%, NO ERRORS UP TO THAT POINT

- Command: `lake build Main 2>&1 | tee build.log`, under `/usr/bin/time -v`, started 2026-11-20T17:08:50Z,
  restarted once at 17:11:47Z (see section 7).
- **Stopped deliberately at 2026-11-20T20:56:21Z (SIGTERM, exit 143) on the user's decision.** By then other
  people had published complete builds and kernel checks (section 8), so finishing this one would only have
  repeated them; the remaining pod time went to the dependency analysis instead.
- State at the stop: **45,097 of 175,187 project modules compiled (25.7%)**, wall time 3:44:34 for the second
  run, 3126% CPU, 0 OOM kills (`memory.events`), container memory peak 75 GB (during the first 2.5 minutes of
  the first run), largest single process 17.1 GB RSS.
- Progress log (repo modules with an `.olean`, of 175,187):

  | UTC | modules | memory in use | disk |
  |---|---|---|---|
  | 17:27 | 3,014 | 38 GB | 19 GB |
  | 17:56 | 8,498 | 41 GB | 25 GB |
  | 19:05 | 22,548 | 53 GB | 34 GB |
  | 19:58 | 32,880 | 57 GB | 40 GB |
  | 20:47 | 43,168 | 60 GB | 45 GB |

  Rate over the last hour about 3.5 modules/s; at that rate the build would have ended around 07:20 UTC on
  2026-11-21.
- **Errors and warnings.** `build.log` stayed at 0 bytes, but that is because Lake's output to the pipe was
  never flushed before the stop, not because there was nothing to print. (Earlier interim versions of this log
  read the empty file as "no warnings"; that was wrong.) The per-module `.trace` files are the real record:
  45,080 traces read, **0 modules with an error, 25,569 modules with at least one warning**.
- **Comparison with an independent build.** Andrew Sutherland published SHA-256 values for all his compiled
  `.olean` files (`project-oleans.sha256`, section 8).
  - Sources and the statements module agree:
    `sha256(src/Main.lean) = 017645ca448f2fd1f6fd5c4c2cb2c6e96e472725be13f6e180ca6e1574360939`,
    `sha256(src/Statements.lean) = 79ef7ca776e42abe1f46caee13ea09bd19f1e2d0b1620d8d5d200258f33b47bf`,
    `sha256(Statements.olean) = f8e0aed3c2d69390b6dd3bb24e13aa25e043a02ca42f021e3f6e4ec8b57fd6b1`.
  - Of the 45,097 `.olean` files built here, **20,895 are byte-identical to his and 24,202 differ**.
    6,887 of the differing modules have all their in-repo imports identical, so the difference arises in
    those modules themselves and then propagates.
  - Three such modules were recompiled here with 32, 32, 1 and 8 threads; each time the output was
    byte-identical to this build's first output. So each build is deterministic and the difference is
    systematic. The cause was not established. One possibility, unconfirmed, is that his build invoked
    `lean` directly rather than through `lake build`.
  - Consequence: an export made from a Lake build like this one might not reproduce his export checksum
    bit for bit even though both come from the same sources.
- `Main.olean` was never produced here.

## 5. Axioms of the five theorems in `Main.lean`: NOT RUN HERE

`#print axioms` on `Main` needs the full build. Not run. What this log does have first-hand:

- Tier A (section 3): the reduction layer depends on `[propext, Classical.choice, Quot.sound]`.
- The kernel export published by Sutherland (61.57 GB, both checksums verified here, see
  `DEPENDENCY-ANALYSIS.md`) declares exactly three axioms: `propext`, `Classical.choice`, `Quot.sound`.
  That is a statement about that file. That the file corresponds to the published sources is his report,
  not something verified here.

## 6. Tier C (kernel replay): NOT RUN HERE

No kernel replay of the full project was run in this log. Others have run several (section 8).

What was prepared on the pod, by a separate unprivileged user (`judge`) that never compiled the submission:

- Toolchains installed with elan: Lean `v4.33.1` and Lean `v4.36.0`
  (commit `611c117bfaf7b7ae1cfcf246ce6fba31e8f509e9`). The 4.36.0 toolchain bundles `nanoda_bin`,
  `leanchecker-paranoid`, `con-leche`, `con-ron`, `lean4lean` and `lake comparator`.
- Clean clone of `Deicyde/riemann-hypothesis` at `e50d09817ad81469f737e8f637561e6ccf86c670`; `lake exe cache get`;
  `lake build Challenge` (the challenge file imports only Mathlib).
- `lean4export` at tag `v4.33.0` (`15f6055e299ad5b89345e533cc2192f4cc00f659`), built with Lean `v4.33.1`.
- Challenge export: 350,862,311 bytes, 6,495,712 lines, 32 s, peak RSS 6.8 GB,
  **SHA-256 `bd484ac9886a96f26b1d9a7a59ebd45b7a70d102c015d4f31f9302bbdd6ab2b9`, equal to the value published in the
  community mirror's README.** So the five statements being checked by the community are reproduced here
  from a clean Mathlib-only project.
- `bubblewrap` does not work in this container ("No permissions to create new namespace"), and
  `lake comparator` requires it, so the comparator could only have run here with `--inadvisably-no-sandbox`.

Earlier observations, kept for the record:

- `github.com/leanprover/lean4checker` is deprecated; its newest tag is `v4.29.0-rc8`, there is none for v4.33.1.
  The tool now ships in the toolchain as `leanchecker`.
- Measured on the build pod: `lake env leanchecker <module>` takes about 15–20 s and about 6.3 GB RSS per module
  (13 early `Formalism` modules and `Statements`: all exit 0). At that cost a replay of all 175,187 modules needs
  roughly 700+ core-hours.
- In the Tier A container: `leanchecker` on `Statements`, `HalfPlane`, `ClaimStrip`, `RhOfRight`, one module per
  process: all exit 0. (All four in one process was OOM-killed at 13 GB in that 15 GB container: a resource failure.)

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

## 8. What others have reported (not this log's results)

Source: the Lean Zulip thread "Discussion: Alpöge Proves the Riemann Hypothesis" as of 15:40 EST (20:40 UTC) on
2026-11-20, supplied by the user as a PDF, and the repository `Deicyde/riemann-hypothesis` at commit
`e50d0981` (read directly). These are other people's statements, recorded here because they bear on this log.

- **Builds.** Andrew Sutherland reports a successful build on 8 machines of 192 cores in just over an hour,
  with the same archive SHA-256 as section 1. Simon DeDeo reports that the code compiles on his machine with
  one recoverable segfault during the run. Several others report builds in progress.
- **Second kernel.** Sutherland reports that `nanoda_bin` (Lean 4.36.0) checked the full 61.57 GB export and
  exited 0: 27 min 42 s on 80 threads, peak memory 89 GB.
- **Comparator.** Sutherland reports that statement comparison and the axiom check passed in a
  `lake comparator --paranoid` run that used an earlier challenge export differing only in `sorry`
  placeholders; the run with the canonical challenge was still in progress.
- **con-leche / con-ron.** The mirror's notes say the versions bundled with Lean 4.36.0 decline the export
  because of a mutual reflexive inductive type (`…EmbeddedResolution.PrincipalizationCertificate`), which is a
  limitation of those checkers. Szymon Teżewski reports that a newer con-leche accepts, in 3 min 24 s on 64
  cores with 45 GB.
- **lean4lean.** Reported failing for a version reason (`unknown constant 'Decidable.intro'` when the 4.36
  build reads a 4.33 export); not a verdict on the proof.
- **Lean version.** The mirror's notes list which kernel soundness fixes Lean 4.33.1 includes and which later
  runtime fixes (4.34.1) it lacks, and conclude that a pass by the 4.33.1 kernel alone is limited evidence.
  That is why checks by Lean 4.36.0 and independent kernels matter.
- **Setup files.** The mirror's notes independently describe the per-module `.setup.json` problem (about 6 MB
  each, around a terabyte in total) and recommend deleting each file once its module is built, as done here.
- **Static scan.** The mirror's scan agrees with section 7: no `axiom`, `sorry`, `native_decide`,
  `implemented_by`, `unsafe`, `opaque`, `debug.*`. It counts `kexactB` used through macros in 67 files and
  33 uses of `run_tac`. It reports all notation as `local` or `scoped`, consistent with the one `scoped`
  notation found here.
- **Dead code.** Junyan Xu reports structures that are never inhabited (`GeneralHyps` and two relatives),
  suggesting more theory was developed than the proof uses. Checked here: each is a `Prop` structure whose
  fields are literature statements (177, 113 and more), none is referenced outside its own definition, and
  none is in the dependency closure of `Main` (`DEPENDENCY-ANALYSIS.md`, section 4). Andrii Kurdiumov reports that
  `CompanionTheory/EightfoldTheory` contains only `import` statements.
- **Module count.** 183,890 build jobs: 175,187 project modules plus 8,703 from dependencies.

- **Later status (read at about 21:00 UTC, fetched from the pod).** Sutherland's page
  `https://math.mit.edu/~drew/grh/` publishes the export, its checksums, his audit log and per-file `.olean`
  hashes. His `audit.log` shows `#print axioms` for the theorems of `Main` giving
  `[propext, Classical.choice, Quot.sound]`, and his `nanoda.log` shows exit status 0 after 27:42 with a peak
  of 88.9 GB. A public live build at `http://106.14.11.164/` (128 vCPU) showed 153,726 jobs done, 0 failed and
  384,140 warnings at 20:59 UTC, with its audit still pending.

## 9. Cost and clean-up

- Pod `m11vdyb9ph3zlx` was deployed at 2026-11-20T17:04:44Z and terminated at 21:42Z (4.6 hours). Account
  balance went from $48.98 to $40.74: **$8.24 spent**, against the approved cap of $40. No pods remain.
- The pod held no credentials of the user's. The untrusted code was compiled only by an unprivileged user
  with an empty environment, and the pod no longer exists.

## Files

- `DEPENDENCY-ANALYSIS.md` and `dependency-data/`: structure of the proof, from the published kernel export.
- `tierA-child-session-report.md`: verbatim Tier A log.
- `scripts/`: every script run on the build pod, plus `imports.py` (import-graph scan) and the
  dependency-analysis programs.
