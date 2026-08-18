# Adversarial audit findings — /home/user/Q-sequence (2026-08-18)

Scratch artifacts in this directory:
- lake_build.log (cached build), fresh_build.log (from-scratch rebuild in repo_copy/, all native_decide certificates re-ran; BigCertificates 224s; EXIT=0)
- AxiomCheck.lean / axioms.out (+ AxiomCheck2.lean): #print axioms results
- myq.c, myq2.c, myq3.c, myq4.c, top10.c + *.out: independent computations (written from the definition only, before reading repo implementations)
- theorem_d_audit.py / theorem_d_audit.out: my own Theorem-D construction implementation from the proof TEXT + grid search
- check_theorem_d_repo.out: output of the repo's script
- myrec_absdev.txt, myrec_jump.txt: my record streams (diffed against repo data files)

## 1. Lean build + axioms — PASS
- lake build in the repo: cached, success ("Build completed successfully (12 jobs)").
- From-scratch rebuild of a copy of the sources: success in ~5.5 min (Certificates 22s, Verify 61s, BigCertificates 224s) — the 10^7/10^8 native_decide certificates genuinely re-verify.
- grep sorry: no occurrences as code; the token appears only inside two comments (Spec.lean:9, Basic.lean:4). grep "axiom ": none.
- #print axioms (via lake env lean):
  - deterministic, deviation_identity, lookup_gap: [propext, Quot.sound]
  - problemA_iff_uniformBound, problemA_iff_engine, aliveUpTo_iff_history, Qval_rec, not_eventually_ge_three_quarters: [propext, Classical.choice, Quot.sound]
  - history_1e7, history_1e8, Q_1e7, Q_1e8, Q_96: the three standard + exactly one native_decide-generated axiom each (aliveUpTo_1e7/_1e8/Qeng_1e7/Qeng_1e8/Qeng_96._native.native_decide.ax_1_1, each of shape `decide (...) = true`)
  - no_uniform_bound_below_3_4: standard three + Qeng_4...ax_1_1 + aliveUpTo_1e7...ax_1_1
  - No other axiom anywhere.
- Pedantic: REPORT.md:536-537 and README.md:140-141 name the extra axiom Lean.ofReduceBool "visible via #print axioms"; on this toolchain (4.33.0) #print axioms shows per-theorem <thm>._native.native_decide.ax_1_1 axioms instead. Substance unaffected.

## 2. Report/theorem-name consistency — PASS
Every Lean name cited in REPORT.md §2's table and README.md's status table exists in QSequence/*.lean (38/38 checked). None missing.
- Minor: README "Layout" (lines 60-77) omits scripts/compute_q.c and scripts/check_theorem_d.py from the tree (compute_q.c is referenced later at README:115-118; check_theorem_d.py is referenced nowhere in REPORT.md/README.md).

## 3. Independent computational re-derivation — PASS (all values match)
Fresh C implementation (myq.c) from the prompt's definition only, death condition + Q(n)<=n checked every step, run to 10^8:
- Q(10^5)=48157, Q(10^6)=512066, Q(10^7)=5124632 (claims: same) OK
- sum Q(1..10^7) mod 2^64 = 25000190971777 OK; violations Q(n)>n: 0 (to 10^8) OK
- Q(4)=3, Q(15)=10, Q(16)=9, Q(96)=64, Q(24)=16, Q(48)=32, Q(768)=512, Q(1536)=808 all OK
- Bonus matches: Q(10^8)=50166508, Q(2^20)=527047, sums at 10^6 (250007889123) and 10^8 (2500005606402854); README's N=10^7 diagnostics block (max|2Q-n|=732635 at 9187467; jumps 661641/631083; mono failures 4992973; s-range [-402982,436832]) all reproduced exactly (myq2).

## 4. Data-file consistency — PASS (with rounding notes)
- run_1e9.log: Q(10^9)=497429917, 2Q-N=-5140166 (arithmetic re-verified), max|2Q-n|=67023661, max jump 52719055, max ratio 3/4, all checkpoints — consistent with REPORT §3.
- Argmaxes: 67023661 at n=989523521 (generations.txt k=29 row + records_absdev.txt last line, sign +). Jump 52719055 at n=984141755, records_jump.txt last line "-52719055" -> downward OK.
- 67023661/989523521 = 0.0677333 -> report "~0.0677 n" OK.
- 52719055/984141755 = 0.0535686 -> report "~0.054 n" OK (2-s.f. rounding).
- 67023661/2^29 = 0.1248413; generations.txt has 0.124841; REPORT table prints 0.125 (correct 3-dp rounding; note it rounds up).
- §3 table rows k=10/14/18/22/26/29: (0.370117->0.370, 0.613767->0.6138), (0.256775->0.257, 0.582208->0.5822), (0.213509->0.214, 0.566430->0.5664), (0.172585->0.173, 0.550711->0.5507), (0.153833->0.154, 0.540704->0.5407), (0.124841->0.125, 0.534474->0.5345) — all match at stated rounding.
- Independent recomputation (myq3): generations.txt rows k=1..25 match EXACTLY on every column (count, max|e|, ratio, at_n, sum, mean, maxQ/n, 3 lookup-census cols). Record streams (absdev incl. signs, jump) match exactly for n <= 10^8. Rows k>=26 (need the 4 GB 10^9 run, beyond the 3 GB RAM budget) verified for internal consistency only: census sums = 2*count for all rows; count(29)=10^9-2^29+1; row-29 max matches log + records; run_1e9.err progress maxdevs match record entries.
- Extra: §8 R1 exact counts at 10^8 verified: distinct d = 4080633, distinct s = 2799985, distinct e = 4721573 (myq4, exact match). §8 R5 verified: d(375..383)=d(759..767) (maximal: both extensions differ), no length-10 repeat of d below 10^7, dyadic first-symbol alignment fails for all k in [10,22], exactly 231 zeros of e below 10^7 with pairwise-distinct 32-symbol follow-windows. §3's "ten largest ratios over [100, 5e8] all below n=1600" verified: top-10 arg-ns are 124..1569 (10th: n=997, 0.6068); [1e8,5e8] bounded by 0.5407.
- R3 percentages re-derived from the file: in-parent 98.02% (k=24) — 98.56% (k=28); below-parent 0.51–0.69% -> report's "98.0–98.6%" and "0.5–0.7%" OK.
- Note: the cross-validation matrix columns "agent 1–4" (REPORT §3) rest on artifacts NOT in the repository ("preserved with the session artifacts"); every number in those columns that I could recompute (all of them) matched.

## 5. Theorem C audit — PASS (no hole; two pedantic notes)
- Case 0<c<1: a_n, b_n >= (1-c-2e)n with 1-c-2e > 0 (e < (1-c)/2), so a_n -> infinity IS justified. Product bound: for e < c the interval [(c-e)(1-c-2e), (c+e)(1-c+2e)] is derived correctly; if e >= c (allowed by the stated constraint when c < 1/2), the stated lower endpoint is negative and membership still holds trivially by positivity — literally true in all cases; sandwich as e->0 gives c = 2c(1-c), c != 0 => c = 1/2. Sound.
- Case c=0: L(t) >= 2 L((1-2e)t) for t >= T=M+2 checked (m >= t => m-2 >= M; a_m,b_m >= (1-e)m >= (1-2e)t); iteration count j* = floor(log(t/T)/log(1/(1-2e))) keeps all intermediates >= T (floor property) and L>=1 at the bottom; 2^{j*} >= (1/2)(t/T)^beta with beta = log2/log(4/3) = 2.4094 ~ 2.41 > 1 OK; upper bound L(t) <= e(t+M+1) linear OK; contradiction OK.
- Case c=1 (e=1/4): a_n <= en+1, b_n <= en+2 OK (n >= M+2); Q(n) <= a_n+b_n <= 2en+3 = n/2+3 using Q<=id (A) OK; vs Q(n) >= (3/4)n: (3/4)n > n/2+3 iff n >= 13 OK (implicitly also n >= M+2, from context). Matches the Lean kernel not_eventually_ge_three_quarters (threshold 3/4; the ">2/3" remark checks: 2(1-c)<c iff c>2/3).
- A-usage audit: only totality, positivity, Q<=id, recurrence — no circular use of B or of the limit. The note "A is used [as] totality plus Q <= id" omits positivity (used via L >= 1), but positivity is a structural history fact (history_pos), not extra strength. No hole found.

## 6. Theorem D audit — PASS overall
(i) scripts/check_theorem_d.py: 10 parameter sets satisfying (a),(b) all print BREAK (checked at n = 1e5, 1e6+7, 1e7+1); final line "ALL BREAKS CONFIRMED". The 11th set (74/100, 99/100, 0, 64) deliberately violates (b) at m=96 and is reported "hypothesis violated", not a failed break.
(ii) Case coverage of 0 <= c1 <= c2 < 1 is complete: c1<1/2 splits into c2>0 (Case 1) / c2=0 (Case 2); c1>=1/2 forces c2>=1/2, splitting into c2>1/2 (Case 3) / c2=1/2 => c1=c2=1/2 (Case 4). No gap.
(iii) Attack (my own implementation from the proof text; exact rationals; 46800 grid points incl. boundaries c1=c2, c2 up to 999/1000, d up to 10^4, c1 = 1/2 +/- 1e-6 and 1e-9; 31919 sets satisfy (a)&(b); 15 offsets around 1e5):
  - Zero failures for Cases 2, 3, 4 at any tested n.
  - 52 (set, n) NOBREAK events, all Case 1 with c1 in {1/2-1e-6, 1/2-1e-9}, d1=0, d2 in {1/2, 1} (e.g. c1=499999/1000000, c2=2/3, d1=0, d2=1/2, n=100000: f(n)=66667 vs upper edge 66667.166 — inside). All break from n = 1e6 (resp. 1e9 for the 1e-9 sets) onward; for the extreme set non-breaks stop by n ~ 4.5e8 and 6000/6000 sampled n in [2e9, 1e13] break. This matches the proof's margin c2(1-2c1)n - K exactly, and the theorem claims breakage only "for all sufficiently large n" (threshold parameter-dependent). NOT a proof failure; no parameter set falsifies the proof at all large n.
  - 9015 INVALID side-condition events at n ~ 1e5 (e.g. c2=24/25, d2=1e4: floor(c2(n-1)+d2) > n-1), all valid-and-breaking at larger n — again "n large" effects.
  - Caveat worth stating: at a FIXED n like 1e5, Step is not refutable for every admissible parameter set; the theorem does not claim that.
(iv) Floor confirmed: c1=c2=1/2 and 64 in E(96) force 48 + d2 >= 64 => d2 >= 16 (64-48=16); d2 = 16 - 1/1000 fails (upper edge 63.999).
(v) Step is a fair formalization of "the envelope induction closes": hypothesis = envelope at m<n, structural input at n = the recurrence only. The scope caveat is stated twice (REPORT:252-256; REPORT:335-338). Nuance: Step's f need satisfy the recurrence only AT n; inductions that additionally exploit the recurrence at positions < n are outside the family — covered by the blanket caveat but not named explicitly as an example.
- Trivial nits: the preamble's "From (b) at m = 1: c2 + d2 >= 1" is never used downstream; Case 2's derivation of c1=0 from (a) is redundant given c1 <= c2 = 0.

## 7. Proposition E audit — PASS
(i) Pi-0-1 status correct: A iff forall N (aliveUpTo N = true) with aliveUpTo total computable (problemA_iff_engine, machine-checked).
(ii) Sigma-1-completeness step correct: a death at n0 makes "aliveUpTo n0 = false" a true Sigma-1 (indeed Delta-0-verifiable) sentence, provable already in Robinson arithmetic, hence in PA and ZFC; so PA/ZFC prove not-A, contradicting independence; therefore independence => no death index => immortality in the standard model. (Implicit: "Problem A" as an arithmetic sentence is arithmetized via the engine form, which (i) supplies — canonical, no gap.)
(iii) Class-vs-instance point correct and properly hedged. The conclusions "cannot produce a third outcome", "independence would itself resolve A affirmatively (without a ZFC proof)", and "scope theorem, not progress on A" are accurate; no overclaim found.

## 8. Honesty audit — PASS overall, with 5 wording findings (quoted)
No sentence claims A or B is resolved; the negative status is stated prominently (REPORT:12-14; REPORT:560-561 "A complete resolution of Problem A or B was not achieved and is not claimed."; README:30-32 "not a resolution of either problem"; README:54-55 "The native_decide theorems are finite certificates, not a proof of Problem A."). Empirical material is systematically labeled computed/observed/measured. Issues found:
1. REPORT.md:27-29 (and README.md:33-34 "two rigorous no-go theorems"): "Two rigorous no-go theorems: the two-parameter linear-envelope induction cannot close (Theorem D), and the finite-state/renewal routes fail on the data at all tested abstractions and scales (§8)." — the second item is an empirical (data) result, not a theorem; §8 itself is careful ("blocked as formulated ... not 'proved impossible in principle' (except D, which is a theorem)"), so the bullet's label overstates.
2. README.md:52: "open — conditional form proved on paper (Theorem C)" — but README's own "conditional form" (ProblemB_conditional, README:85-89) "must be proved without assuming the limit exists", and Theorem C assumes the limit exists. Similarly REPORT.md:554-555 "the conditional direction fully proved (Theorem C)". REPORT §5:235-236 states the correct scope ("This proof does not prove the limit exists; that is Gap B"), so these are misleading shorthands, not substantive overclaims.
3. REPORT.md:18-22: "Machine-checked reductions (Lean 4, core only, no sorry, no extra axioms): ... spec-level finite certificates through 10^8." — the certificates DO use extra (native_decide) axioms; §2:66-68 and §10 state this correctly with the circled-plus marking; the intro bullet's "no extra axioms" wrongly covers the certificates.
4. REPORT.md:536-537 / README.md:140-141: axiom named Lean.ofReduceBool "visible per-theorem via #print axioms" — actual #print axioms output shows <thm>._native.native_decide.ax_1_1 axioms (Lean 4.33 native_decide artifacts), not Lean.ofReduceBool.
5. REPORT.md:186: "The identities I1–I3 were additionally verified..." — §4's display labels only (I1) and (I2); no (I3) is defined (the lookup-location/separation lines are unlabeled).
Minor: "Verified computation to 10^9" (REPORT:23, :97) uses "verified" for a self-checking C run cross-validated by independent implementations; Lean verification stops at 10^8 — the distinction is made explicitly elsewhere (REPORT:99-102, README:49), so this is wording, not substance. The §3 cross-validation matrix's agent columns are not reproducible from the repo (artifacts external), though every recomputable number matched.
