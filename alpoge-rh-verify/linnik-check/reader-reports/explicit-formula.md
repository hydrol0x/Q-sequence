<!-- Report of an automated reviewer (a Claude subagent) asked to audit this part of the Linnik proof by reading the Lean source. Unedited. Nothing was compiled by the reader. -->

VERDICT (cluster A, truncated explicit formula): SOUND. I found no false, vacuous or mis-quantified statement and no unusual proof device. Confidence about 90% that the cluster is correct mathematics as written. The residual doubt: this was a source read only (nothing compiled), I could not check Mathlib API meanings (no Mathlib sources on disk), and the chain rests on a few lemmas owned by other reviewers whose proofs I did not read (listed at the end).

Base path for everything below: /home/user/cocosgt/riemann-hypothesis-lean/src/Development/AbelianVarietyTheory/Proofs/ (GI = GlobalInterpolation/, IW = IwasawaDecomposition/).

1. TOP STATEMENT (GI/ExplicitFormulaDirichletZerosRightHalfStatement.lean:8, proved at GI/ExplicitFormulaDirichletZerosRightHalf.lean:204)

True as stated, for all q ≥ 1, all χ (imprimitive, trivial, mod 1), all 2 ≤ T ≤ u, with an absolute C. It is much weaker than the classical truth.
- Zeros with Re < 1/2: each term is at most √u/|ρ|. Zeros with |γ| > 1 give √u·log²(qT). Zeros with |γ| ≤ 1 need a lower bound on |ρ|; by the functional equation that is 1 − β for a zero of χ̄ near 1, so the reflected Siegel zero costs 1/(1 − β₁). Classically that is ≪ √q·log²q; the formalisation uses 1 − β ≥ c/(q²·log 3q) times a count of ≪ log 3q zeros, giving q²·log²(3q) ≤ q³·log².
- Constant term: b(χ) = O(log q) + Σ_{|γ|<1} 1/ρ, and (1−a)·log u, are absorbed the same way.
- Imprimitive χ: the zeros on Re s = 0 lie outside zerosBox; in Re > 0 the zeros and orders agree with χ*; ψ(u,χ) − ψ(u,χ*) ≤ log₂u · log q.
- Trivial character: [χ = 1] ⇔ [χ* = 1]; the pole point s = 1 is excluded by Re ρ < 1.
- Boundary |γ| = T versus < T: handled, the difference is O(u·log(qT)/T).
- Junk values: none bite. log(q·u·T) ≥ log 4 > 1, u > 0 so u^ρ is the usual power, ρ ≠ 0, the finsum is over a set proved finite, and ord is the true multiplicity since L is analytic and not identically zero off s = 1.

2. ROUTE (all read in full, all genuine derivations)

- Perron kernel, GI/TruncatedPerronKernel.lean:346: |(1/2π)∫_{−T}^{T} y^{c+it}/(c+it) dt − 1_{y>1}| ≤ 3·y^c·min(1, 1/(T|log y|)). Proved by Cauchy on rectangles pushed to ±∞ plus a direct bound near y = 1. Correct.
- Truncated Perron for ψ(u,χ), GI/TruncatedPerronPsi.lean:436: error C(u·log²u/T + log u) at σ = 1 + 1/log u, any χ mod q. Dominated-convergence interchange, far terms via ζ(1 + 1/(2 log u)), near terms via weights 1/|n − ⌊u⌋|. Correct; I rechecked the constant 240.
- Residue theorem on a rectangle with finitely many poles of order ≤ 2, GI/BdIntEqZeroOfPrimitive.lean:142: subtract principal parts, Mathlib Cauchy–Goursat, explicit log primitives on slit planes. Correct, including orientation.
- Residue identity on [−1/2, c] × [−T, T], GI/AnalyticAtDslope.lean:189: residues u·[N=1], −ord·u^ρ/ρ, −(m·log u + h(0)) at s = 0. The only zero with −1/2 < Re ≤ 0 is s = 0, via GI/CompletedLFunctionNeZeroOfReNonpos.lean:86 (zeros of primitive L in Re ≤ 0 are simple, at −n). Correct.
- Good height, GI/ExistsBoundRight.lean:150 (outside my list, read fully): T' ∈ [T, T+1] with L ≠ 0 and |L'/L| ≤ C·log²(NT) on −1/2 ≤ Re ≤ 3, |Im| = T'. Pigeonhole over ordinates near both +T and −T, then the local partial-fraction formula. Correct.
- Left line, GI/PerronIntegralShiftPrimitiveLFunction.lean:47 and :143: |L'/L(−1/2 + it)| ≤ C·log(N(|t|+2)), integral ≤ C·log(N(T'+2))·log(2T'+1). Correct.
- Behaviour at 0, GI/LogDerivLFunctionNearZero.lean:104: L'/L = m/s + h, m ≤ 1, |h(0)| ≤ C(log 2N + Σ_{|γ|<1} ord/|ρ|). Correct.
- Contour shift, GI/PerronIntegralShiftPrimitiveLFunction.lean:227. Correct.
- Unit-window zero count, GI/FinsumMemLeOfSubset.lean:43, and band T → T', GI/FiniteBox.lean:96. Correct.
- Assembly: GI/TruncatedExplicitFormula.lean:11; open versus closed height, GI/ExplicitFormulaClosed.lean:44; Σ 1/|ρ| bounds, IW/SumIndicatorLeZsumR.lean:82 and recip_bound at GI/ExplicitFormulaDirichletZerosRightHalf.lean:27; ρ ↔ 1 − ρ symmetry, IW/DirichletLZeroSymmetry.lean:79; primitive reduction, IW/LogDerivSeriesOfExplicit.lean:321; final combination at :204.

The chain is sufficient in ordinary mathematics for the top theorem.

3. FLAGGED ITEMS (none affects soundness)

- No `sorry`, `axiom`, `decide`, `native_decide`, `unsafe`, `open private`, custom macros/elabs, `run_tac`, or large literals in any file read. The only `set_option` is `maxHeartbeats 1000000`.
- The four *Statement.lean wrappers are proved by `first | exact @X | exact X | (intros; apply X <;> assumption)`. Benign restatement, but it is the one "too short" pattern.
- GI/TruncatedPerronPsi.lean:436 carries an unused hypothesis T ≤ 2u.
- `GlobalTheory.T.norm_psi0_add_zsum_le` (GI/ExplicitFormulaClosedStatement.lean:8) does not assert C > 0; the caller uses |A|.
- Names are misleading: the von Mangoldt function is `abelian₂` and `psi0` lives in /home/user/cocosgt/riemann-hypothesis-lean/src/Formalism/SharpRestriction/GlobalSchurBounds/GeneralLinearActions/FiltrationCocycleLiftCriterion.lean. The definitions themselves (zerosBox, ord, zerosIn, zmult, zsum, zsumR, psi0, ZeroCount) mean what they should.
- Several small lemmas are proved twice in different files (analyticOff, exists_entire, finite_zeros, order_ne_top).
- Mathlib names I could not check: `riemannZeta₁`, `riemannZeta_eq_inv_sub_mul`, `deriv_riemannZeta_eq_neg_inv_sub_sq_mul_add`, `LFunctionTrivChar₁`, `IsPrimitive.completedLFunction_one_sub`. Usage is consistent with the obvious meanings.

4. COVERAGE

160 declarations of the 24 files are in decls.tsv: roughly 120 named theorems/defs plus about 40 auto-generated auxiliaries. All named ones checked: true and standard, or true technical lemmas. None in the categories cannot tell, false, or vacuous.

Read fully: 22 of the 24 cluster files, plus ZerosDisc.lean and Definitions/Foundations/RayPrimes.lean. Partly read:
- IW/LogDerivSeriesOfExplicit.lean: only the two declarations in the closure (sum_not_coprime_le, norm_sub_primitive_le); the rest is not in the closure.
- FiltrationCocycleLiftCriterion.lean: read, only psi0 and abelian₂ matter.

Outside the cluster, read fully: GI/ExistsBoundRight.lean, GI/LogDerivLFunctionStrip.lean, IW/DirichletLZerosInWindowFiniteAndPosOrder.lean.

Dependencies judged on statement only, proofs NOT read (other reviewers):
- `ZeroGapNearOne.exists_gap` (GI/ExistsDirichletLFunctionZeroGapNearOne.lean:69): every zero with |Im| ≤ 1, any χ mod q, has 1 − Re ≥ c/(q²·log 3q). True, and weak. This is the sole source of the q³; the top theorem depends on it essentially.
- `GlobalTheory.Lin.zeros_eq_zeros_primitiveCharacter`: zeros and orders of χ and χ* agree for Re > 0. True.
- `LogDerivZeros.main` (GI/NormOneSubConjMul.lean:125): Landau's lemma on the unit disc. True.
- `norm_LFunction_le_poly_left`: |L(s,χ)| ≤ C·q⁴·(|s|+2)⁴ for Re ≥ −7/4, χ ≠ 1, imprimitive included. I checked the exponents by hand; true.
- `ZetaLeft.norm_sub_one_mul_riemannZeta_le`: |(s−1)ζ(s)| ≤ C(|s|+2)⁵ for Re ≥ −7/4. True.
- `LLower.norm_LFunction_ge`: (σ−1)/σ ≤ |L(s,χ)| for σ > 1. True.

`LWide.logDeriv_LFunction_strip` is stated for all χ ≠ 1, not only primitive ones. That is still true (the imaginary-axis zeros in the disc number ≪ log q), and this cluster applies it only to primitive χ.
