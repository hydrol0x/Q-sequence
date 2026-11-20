<!-- Report of an automated reviewer (a Claude subagent) asked to referee this part of the draft. Unedited. Items marked [V] were derived by the reviewer; they have not all been independently re-checked. -->

# Referee report: Appendix A (lines 32349–35280)

**Verdict.** A.1–A.4 are essentially sound, with local errors. A.5 has two false statements that matter downstream: the "standard D′-sequences" are not D′-sequences, and Corollary A.5.4.3 is false at individual points. The abstract maximal and differentiation theorems are true, but two of the written proofs are invalid. I read A.2.3, A.4 and A.5 in full and A.1 and A.3 closely. I could not consult [HR-2], [Schm], [RV] or [Bris-a], so every "cited" result is reported, not verified, unless I say I re-proved it.

## 1. Inventory

**A.1 (all proofs omitted by declaration, 32432).**
- Def A.1.1.1, Lem A.1.1.2: restricted products and their topology. Index set written "I₀×I₁"; should be a disjoint union.
- Def A.1.1.3, Lem A.1.2.1: F discrete and cocompact in A_F; A_F/F ≅ (F_∞×Ô_F)/O_F.
- Def A.1.3.1, Lem A.1.3.3–4: idele topology, idelic norm, F^× discrete, norm has a section.
- Def A.1.4.1, Thm A.1.4.3: C_F, compactness of C_F¹, unit rank, finiteness of Pic.
- Lem A.1.5.1, Thm A.1.5.2, Rem A.1.5.3: S-analogues, with C_{F,S} := (∏_{v∈S}F_v^× × ∏_{v∉S}O_v^×)/O_{F,S}^×.

**A.2.**
- Def A.2.1.1, Lem A.2.1.2 (no proof), Ex A.2.1.3: additive domain D_F = D_{F,∞}×Ô_F.
- Lem A.2.2.1–9: three sections of the norm, and GL₁(A_F) ≅ R_{>0}×GL₁(A_F)¹. Only A.2.2.6 has a proof.
- Def A.2.3.1–Lem A.2.3.5 (no proofs): logarithm map L, regulator lattice, half-open parallelotope P.
- Def A.2.3.6: E₀ = L⁻¹(P) ∩ {arg g_{v0} ∈ [0, 2π/w_F)}, and E_F¹ = ⋃ gᵢ(E₀×Ô_F^×).
- Lem A.2.3.8 (full proof), Prop A.2.3.9 (none), Prop A.2.3.10 (proof): E_F¹ is relatively compact, has non-empty interior, is a strict fundamental domain for F^× on GL₁(A_F)¹, and is locally finite.
- Lem A.2.3.11–13: the section title names a domain "E_F", which is never defined.
- Def A.2.4.1–Rem A.2.4.5: S-analogues. Prop A.2.4.4 has no proof ("closely analogous").

**A.3.**
- Def A.3.1.1–2, Lem A.3.1.3: ν(A_F/F)=1; ν_v = dx, 2dxdy, ν_v(O_v)=N(𝔡_v)^{-1/2}. The proof covers the global case only.
- Lem A.3.1.4 (cited), Ex A.3.1.5–11.
- Def A.3.2.1–2, Lem A.3.2.3 (proof), Lem A.3.2.4 (cited "[RV, Thm 7.21]"): μ=⊗μ_v with μ_v = ν_v/|·|_v at infinite places and μ_v(O_v^×)=N(𝔡_v)^{-1/2}; μ₁(C_F¹)=2^{r₁}(2π)^{r₂}hR/(|d_F|^{1/2}w).
- §A.3.3, Def A.3.4.1, Rem A.3.4.2: S-local measures.

**A.4.** Thm A.4.1.1 with Claim A.4.1.2: full proof, citing [Schm, Lemma 1].

**A.5.**
- Thm A.5.1.1, Thm A.5.1.3: real-line maximal and differentiation theorems, proofs partly by citation.
- Def A.5.2.1: D- and D′-sequences. Prop A.5.2.3, Lem A.5.2.5 (products): proved.
- Prop A.5.2.6 (transfer between G and G/H through a fundamental domain): proof incomplete.
- Thm A.5.2.8 (cited), Lem A.5.2.10 (proof).
- Lem A.5.2.12–17, Def A.5.2.18, Rem A.5.2.19: "standard D′-sequences" on idele and class groups. Proofs are one-liners.
- Thm A.5.3.1 (cited HR 44.11), Lem A.5.3.3, Thm A.5.3.4–7: proof sketches following HR.
- Thm A.5.4.1 (proof), Cor A.5.4.3 (proof).

**Author and reviewer notes: 25 footnotes.**
- 33536: "Double-check for the S-local case."
- 33720: "Brian suggested … should be rewritten … reread … to check if now OK."
- 33897: possible remark on a paper of Connes.
- 34144, 34268, 34269, 34411, 34412, 34471: labels, "Means what?", missing explanations.
- 34723, 34724 ("This misses 1 (which has argument 0)!"), 34725 ("Need to define Q_k").
- 34878, 34928, 34930, 34931, 34985 ("Why? Must say more."), 34986, 35042, 35043, 35159, 35210, 35211, 35267, 35269.

Also: "Let F be a hyperplane" (33017), "The subset E" (33248), "two applications" announced in A.4 but only one given.

## 2–3. The four downstream uses

**(i) Fundamental domain.**
- Verified: Prop A.2.3.10 is correct, including for Q (E_Q¹={1}×Ẑ^×), imaginary quadratic (an arc times Ô^×) and real quadratic fields.
- Verified but not stated in A.2.3: E_F¹ is Borel, and its boundary is null (it lies in L⁻¹(∂P) ∪ {arg = endpoints}). Line 28891 infers Borel from "relatively compact with non-empty interior", which is a non sequitur.
- Connectedness is impossible. Remark 12.2.1.4 (30676) asks for a connected D with non-empty interior. A connected subset of GL₁(A_F) projects to a point of the totally disconnected, non-discrete finite ideles, so it has empty interior. E_F¹ and τ(R_{>0})E_F¹ contain the factor Ô_F^×; E₀ is already disconnected for real quadratic F.
- 1 is not interior to E_F¹ unless F=Q (it is a corner of P). A.5 therefore switches to the centred domain B_F¹.
- Units outside S: E_F¹ lies in ∏_{v∈S}F_v^×·∏_{v∉S}O_v^× only if the gᵢ are chosen supported in S. That is possible exactly when Pic(O_{F,S})=1, and the appendix does not make this choice.
- The S-version is muddled. Def A.2.4.3 (33382) and Lem A.5.2.12(3) take representatives of Pic(O_{F,S}) inside GL₁(A_{F,S})¹×∏_{v∉S}O_v^×, every element of which has trivial class. Prop A.2.4.4(4) is then false for h_{F,S}>1.
- Rem A.2.4.5 is false as written. For F=Q, S={∞}: O_{F,S}^×·E¹ = {±1}×Ẑ^× ≠ GL₁(A_Q)¹. It needs F^× in place of O_{F,S}^×. For h_{F,S}=1, E_{S,0}×∏_{v∉S}O_v^× is a correct domain (verified).

**(ii) D′-sequences and differentiation.**
- Lem A.5.2.13(2) is false for every F. U_{S∞,k}:=L⁻¹(P_k) contains ker L = {±1}^{r₁}×U(1)^{r₂} for all k, so the sets do not shrink to 1.
- Example F=Q: U_{F,k}={±1}×B_k, and its image in C_Q¹=Ẑ^× is B_k∪(−B_k). For f=1_{B_m} with −1∉B_m, the averages at x∈B_m equal 1/2, not f(x)=1.
- Reading L⁻¹ as a positive-real section rescues only totally real F; with a complex place the sets are null.
- Lem A.5.2.14–17, Def A.5.2.18 and the constant A^{r₁+r₂−1} of Rem A.5.2.19 inherit the failure. The true dimension is r₁+2r₂−1.
- Further defects in the same lemmas:
  - "U_{S,k}⊂B¹_{F,S}" (34716) is false.
  - (1−1/k, 1+1/k) is undefined at k=0, has infinite dt/t-measure at k=1, and is never symmetric.
  - Prop A.5.2.6 needs a relatively compact E, which τ(R_{>0})·B is not.
- All of this is repairable with genuinely shrinking neighbourhoods and the product decomposition.
- Prop A.5.2.6 is true (verified), but its proof asserts doubling for q⁻¹(U_k)∩E without argument. Missing step: W_kW_k⁻¹ ⊂ q⁻¹(U_kU_k⁻¹)∩EE⁻¹, and EE⁻¹ meets finitely many H-translates of E.
- Maximal theorems: A.5.3.1 re-proved by greedy selection. A.5.3.4–7 are correct in substance, and I re-derived the constants 2C/α and Cp^{p+1}/(p−1)^p. Measurability is unaddressed (fn 14, 16, 19).
- (A.5.3.11) is false as printed: f≡1 gives μ(K) ≤ μ(K)/2. The qualitative conclusion stands.
- Thm A.5.4.1(2),(3) are true. I checked them by C_c-approximation plus weak (1,1). The written proofs are invalid:
  - (1) "Uniformly continuous" is false (G=R, f=e^{y²}), and the argument given proves nothing.
  - (2) uses "μ(∂U)=0 for open U of finite measure" (35219–21), which is false (complement of a fat Cantor set).
  - (3) uses "compactly supported ⇒ in L^p for all p" and "‖u_k‖_q=1" (35222, 35231). Both are false.
- Cor A.5.4.3 is false as stated ("at all points where the limit exists"). The proof drops the factor 1/μ(U_k) in (A.5.4.16).
  - Counterexample on R at x=0, near 0: f=sgn(y)/(|y|log²(1/|y|)) and φ=sgn(y)·log(1/|y|)^{-1/2}, with φ(0)=0.
  - Then A_k f(0)=0 for all k, while A_k(φf)(0)=(2/3h)·log(1/h)^{-3/2}→∞.
  - The corollary holds wherever sup_k A_k(|f|)(x)<∞.
  - It is used pointwise on the null diagonal at 30243, 30287–91 and 30960–68, which is exactly where the "a.e." version gives nothing.
- U_k×U_k: Lem A.5.2.5 is correct, so differentiation holds a.e. on G×G. That says nothing on the diagonal. Thm 12.1.1.2 needs, and A.5 supplies once the sequences are fixed, the strong (2,2) inequality and differentiation on G. The Brislawn step itself is only cited there.

**(iii) S-unit count.**
- Thm A.4.1.1 is true. My proof: the count is w_F times the number of lattice points in {x∈H: x_v≤a_v}, a simplex of size −log|g|; it is bounded by vol(K+fundamental cell)/det, uniformly in g.
- Cosmetic defects in the written proof: (A.4.1.6) omits w_F; (A.4.1.7) is type-inconsistent; the planar-angle argument is loose; ε/εᵢ and M₁/Mᵢ are mixed.
- Scope: it covers only u = box indicator and |g|<ε. That is all line 6204 uses. The bound for general f lies in Thm 2.4.2.1, outside my range.

**(iv) Measures.**
- Verified: μ_R = dx/|x| gives {±1} mass 2. μ_C = 2dxdy/|z|² = (dt/t)dθ gives U(1) mass 2π. μ_v(O_v^×)=N(𝔡_v)^{-1/2}. Lem A.3.2.3 is correct.
- Formula (A.3.2.1) checked for Q (=1), Q(i) (=π/4) and real quadratic fields (=2hR/√d).
- The appendix fixes the normalisations but never derives 1/2, 1/2π or log q_v/μ_v(O_v^×). With these conventions that last factor is log q_v·N(𝔡_v)^{1/2} at ramified v.
- R_F is written as the determinant of an (r−1)×r matrix; a column must be deleted.
- The S-local measure is defined inconsistently. Def A.3.1.1 gives ν_S covolume 1, while Lem A.3.1.3 claims ν_S=⊗ν_v, whose covolume is ∏_{v∉S}N(𝔡_v)^{1/2}. For Q(i), S=S_∞ this is 2. The sentence at 33864 has "unless" reversed.
- Def A.3.4.1(3) defines a measure "on C_{F,S}" from GL₁(A_{F,S})/O_{F,S}^×, which is J_{F,S} (defined only at line 6522), not the group of (A.1.5.7).

## 4. Ranked problems

1. **(A)** Lem A.5.2.13(2) and the standard D′-sequences. Fixable, but as written no differentiation theorem applies to the sets used.
2. **(A)** Cor A.5.4.3, with the counterexample above; used pointwise in Ch. 12. Repairable a.e. by maximal-function domination, which the text does not invoke.
3. **(B)** Proofs of Thm A.5.4.1(1)–(3); "uniformly continuous" is false. The statements (2),(3) are true.
4. **(C/A)** S-idelic fundamental domains: Def A.2.4.3, Prop A.2.4.4(4), Rem A.2.4.5, Lem A.5.2.12(3).
5. **(A, flagged by fn 1)** Lem A.3.1.3 in the S-local case; reversed sentence in Rem A.3.4.2; C_{F,S}/J_{F,S} conflation.
6. **(B)** Ex A.3.1.11 (fn 2). The argument puts the annihilator in the wrong group, claims O_{F,S} has finite index in it (it is ≅F), and reverses an inclusion. The statement Γ^⊥=O_{F,S} for S⊇Ram is true: Γ⊂Γ^⊥ and [Γ^⊥:Γ]=covol(Γ)²=1. Relatedly, Lem A.1.5.1's "A_{F,S}/O_{F,S} is a Q-vector space" is false (R/Z).
7. **(A)** "Connected" in Rem 12.2.1.4 is unsatisfiable for GL₁(A_F).
8. **(B)** Prop A.5.2.6 doubling step, and its misapplication to non-compact E.
9. **(A, minor)** Thm A.5.1.1(1) fails for f=x² (Mf≡∞ for L¹_loc); (A.5.3.11) constant.
10. **(C/D)** Ill-defined items: D_{F,∞} (A.2.1.1), R_F, E_F, D_f (Rem A.5.4.2), "lim sup_{k≥0}", index k=0. Lem A.2.3.8(1) requires a≠1 when r₁+r₂=1.

**Checked and found correct:** A.1 statements apart from the Q-vector-space remark; the three sections; Lem A.2.3.8; Prop A.2.3.9–10; Lem A.2.3.12–13; Prop A.2.4.4(1)–(3) (non-empty interior needs an argument, since L_S is not surjective); Lem A.3.1.3 (global); Ex A.3.1.6, A.3.1.7, A.3.1.10; Lem A.3.2.3; (A.3.2.1); Thm A.4.1.1; Prop A.5.2.3; Lem A.5.2.5; Lem A.5.2.10; Lem A.5.2.12(1),(2); Lem A.5.2.13(1); Thm A.5.3.1, A.5.3.4, A.5.3.5 (limsup version), A.5.3.7; Thm A.5.1.1(2),(3), where the printed constant is valid but not sharp.

**Could not determine:** the exact content of the HR, Schmidt and RV citations, and whether Chapter 12 uses the specific shape of U_k beyond the D′ axioms.

