<!-- Report of an automated reviewer (a Claude subagent) asked to referee this part of the draft. Unedited. Items marked [V] were derived by the reviewer; they have not all been independently re-checked. -->

REFEREE REPORT: Ch. 9 §9.1–9.2 (lines 23655–25139) and Appendix B (35280–39568)

Line numbers refer to layout.txt. "Verified" means I re-derived it myself; "reported" means read only.

## 0. Summary
- §9.1–9.2 is weighted-L² theory. The headline facts are correct for compact I: evaluation of order m on a boundary line is continuous iff m < (s−1)/2, every order is continuous in the interior, and the dual is L² with the inverse weight.
- Five proofs in §9.2.2 are placeholders, the floor formula fails for odd integer s, and unbounded I is not well defined.
- The idelic explicit formula (Thm B.4.4.7) has correct normalisations; I checked it term by term against the classical formula for F = Q. The draft does not prove it: it cites Weil.
- The draft's own "classical" version (Thm B.4.2.2) is wrong as printed at the Archimedean places.
- B.5–B.7 claim nothing beyond classical results.

## 1. Inventory

**Part I**

| Item | Content | Proof |
|---|---|---|
| Def 9.1.1.1, Lem 9.1.1.2, Prop 9.1.1.3, Lem 9.1.1.5 | H_w^s(G) = L²(Ĝ,(1+w²)^{s/2}); Hilbert; embeddings; dual is H_w^{−s} | full |
| Def 9.1.2.1, Lem 9.1.2.2 | W^{s,2}(G), weight (1+log²\|g\|)^{s/2}; for s = 2N equivalent to N derivatives on the dual side | full |
| Lem 9.1.2.4, Prop 9.1.2.5, Prop 9.1.2.6 | weight^{−1} ∈ L¹ iff s>1; \|g\|^{it}log^m\|g\| ∈ W^{−s,2} iff m<(s−1)/2; W^{s,2} ⊂ L¹ for s>1 | full, correct |
| Def 9.2.1.1, Thm 9.2.1.2, Cor 9.2.1.3–4 | b-line spaces; Paley–Wiener I; evaluations | full, with slips |
| Thm 9.2.1.5, Cor 9.2.1.6–7 | same for G | reduction sketch |
| Prop 9.2.1.8 | duality for W_I^s(R_{>0}) | full |
| Def 9.2.2.1, Lem 9.2.2.2, Def 9.2.2.3 | W_I^s, HS^s(C_I) | 9.2.2.2(3) "similar" |
| Prop 9.2.2.4, Cor 9.2.2.5, Thm 9.2.2.6, Cor 9.2.2.8, Lem 9.2.2.10 | Mellin isomorphism; evaluations; Paley–Wiener III; G-version | one line each, footnote "Return here." (24868, 24869, 24921, 24980, 25049) |
| Prop 9.2.2.11, Cor 9.2.2.12, Thm 9.2.2.13 | duality II; evaluations; Paley–Wiener IV | "analogous" (25053) or by reference |

**Part II**
- B.1.1.1–B.1.1.3 (convexity bound): full. Author notes at 35544–46.
- B.2.1.4–B.2.1.10, B.2.2.3, B.2.2.4, B.2.2.6: full. Notes at 35602–06, 35657, 35772, 36259–62.
- B.3.1.1, B.3.1.2, B.3.2.1: full.
- B.4.1.1, B.4.1.2, B.4.1.9: full. B.4.1.7: full but false.
- B.4.2.1: sketch by reference to Barner. Note 14 (37109): "Brian still needs to check proof". B.4.2.2: two lines. Note 15: "should double-check".
- B.4.3.1: full (broken citation "[?" at 37194). B.4.3.2: citation to Connes; note 16 (37287): "recheck… factors of 2 and 2π".
- B.4.4.1–B.4.4.5: notes 17–24 (37288–37301, 37370–71, 37648).
- B.4.4.8–9: notes 25–26 (37711–12). B.4.4.7: note 27 (37784): "Must explain… how to obtain this identity from Theorem B.4.2.2".
- B.5: full; "Chapter ??" at 37800, note 28 (38262).
- B.6.1.1: cited. B.6.1.3–7: full. B.6.1.8: sketch, note 29 (38867). Truncated sentence at 38738.
- B.7: full; note 30 (39209).

## 2. Part I against my own computation (G = R_{>0}, M φ(z) = ∫φ t^z dt/t)

**The spaces.**
- I = {b}: W = L²(t^{2b}(1+log²t)^{s/2}dt/t), and M maps it onto the Sobolev space of order s/2 on the line b+iR. Nothing is holomorphic.
- I = [a,b], a<b: max(t^{2a},t^{2b}) ≍ t^{2a}+t^{2b}. So W_I^s is the Hardy space of the strip whose boundary values on both lines have s/2 derivatives.
- Inside the strip every weight t^{2σ}log^{2k}t is dominated, so all derivatives are L² on interior lines, but only s/2 uniformly up to the boundary. The draft's description is right.

**Correct (verified).**
- Interior evaluations of all orders (Cor 9.2.2.5(1), 9.2.2.8(1), 9.2.2.12(1)).
- Boundary criterion m < (s−1)/2. For Re z₀ = b the dual norm is finite iff ∫₁^∞ x^{2m}(1+x²)^{−s/2}dx < ∞; the other end converges through t^{2(b−a)}.
- Duality (Prop 9.2.1.8, 9.2.2.11): W_I^{−s} = L²(w_{I,s}^{−1}). The statement says T ↦ w^{−1}T while the proof says ψ₀ = wψ; harmless.
- Density and closure claims (9.2.1.2(1), 9.2.2.6(1)): trivial in weighted L².
- The "Paley–Wiener condition" (9.2.1.7)/(9.2.2.28): entire with φ(s) = O(((1−a^{−2Re s})/Re s)^{1/2}). This does characterise Mellin transforms of L²[1/a,1]. The converse step "a^sφ ∈ H²(C_{<b})" (24379) is asserted without the Phragmén–Lindelöf argument.

**Floor formula.**
- The count of m ≥ 0 with m < (s−1)/2 is ⌈(s−1)/2⌉. It equals ⌊(s−1)/2⌋+1 unless s is an odd integer.
- Cor 9.2.2.5(2) and Cor 9.2.2.12(2), stated for real s as "0 ≤ k ≤ ⌊(s−1)/2⌋", are false for odd s.
- Counterexample (s=1, k=0): φ_n = t^{−z₀}(1+log²t)^{−1/2}/log(2+|log t|) on |log t| ≤ n has bounded norm, and its pairing grows like 2 log log n.
- Cor 9.2.2.8(2) (s even) is correct.
- The same defect sits in (10.2.1.6), (10.2.2.5), (10.3.1.4), (10.3.2.4), (10.4.3.9), (10.4.3.38), (11.2.0.6), (11.2.2.5). The introduction (lines 402, 2326) writes "max{N(ρ), ⌊(s−1)/2⌋}", contradicting all of these.

**False or ill-defined.**
- Lines 24685–24697 claim that H^{2N,2}(C_{<b}), with the topology of L² convergence on interior lines, is complete and equals the norm topology by the open mapping theorem. False: φ_n = t^{−b}1_{[n,n+1]} has Hardy norm² ≈ 1/n and σ-line norm² ≈ n^{2(σ−b)−1}. Also t^{−b}(1+log t)^{−1/2}1_{[1,n]} is Cauchy on interior lines with limit outside the space.
- Def 9.2.2.3 / Prop 9.2.2.4(1): "independent of {c_k} and Hilbertizable" is false unless ∂I ⊂ {c_k}. Otherwise the completion is a non-normable Fréchet space. The range of k is never specified.
- Def 9.2.2.1 / Lem 9.2.2.2(3) for unbounded I: the supremum is +∞ on S_E. For φ = exp(−log²t) the integral grows like e^{σ²/2}. So W_I^s, Prop 9.2.2.4(3) and the bottom row of (9.2.2.27) (HS^s(C_{I′}), I′ = (−∞, sup I]) are not well defined.
- Cor 9.2.1.3 and 9.2.1.6 are stated for arbitrary φ ∈ W_b^{2N,2}, where M φ need not be holomorphic on C_{<b}. The proof silently assumes support in [1/a,∞).
- Cor 9.2.1.4's proof says ∂_s is a continuous endomorphism of HS^{2N,2}. It is not; the conclusion is still true.
- Def 9.2.1.1 uses 0≤k≤N−1 in (1) and 0≤k≤N in (2); the proofs use N. Cor 9.2.2.8 never names the space.
- Translation norm bounds: none stated in the range, only equivariance (Prop 9.1.2.5). The true bound is ‖ρ(h)‖ ≤ 2^{s/4}max(|h|^a,|h|^b)(1+log²|h|)^{s/4}. So the action is not uniformly bounded, even on W^{s,2}.

## 3. B.4: explicit formula

**Thm B.4.4.7 (37611).** For φ ∈ D(C_F), with no condition at norm 1:

Σ_{c: L(c)=0} μ₁(C_F¹)^{−1}∫φ c|g|^{−1/2}dμ = μ₁(C_F¹)^{−1}[∫φ|g|^{−1/2}dμ + ∫φ|g|^{1/2}dμ] − Σ_{v|∞} M_v^{−1} ∫′ φ|g|_v^{1/2}/|1−g|_v dμ_v − Σ_{v<∞} (log q_v/μ_v(O_v^×)) ∫′(same),

with M_v = 2 (real), 2π (complex). Here ∫′ is Connes' principal value relative to the standard additive character, which absorbs φ(1)log|d_F|. Absolute convergence is claimed. The zero sum is written without multiplicity.

**Verified.**
- Finite places: (log q_v/μ_v(O_v^×))μ_v is Weil's measure. The m≠0 terms give log q_v·q_v^{−|m|/2}. The m=0 term gives log N(f_χ): on a character of conductor exponent a, ∫_{O^×}(χ−1)/|1−u| = −a. The discriminant shift (B.4.4.14) is right, including the vanishing on 1_{O^×} (note 24's computation, for d=0).
- Real place: for F = Q, f = φ·x^{−1/2}, the term (1/2)∫′ equals exactly (log 4π+γ)f(1) + ∫₁^∞[f(x)+x^{−1}f(1/x)−(2/x)f(1)]x dx/(x²−1).
- Complex place: kernel and constant 2(log 2π+γ)φ(1) agree with ψ = Γ′/Γ.
- Global terms: the factor 1/μ₁(C_F¹) is right, since the Mellin transform of the χ-component is μ₁(C_F¹)^{−1}M φ.

**Defects.**
1. Prop B.4.3.2 is false as a statement about the Fourier transform of log|x|_v. Homogeneity forces coefficient 1/2 (real) and 1/2π (complex) on the finite part; the draft has 1, off by M_v. Def B.4.4.1 for v|∞ omits the factor M_v that its finite-place analogue has. The two errors cancel, so (B.4.4.16) is right.
2. Thm B.4.2.2 (37090), as extracted:
   - no δ_χ on the pole terms, so false for χ nontrivial on C_F¹; (B.4.2.2) does have δ_χ, but with poles at 0, 1 even for χ = |·|^{−it₀};
   - the Archimedean integrand lacks Barner's factor e^{−(2/N_v)x}: ∫^∞ N_vφ(1)/x dx diverges when φ(1)≠0, and the kernel is e^{(2/N_v)x} too large;
   - A_χ = |d_F|N(f_χ) omits 2^{−2r₂}π^{−n}, so −(r₁log π+2r₂log 2π)φ(1) is missing.
   Supporting slips: (B.4.2.3) has both signs wrong although (B.4.2.4) is right; (B.4.2.12) has the wrong sign of α_v; (B.4.2.16) drops 1/a_v. The pole, log A_χ and finite-prime terms are correct.
3. Lemma B.4.1.7 is false. The single-line integral equals log N(p)Σ_{m≥1}χ(p^m)φ(N(p)^m), not the sum over m ∈ Z. Take φ ∈ C_c^∞ near 1 with φ(1)=1: the left side is log N(p), the integral is 0. The proof applies B.2.2.4(2) to a Φ that is not bounded on a half-plane, and asserts ∫_{(a)}Φ ds = 0 (it is 2πi φ(1)). By grep it is not cited outside its own subsection.
4. The proof of B.4.4.7 is a citation to [Weil-e §16] plus matching of principal values; the link to B.4.2.2 is missing (note 27).
5. Lemma B.4.4.8 is false as stated: a discrete Z in a strip can have arbitrarily many points per unit height (the authors' note 25 says so). Lemma B.4.4.9 is true but needs N(T,χ) ≪ T log(C(χ)T) with polynomial dependence on the conductor, summed over the infinitely many characters of C_F¹/k. This is not supplied.

**Other statements of the formula (reported).**
- Thm 12.4.1.1 uses the same local expressions and factors (1/2, 1/2π, log q_v/μ_v(O_v^×)).
- Thm 12.5.1.1 uses the same local side and sign (local = poles − zeros), but M(φ)(c) := ∫φ c dμ carries no 1/μ₁(C_F¹). This contradicts (B.4.4.16) unless μ₁(C_F¹)=1, which Remark 9.2.0.1 says is not the normalisation.
- In 12.5.1.1, I is unquantified in the statement, the sum runs only over zeros in the interior of the I-strip, and the hypothesis is φ(C_F¹)=0.
- Thm 13.3.1.1 drops 1/M_v, 1/μ_v(O_v^×) and 1/μ₁ altogether (footnote "Correct statement.").
- B.4.4.7 is never cited by label outside Appendix B, and §13.1–13.2 are empty headings.

## 4. B.2, B.3, B.5–B.7
- **B.2.2.4(1), B.2.2.6:** correct.
- **B.2.2.4(2):** false under the literal Def B.2.2.1, which asks for decay only for large |y|. Counterexample: Φ(s) = E(c−s)exp(−(b+1−s)^{1/2}), with E a Mittag-Leffler-type entire function bounded outside a half-strip and ≈ exp(e^w) inside. It is true with Φ ∈ H²(C_{<b−ε}), which the proof uses silently (note 10).
- **B.3.1.1 / B.3.1.2:** the definition gives only T_k = O(|k|^α), but the proof needs |T_k| ≥ c|k|^γ (it writes |T_k|^{−N} ≤ A|k|^{−Nγ}; the γ, δ there do not match the α, β of the definition). The fix is to bound f by |T_k|^β. It is harmless when T_k ∈ (k,k+1).
- **B.3.2.1:** Σ Φ(ρ)Res_ρ f is wrong for non-simple poles (f = 1/s², Φ′(0) ≠ 0); it should be Res_ρ(Φf). This matters wherever it is applied to Φ/L with multiple zeros (e.g. line 17923). Rectangles use ±T_k without assuming symmetry. Only convergence along T_k is proved.
- **B.5:** Kronecker–Weyl is standard. B.5.3.2–3 (finite Euler product bounded below along a sequence on iR) is correct and elementary; the remark "s = 0 ∈ K" fails if 0 is a zero of the product, but it is fixable by a shift.
- **B.6:** the zero-free region is from Iwaniec–Kowalski Thm 5.10. The second clause of B.6.1.1 (a real zero anywhere in [1/2,1] forces χ quadratic, unique, simple) is not known; it holds only inside the region. Unused downstream. L′/L(1+it) = O(log²t) and 1/L(1+it) = O(|t|^N) are correct and weaker than known. B.6.1.7 is the Titchmarsh 9.7 analogue and correct, but uses the convexity bound outside [0,1] (author note 2). B.6.1.8 (derivatives) is a sketch, fixable by also keeping |t−γ| ≥ c/log T.
- **B.7:** convergence of Dirichlet polynomials and Euler products on Re s = 1, locally uniformly away from the pole, and Mertens. Classical, essentially complete. Nothing uniform in t is claimed. Minor: the residue is given as N(d)^{−1/2}μ₁(C_F¹) in (B.6.1.7) and as μ₁(C_F¹) in (B.7.2.25).

## 5. Ranked problems
1. **(B)** Explicit formula not proved in the draft: B.4.4.7 rests on citing Weil; B.4.2.2 is unverified and wrong as printed; the bridge is missing. The formula itself is correct.
2. **(A/C)** Three mutually inconsistent normalisations: (B.4.4.16), (12.5.1.1), (13.3.1.3–5). Only the first matches the classical formula. I is unquantified in 12.5.1.1.
3. **(A)** Thm B.4.2.2 Archimedean term, constants and δ_χ.
4. **(D)** Five "Return here" proofs in §9.2.2, covering the evaluation and Paley–Wiener statements actually used later. For compact I the statements are true by elementary arguments.
5. **(A)** Floor formula for odd integer s (§2 list).
6. **(A)** Lines 24685–24697 (Hardy norm vs interior-line topology). **(C)** Def 9.2.2.3 / Prop 9.2.2.4(1), and unbounded I.
7. **(A)** B.3.2.1 residue formula for multiple poles. **(B)** B.3.1.2 lower bound on T_k.
8. **(A)** Lemma B.4.1.7 (unused). **(A)** B.2.2.4(2) under the literal hypothesis. **(A)** Lemma B.4.4.8; **(B)** B.4.4.9.
9. **(A, compensating)** B.4.3.2 factors of M_v against Def B.4.4.1.
10. **(A, minor)** Cor 9.2.1.3/9.2.1.6 missing support hypothesis; B.6.1.1 second clause; B.1.1.3 "constant independent of ε".

## 6. Verified versus reported
- **Verified by my own derivation:** everything in §2; the F = Q comparison and all local normalisations in §3; the counterexamples in §4–5; the 3-4-1 argument of B.6.1.6; the error terms in B.7.1.2.
- **Reported only:** the Kronecker–Weyl proof; Titchmarsh's Lemma α step in B.6.1.7; the Perron lemma B.7.1.1; the statements of Chapters 10–13.
- **Could not determine:** the exact typeset form of (B.4.2.15). The extraction is ambiguous, but under either reading of the exponent the kernel is wrong and the integral diverges for φ(1) ≠ 0.
- **Could not determine:** whether Chapter 12 silently renormalises μ.
- **Recalled, not checked against a source:** Barner's trailing factor and Lang's A_χ. My derivation from Gauss's formula for ψ is independent of them.
