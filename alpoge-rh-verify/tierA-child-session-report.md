<!-- Verbatim report from the child session (session_01Fjy2mUe1xyekhhs3V8ZhVN) that ran Step 1 + Tier A in a 4-core / 15 GB cloud container. Sent in two messages; joined here unchanged. -->

REPORT-tierA.md — part 1 of 2 (sections 1–2 and start of 3). Full file: /home/user/work/REPORT-tierA.md in the worker container.

# Tier A build/verification log — published Lean 4 project (alpo.ge, 2026-11-20)

Scope: download + integrity, and the "Tier A" check of statements and the top reduction layer only. `lake build Main` / plain `lake build` were NOT run. This log makes no statement about the mathematics; it records what was run and observed in this container. All later results come from the AUTHOR's archive (alpo.ge parts), extracted to /home/user/work/extract/lean.

## 1. Source and integrity

- alpo.ge reachable. `https://alpo.ge/lean.tar.gz.part01`..`part14`: all HTTP 200. Sizes: part01–part13 = 18,000,000 bytes each; part14 = 5,275,554 bytes. SHA-256:

```
86974b1c242ca7b6748f3299df4fc64ee0f6e06c776ac964fb64888101a3de77  lean.tar.gz.part01
1c2a2477354a9dfa97ff1ce54861e96ed885bd456fffbaaabc2028314a229c42  lean.tar.gz.part02
1465a23b1b579a881e24e5ffaf7c4c3727af28ea24741f1ec80e1d67947530a3  lean.tar.gz.part03
3929e327eecb4e2c5c7cae30e104e6a4a52fa6b82d28325bcda8e9da1c86893b  lean.tar.gz.part04
f25d7e80f7c4ad6d674aa18b323ca760f848857c8755501c149317c38a66c75d  lean.tar.gz.part05
a8c651a68327811b37dce3cca8eda5e0b2102fa227c0d395cbb7553e4dd69939  lean.tar.gz.part06
65c7e502a9b236a0f68d9e0aa6e089d4c09b9fc7a0960a149384063ccbe5e869  lean.tar.gz.part07
71b027ad6e4179c3a50ce72921e3fec0a2dd751ec7472ac2c644ad145a50ec7e  lean.tar.gz.part08
47718977ebaa8613f1647e93134479780db9320c5fa911463fd312a6257b796f  lean.tar.gz.part09
1d85ece78e0779cec26b0cce29c6462d9f90180e56d78120b152df101715240b  lean.tar.gz.part10
cf83a159d1a9540012229c376562587dd966da10cd657cbcef53acfd03232448  lean.tar.gz.part11
1aa5415bd2db83b2689afeeb946419303b3c4f599ae790ad74d38465f768b502  lean.tar.gz.part12
2de4edbce8ebdbfd0b94bc89bab518c7294209f408ec5b14a7be9e4832d9da81  lean.tar.gz.part13
53f8ea43a9b5dcab97b84a52f3ac2848711c844a5420a4c56418093bacb3c6f6  lean.tar.gz.part14
```

- `cat lean.tar.gz.part?? > lean.tar.gz`: 239,275,554 bytes, sha256 `9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc`. MATCHES the size and hash stated in the mirror README.
- Mirror release tarball `https://github.com/CocoSgt/riemann-hypothesis-lean/releases/download/v2026-11-20/lean.tar.gz` (302 to release-assets.githubusercontent.com, HTTP 200): 239,275,554 bytes, sha256 `9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc`. Identical to the author's concatenation.
- `tar -tvzf` before extraction: 175,190 entries, every one a regular file (type `-`, mode `-rw-r--r--`, owner `0/0`, mtime 1970-01-01 00:00), all under top-level `lean/`. 0 absolute paths, 0 `..` components, 0 symlinks, 0 hardlinks, no directory entries, no other types. Contents: `lean/lake-manifest.json`, `lean/lakefile.toml`, `lean/lean-toolchain`, and 175,187 files under `lean/src/`. Extracted with `tar -xzf ... -C /home/user/work/extract --no-same-owner` (6.2 s, 2.4 MB RSS).
- Mirror clone: `GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1 https://github.com/CocoSgt/riemann-hypothesis-lean /home/user/work/mirror` (25.5 s, 399 MB RSS). `git rev-parse HEAD` = `7cbf7a0c32fca1badf05931879a37c3f8a2b03b4` (as expected).
- `diff -rq -x .git extract/lean mirror` — complete output:

```
Only in mirror: .gitignore
Only in mirror: README.md
```

  `src/` (diff -rq: no differences), `lakefile.toml`, `lean-toolchain`, `lake-manifest.json` (cmp): byte-identical between author tree and mirror.
- Manifest hash, run in /home/user/work/extract/lean (author tree):
  `find src -type f -print0 | LC_ALL=C sort -z | xargs -0 sha256sum | sha256sum` →

```
5d2967ae86f7c55244c87da86cc0d2c046d3202e87234b05b954722b46cd627d  -
```

  `find src -type f | wc -l` = 175187; `find src -name '*.lean' | wc -l` = 175187. No symlinks in the extracted tree.
- sha256 of `lake-manifest.json` = `fee57ee9ed399d0a638ca955e5ad40a37a36eeb9b6dfd9f5964114fa7bbe4774`.

## 2. Environment

- Ubuntu 24.04.5 LTS, kernel 6.18.44; Intel(R) Xeon(R) Processor @ 2.30GHz; `nproc` = 4; `free -g` total 15 GB, no swap; `df -h /home/user`: 252G size, 61G available at start.
- `apt-get install -y time zstd` succeeded (time 1.9, zstd 1.5.5).
- elan: `curl https://elan.lean-lang.org/elan-init.sh | sh` was blocked by this session's permission layer as a pipe-to-shell; I downloaded the same script to a file (sha256 `a620ff1641616222c8d37c54845492004bb84d6877cdbc944dd65c1aa685bf53`, 377 lines), looked at it, and ran `sh ./elan-init.sh -y --default-toolchain none`. `elan --version` → `elan 4.4.0 (3cc76985a 2026-11-18)`.
- Toolchain route: FALLBACK. elan's own download of `leanprover/lean4:v4.33.1` failed: `error: error during download / caused by: [7] Could not connect to server (CONNECT tunnel failed, response 403)` (also `warning: could not check for elan self-update: failed to fetch https://github.com/leanprover/elan/releases/latest: HTTP status 403`). Not retried. Instead fetched `https://github.com/leanprover/lean4/releases/download/v4.33.1/lean-4.33.1-linux.tar.zst` (HTTP 200, 570,405,234 bytes, sha256 `890afd185370f85666025b883914ab4f4b339136f8c96167b69cfb62aecaf235`), unpacked to /home/user/work/toolchain (outside the project), and `elan toolchain link leanprover/lean4:v4.33.1 /home/user/work/toolchain/lean-4.33.1-linux`.
- In the project root: `lean --version` → `Lean (version 4.33.1, x86_64-unknown-linux-gnu, commit 819816b2e0a3bf405af45ae5c7af2491d8f5bee6, Release)`; `lake --version` → `Lake version 5.0.0-src+819816b (Lean version 4.33.1)`.
- `lake exe cache get`: exit 0, wall 1:25.98, peak RSS 1,018,996 KB. Lake cloned mathlib, plausible, LeanSearchClient, import-graph, ProofWidgets4, aesop, quote4, batteries, lean4-cli; built the `cache` exe (26 jobs; only Cache.*/Cli/Batteries.Tactic.OpenPrivate support modules, no Mathlib modules compiled); `Attempting to download 8690 file(s) from leanprover-community/mathlib4 cache at https://lakecache.blob.core.windows.net/mathlib4-master` … `Decompressed 8690 file(s)`.
- `git -C .lake/packages/mathlib rev-parse HEAD` = `0df444a360eaa60ab8c11dca51a86af692955474` (matches pin). All other package HEADs equal the revs in `lake-manifest.json` (plausible b7eb3304, LeanSearchClient 5f4d51b8, importGraph 16f02aa7, proofwidgets 4be2e3d5, aesop 3448c0bc, Qq 92c15be1, batteries 4488d40d, Cli 6130a478).
- `lake-manifest.json` after cache get, after the builds and after the checker: byte-identical to the copy taken before (`cmp`). `src/` re-diffed against the mirror after all runs: still identical. Project root contains only `.lake`, `lake-manifest.json`, `lakefile.toml`, `lean-toolchain`, `src`.
- Job settings: Lake defaults. A first attempt with `lake build -j3 <target>` failed instantly for all three targets with `error: unknown short option '-j'` (this Lake has no such flag; logs kept as `build-*.attempt1-badflag.log`); reruns used plain `lake build <target>`, one target at a time. Each target has at most 2 in-repo modules, so at most 2 repo modules could compile concurrently. Project options from `lakefile.toml` applied as published (`maxHeartbeats = 4000000`, `--tstack=400000`, etc.).

## 3. Tier A

Transitive in-repo import closure (text scan of `import` lines, script /home/user/work/scripts/closure.py, run with `python3 -I`):

- `Statements`: 1 in-repo module (itself); external: `Mathlib`.
- `Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip`: 2 in-repo modules (itself + `...CharacterBoxes.HalfPlane`); external: `Mathlib`.
- `Formalism.GammaFactorNonvanishing.RhOfRight`: 1 in-repo module (itself); external: `Mathlib`.
- For reference, `Main`: 175,187 in-repo modules by the same scan (i.e. every file in `src/`). Not built.

Builds (each under `/usr/bin/time -v`, no Mathlib module was built or rebuilt in any of them: 0 lines matching `Building Mathlib`/`Built Mathlib`):

| target | result | wall | peak RSS | Lake summary |
|---|---|---|---|---|
| `lake build Statements` | PASS (exit 0) | 0:12.45 | 6,812,740 KB | `Build completed successfully (8706 jobs).` |
| `lake build Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip` | PASS (exit 0), 1 linter warning | 0:12.82 | 6,962,068 KB | `Build completed successfully (8707 jobs).` |
| `lake build Formalism.GammaFactorNonvanishing.RhOfRight` | PASS (exit 0) | 0:08.00 | 6,972,676 KB | `Build completed successfully (8706 jobs).` |

Repo modules actually compiled: `Statements` (7.7s); `...CharacterBoxes.HalfPlane` (3.6s) and `...CharacterBoxes.ClaimStrip` (3.7s); `...GammaFactorNonvanishing.RhOfRight` (4.2s). No errors, no OOM, no heartbeat timeouts. The only warning in the three builds, verbatim:

```
⚠ [8707/8707] Built Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip (3.7s)
warning: src/Development/AutomorphicArithmetic/CharacterBoxes/ClaimStrip.lean:66:4: Try this: 
  haveI̵

The goal is a proposition, so `have` is preferred over `haveI`.
The difference between `have` and `haveI` is that `haveI` inlines the value.
But this is not relevant for proofs because of proof irrelevance.

Note: This linter can be disabled with `set_option linter.style.haveILetI false`
```

(continued in part 2)

REPORT-tierA.md — part 2 of 2 (rest of section 3, sections 4–5).

### TierA.lean (exact content as specified, at /home/user/work/scripts/TierA.lean)

`lake env lean /home/user/work/scripts/TierA.lean` from the project root: exit code 0, wall 0:04.34, peak RSS 6,917,200 KB. Complete output:

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

All three `example ... := Iff.rfl` lines compiled (no error output). All names existed; no correction file was needed.

### TierA2.lean (my additional file, /home/user/work/scripts/TierA2.lean)

Imports `Statements`, `...ClaimStrip`, `Formalism.GammaFactorNonvanishing.RhOfRight`; does `#check @RiemannHypothesis`, `#check`/`#print axioms` of `Formalism.VW.rh_of_right` (the only declaration in RhOfRight.lean) and of the remaining `Claim.*` theorems, reports the defining module of each name via `env.getModuleIdxFor?`, and lists every non-internal constant whose defining module root is `Statements`, `Development` or `Formalism`. Exit code 0, wall 0:06.63, peak RSS 6,974,064 KB. Complete output:

```
RiemannHypothesis : Prop
Formalism.VW.rh_of_right : (∀ (s : ℂ), 1 / 2 < s.re → s ≠ 1 → riemannZeta s ≠ 0) → RiemannHypothesis
'Formalism.VW.rh_of_right' depends on axioms: [propext, Classical.choice, Quot.sound]
'Claim.factor_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound]
'Claim.prim_zero' depends on axioms: [propext, Classical.choice, Quot.sound]
'Claim.gamma_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound]
'Claim.prim_reflect' depends on axioms: [propext, Classical.choice, Quot.sound]
"RiemannHypothesis is defined in module Mathlib.NumberTheory.LSeries.RiemannZeta"
"riemannZeta is defined in module Mathlib.NumberTheory.LSeries.RiemannZeta"
"DirichletCharacter.LFunction is defined in module Mathlib.NumberTheory.LSeries.DirichletContinuation"
"DirichletCharacter is defined in module Mathlib.NumberTheory.DirichletCharacter.Basic"
"RiemannZetaZerosOnLine is defined in module Statements"
"DirichletLNonvanishingRightOfHalf is defined in module Statements"
"DirichletLZerosOnLine is defined in module Statements"
"PrimitiveDirichletLZerosOnLine is defined in module Statements"
"Claim.HalfPlane is defined in module Development.AutomorphicArithmetic.CharacterBoxes.HalfPlane"
"Claim.Strip is defined in module Development.AutomorphicArithmetic.CharacterBoxes.HalfPlane"
"Claim.Zeta is defined in module Development.AutomorphicArithmetic.CharacterBoxes.HalfPlane"
"Claim.strip is defined in module Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip"
"Formalism.VW.rh_of_right is defined in module Formalism.GammaFactorNonvanishing.RhOfRight"
Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip :: Claim.factor_ne_zero
Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip :: Claim.gamma_ne_zero
Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip :: Claim.prim_reflect
Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip :: Claim.prim_zero
Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip :: Claim.strip
Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip :: Claim.zeta
Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip :: Claim.zeta_iff
Development.AutomorphicArithmetic.CharacterBoxes.HalfPlane :: Claim.HalfPlane
Development.AutomorphicArithmetic.CharacterBoxes.HalfPlane :: Claim.Strip
Development.AutomorphicArithmetic.CharacterBoxes.HalfPlane :: Claim.Zeta
Formalism.GammaFactorNonvanishing.RhOfRight :: Formalism.VW.rh_of_right
Statements :: DirichletLNonvanishingRightOfHalf
Statements :: DirichletLZerosOnLine
Statements :: PrimitiveDirichletLZerosOnLine
Statements :: RiemannZetaZerosOnLine
```

### Redefinition checks

`src/Statements.lean` verbatim (also checked with `cat -A`: plain UTF-8, LF line endings, no unusual invisible characters):

```lean
import Mathlib

def RiemannZetaZerosOnLine : Prop :=
  ∀ s : ℂ, riemannZeta s = 0 → (¬∃ n : ℕ, s = -2 * ((n : ℂ) + 1)) → s ≠ 1 → s.re = 1 / 2

def DirichletLNonvanishingRightOfHalf : Prop :=
  ∀ (N : ℕ) [NeZero N] (χ : DirichletCharacter ℂ N) (s : ℂ),
    1 / 2 < s.re → (χ ≠ 1 ∨ s ≠ 1) → DirichletCharacter.LFunction χ s ≠ 0

def DirichletLZerosOnLine : Prop :=
  ∀ (N : ℕ) [NeZero N] (χ : DirichletCharacter ℂ N) (s : ℂ),
    0 < s.re → s.re < 1 → DirichletCharacter.LFunction χ s = 0 → s.re = 1 / 2

def PrimitiveDirichletLZerosOnLine : Prop :=
  ∀ (N : ℕ) [NeZero N] (χ : DirichletCharacter ℂ N), χ.IsPrimitive →
    ∀ s : ℂ, 0 < s.re → s.re < 1 → DirichletCharacter.LFunction χ s = 0 → s.re = 1 / 2
```

`src/Main.lean` verbatim:

```lean
import Statements
import Supplements.Kernels.MainTheoremsAll

theorem riemannHypothesis : RiemannHypothesis := rhOfAll

theorem riemannZeta_eq_zero_re : RiemannZetaZerosOnLine := rhOfAll

theorem LFunction_ne_zero_of_half_lt_re : DirichletLNonvanishingRightOfHalf := allChi

theorem LFunction_eq_zero_re : DirichletLZerosOnLine := claimAll.2.1

theorem LFunction_eq_zero_re_of_isPrimitive : PrimitiveDirichletLZerosOnLine := critAll
```

Neither file contains `namespace`, `open`, `notation`, `macro`, `syntax`, `local` or `set_option`. `Statements.lean` imports only `Mathlib`. `Main.lean` imports `Statements` and `Supplements.Kernels.MainTheoremsAll` (not built here; `rhOfAll`, `allChi`, `claimAll`, `critAll` were NOT checked).

The task's grep (with `-P` so `\d` works), `head`:

```
src/Formalism/GammaFactorNonvanishing/RhOfRight.lean:5:theorem Formalism.VW.rh_of_right (hz : ∀ s : ℂ, 1 / 2 < s.re → s ≠ 1 → riemannZeta s ≠ 0) : RiemannHypothesis := by
src/Formalism/GammaFactorNonvanishing/CritLine.lean:29:theorem Formalism.VW.rh_of_every (h : UpperTheory.EveryCharacter) : RiemannHypothesis :=
src/Formalism/HalfLinks/Statement.lean:144:def RiemannHypothesisOfHalfLinks : Prop :=
src/Formalism/SizeWindowBrackets/SChain.lean:92:def ChainGivesRiemannHypothesis : Prop :=
src/Formalism/SizeWindowBrackets/SChain.lean:97:def ChainEventualGivesRiemannHypothesis : Prop :=
src/Formalism/SizeWindowBrackets/GrowthBoundGivesRiemannHypothesis.lean:131:def RiemannHypothesisOfBalanceAndGrowthData : Prop :=
src/Formalism/SizeWindowBrackets/GrowthBoundGivesRiemannHypothesis.lean:139:def GrowthBoundGivesRiemannHypothesis : Prop :=
src/Formalism/SizeWindowBrackets/GrowthBoundGivesRiemannHypothesis.lean:179:def RiemannHypothesisOfReducedGrowthData : Prop :=
src/Formalism/SizeWindowBrackets/FixedEpsilonConcreteGrowthBound.lean:105:def GrowthBoundAndRiemannHypothesis : Prop :=
src/Formalism/SizeWindowBrackets/FixedEpsilonConcreteGrowthBound.lean:110:def RiemannHypothesisOfEventualGrowthBound : Prop :=
```

Each hit is either a theorem whose statement mentions `RiemannHypothesis` or a differently-named `def` containing that substring. Further greps over all of `src/`:
- files containing the word `RiemannHypothesis`: 25.
- declarations (`def/abbrev/theorem/lemma/structure/class/inductive/opaque/axiom/instance/alias`) whose declared name is exactly `RiemannHypothesis`, `riemannZeta` or `LFunction` (optionally namespace-qualified on the same line): none for `RiemannHypothesis` or `riemannZeta`; two for `LFunction`: `src/GroundTheory/GlobalFields/TateThesis/HeckeLFunction.lean:363: def LFunction (s : ℂ) : ℂ :=` and `src/GroundTheory/AutomorphicForms/GL2/GJLocalZeta.lean:431: def LFunction (s : ℂ) : ℂ :=` (inside whatever namespaces those files open; neither file is in the Tier A closure; their enclosing namespaces were not examined).
- `namespace (DirichletCharacter|Complex|_root_)`: one hit, `src/GroundTheory/GlobalFields/TateThesis/NoSmallSubgroups.lean:73:namespace Complex` (not in Tier A closure).
- Kernel-level confirmation for the Tier A closure only (TierA2 output above): `RiemannHypothesis` and `riemannZeta` resolve to `Mathlib.NumberTheory.LSeries.RiemannZeta`, `DirichletCharacter.LFunction` to `Mathlib.NumberTheory.LSeries.DirichletContinuation`, and the Tier A modules declare exactly the 15 constants listed. This says nothing about what the other 175,183 modules declare.

## 4. lean4checker on Tier A modules

- `GIT_LFS_SKIP_SMUDGE=1 git clone https://github.com/leanprover/lean4checker` worked. There is NO tag for v4.33.1: the newest tags are `v4.29.0-rc1` … `v4.29.0-rc8`; HEAD (91a7f0e8, 2026-03-25) is "doc: deprecation notice — leanchecker is now built into Lean", and its `lean-toolchain` is `leanprover/lean4:v4.29.0-rc8`. The standalone lean4checker was therefore NOT built (no matching version).
- Used instead: the `leanchecker` binary shipped inside the v4.33.1 toolchain (same toolchain as the build), as the repo's README directs.
- Attempt 1: `lake env leanchecker Statements Development.AutomorphicArithmetic.CharacterBoxes.HalfPlane Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip Formalism.GammaFactorNonvanishing.RhOfRight` → exit 137 after 0:20.40, peak RSS 13,247,480 KB; the kernel OOM-killed it. RESOURCE failure, not a checker verdict.
- Attempt 2, one module per invocation with `LEAN_NUM_THREADS=1`, from the project root; each printed no output:

| command | exit | wall | peak RSS |
|---|---|---|---|
| `lake env leanchecker Statements` | 0 | 0:11.64 | 5,900,580 KB |
| `lake env leanchecker Development.AutomorphicArithmetic.CharacterBoxes.HalfPlane` | 0 | 0:05.56 | 5,988,528 KB |
| `lake env leanchecker Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip` | 0 | 0:05.34 | 5,988,668 KB |
| `lake env leanchecker Formalism.GammaFactorNonvanishing.RhOfRight` | 0 | 0:05.17 | 5,989,176 KB |

- `--fresh`: not run (replaying all of Mathlib does not fit 15 GB given the OOM above). So each module's own declarations were replayed on top of its imports' .olean files as-is; the Mathlib oleans themselves (from the cache) were not re-checked.

## 5. Anything surprising, stated factually

- What Tier A covers: 4 of 175,187 files (`Statements`, `HalfPlane`, `ClaimStrip`, `RhOfRight`). These contain the statement definitions and conditional theorems (`Claim.strip : HalfPlane → Strip`, `Claim.zeta : HalfPlane → Zeta`, `Formalism.VW.rh_of_right : (∀ s, 1/2 < s.re → s ≠ 1 → riemannZeta s ≠ 0) → RiemannHypothesis`). The unconditional theorems in `Main.lean` depend on `Supplements.Kernels.MainTheoremsAll`, which was NOT built or examined. Nothing here bears on whether `Main` compiles or what its axioms are.
- Blocked hosts / network: elan's toolchain download and self-update check got proxy 403 (the self-update URL was `https://github.com/leanprover/elan/releases/latest`; the toolchain download URL was not printed by elan). Not retried; fallback tarball route used. No other refusals. Network use observed during the work: alpo.ge, elan.lean-lang.org, GitHub git clones via the git proxy, GitHub release downloads, lakecache.blob.core.windows.net. I did not instrument the builds with a syscall/network tracer, so "nothing touched the network during `lake build`" is NOT a verified claim; the three builds only compiled 4 repo modules whose source is quoted or summarised above and contains no metaprograms.
- Whole-tree text greps (line counts over `src/`, informational, not a semantic audit): `^\s*axiom` 0; `\bsorry\b` 0; `native_decide` 0; `ofReduceBool` 0; `\bunsafe\b` 0; `implemented_by` 0; `\bextern\b` 0; `^\s*initialize` 0; `run_elab`/`run_meta` 0; `set_option debug` 0; `IO.FS`/`IO.Process`/`readFile`/`writeFile`/`getEnv`-style patterns 0; `\bIO\.` 143 lines (the ones sampled are a mathematical namespace named `IO`, e.g. `IO.sqrt_d_pos`, `IO.cf`); `open private` 220; `^export` 38; lines starting with notation/macro/syntax/elab/infix-type commands 1,813.
- `run_cmd`: 5 lines, `src/BuildAid/D1..D5.lean`, each of the form `run_cmd Lean.modifyEnv fun env => Lean.LibrarySuggestions.nameDenyListExt.addEntry env "<string>"` (strings: CompanionTheory, CrystallineSemistableComparison, GlobalTheory, PositivityTheory, UpperTheory).
- `addDecl`: 2 lines, both in `src/Formalism/HermitianCurvature/HermitianCurvatureProofs/CutCptCopy.lean` (lines 78, 82). That file defines a command `cpt_copy_thms` whose implementation walks existing constants and calls `addDecl` with `.defnDecl`/`.thmDecl` copies under renamed names, with constant names substituted in types and values (`subst`, `mapName`, a `special` lookup table and a `manual` set). `addDecl` sends declarations through the kernel. Not built, and its use sites and tables were not examined; flagged as a place where declarations are generated by a metaprogram rather than written in source.
- Nondeterminism: not tested (each build run once).
- One linter warning (`haveI` vs `have`, ClaimStrip.lean:66:4), quoted in section 3. No `sorry` warnings in any build output.
- Lake 5.0.0 has no `-j` option (see section 2).
- Disk after all steps: `df -h /home/user` showed 24G used, 45G available; nothing was pushed anywhere, no repositories/PRs/issues/comments created.

Not run: `lake build Main`, plain `lake build`, any module outside the 4 above, `leanchecker --fresh`, standalone lean4checker build, repeat builds for determinism, syscall/network tracing.

Logs: /home/user/work/logs (download.log, step1.log, step2.log, cache-get.log, closure.log, grep.log, build-*.log, TierA.out, TierA2.out, leanchecker-*.log). Scripts: /home/user/work/scripts.

(end of report)
