<!-- Report of an automated reviewer (a Claude subagent) asked to referee this part of the draft. Unedited. Items marked [V] were derived by the reviewer; they have not all been independently re-checked. -->

# Referee report: Chapter 7, "Schauder Bases of Idelic Zeta functions" (lines 18196–22741)

**Verdict.** In the model case the single-prime statements are true in the fine Fréchet topology, but nearly tautological: the per-prime quotient is C^∞(R_{>0}/p^Z), independent of ζ and of the other primes in S. Chapter 7 gives Chapter 11 nothing in Hilbert/Sobolev norms, nothing as the number of primes grows, and nothing uniform in p beyond "multiplicity ≤ [F:Q]". Several proofs are unfinished or cite later chapters.

Tags: **[V]** = checked by my own argument; **[R]** = reported only.

**Notation.** H(S) := H_{0,cont}(χ|J¹_{F,S}, S(A_{F,S})), the χ-isotypic S-local θ-functions with quotient topology (nuclear Fréchet by Thm 5.2.3.1 [R]). H := H_{0,cont}(χ|C¹_F, S_0(A_F)), the global analogue with f(0)=f̂(0)=0. PV = Weil principal value operator.

**Model (F=Q, χ=1) [V].** H({∞,p,q,…}) ≅ S(R)_even via g ↦ Σ g(p^a q^b x), with Mellin transform G(s)/∏(1−p^{-s}). PV_p becomes g ↦ g − g(p·). The open mapping theorem gives the topological identification, assuming H(S) is Fréchet as claimed.

## 1. Inventory

**7.1**
- **Lemma 7.1.1.1** (18330): heights T_k → ±∞ with ∏_{v∈S_f}|1−q_v^{−σ−iT_k+it_v}|^{−1} ≤ N_S on σ∈[−δ,1+δ]. Full proof with defects (18439–18447: the reflection identity is false when the t_v differ; N_S := M−ε should be its reciprocal). True [V] by a measure argument, with bounded gaps, but N_S grows like C^{|S_f|}.
- **Def 7.1.2.1** (18477); **Lemma 7.1.2.2** (18500, poles of ρ_S; proof "by inspection").
- **Thm 7.1.2.3** (18560): expansion of Φ(f)(g) as |g|→0 over poles. Sketch. **Author footnote at 18816**: "check if Definition B.3.1.1 is actually applicable since no control on growth of |T_k|…".
- **Rem 7.1.2.4, 7.1.3.1; Thm 7.1.3.2** (18973, full proof); **Cor 7.1.3.3** (19070, sketch).
- **Thm 7.1.4.2** (19123): the functionals ∂^m at zeros of L(s,χ) span the annihilator of H in S_E(C_F)(χ)′, are "topologically free" (have a bi-orthogonal family) and equicontinuous. Full proof.
- **Thm 7.1.4.3** (19400): same with finitely many Euler factors removed. Proof: "formally analogous".

**7.2**
- **Thm 7.2.1.1** (19567): Laurent coefficients a_k(·,c) are continuous eigendistributions. Full.
- **Thm 7.2.1.4** (19742): formulas for a_k. Full.
- **Prop 7.2.2.1 / Cor 7.2.2.2** (19924, 19978): f ∈ PV_{S,S_0}H(S) ⇔ top Laurent coefficients vanish ⇔ global zeta has the corresponding zeros. Full, but leans on Thm 6.3.2.1.

**7.3**
- **Thm 7.3.1.2** (20038): bi-orthogonal family in H(S)/PV_{S,S_0}H(S). Full but internally inconsistent (§5).
- **Defs 7.3.1.3, 7.3.1.4; Lemma 7.3.1.5** (transfer of bases; trivial, hypothesis (iv) vacuous).
- **Thm 7.3.1.6** (20290): main basis theorem (§2). Long proof via diagram (7.3.1.20); the polar system is dispatched in one sentence (20710–20713).
- **Def 7.3.1.7; Cor 7.3.1.8** (cites the nonexistent "7.3.1.2(3)").
- **Def 7.3.2.1, Prop 7.3.2.2, Def 7.3.2.3, Prop 7.3.2.4**: Paley–Wiener levels. Full.
- **Prop 7.3.3.2** (21266): PV maps level X to level q·X. **The proof ends (21386) with "It remains to show that the sub-squares … are cartesian"** and stops.
- **Def 7.3.3.3; Thm 7.3.3.4** (21445, bases on PW levels, sketch); **Thm 7.3.4.1** (21841, Archimedean quotient ≅ ∏C; refers to the proof of 5.4.1.1).

**7.4**
- **Thm 7.4.1.1** (21949, spectral nuclearity). The author states at 21946 that it "will never be used". Sketch.
- **Thm 7.4.2.1** (22021). Four-line proof citing a nonexistent "Proposition 7.1.4.3" and "(11.2.2.12) of Theorem 11.2.2.1".
- **Thm 7.4.3.1** (22058). Contains "We will be granting for the moment…" (22197) and "It remains to show…" (22264); broken sentence at 22139.
- **Thm 7.4.3.2** (22334); **Rem 7.4.3.3**.

**7.5**
- Declared "not logically necessary" (22418).
- **Thm 7.5.0.1** (22446), **Cor 7.5.0.3** (22728). Sketch; equation labels inside the proof are (8.1.0.x).

**Stale references:** 18626, 20783 ("Chapter 7"), 21244 ("10.4.3.27 of Chapter 6"), 22291/22304.

## 2. Definitions and topologies

- **Polar multiplicity** m_S(f,c) = pole order of Z_S(f,·) at c; m_S(c) that of ρ_S; m_{S_0}(c), N_{S_p}(c) = number of places in S_0, S_p whose local factor has a pole at c.
- **Orbital quotient** (7.3.1.5): E_{S,S_p} := H(S)/PV_{S,S_p}H(S), quotient Fréchet topology. Global version (7.4.0.2): H/PV_{S_p}H. Archimedean (7.3.4.3): PV_{S,S_f}H(S)/H_{0,cont}(S_00).
- **Bases** (Thm 7.3.1.6):
  - Polar system P = {a_k(·,c): m_S(c)−N_p(c) < k ≤ m_S(c)}.
  - Fourier system E = {δ̂_c^{(k)}: f ↦ ∂_s^k Z_S(f̂, χ|·|^{1−s})|_{s=s_c}, 0≤k<N_p(c)}.
  - Both are claimed to be unconditional Schauder bases of the strong dual, with bi-orthogonal families absolute bases of E_{S,S_p}.
  - Polynomial growth (4) and rapid decay (5) are claimed only for the Fourier system.
- **Absolute PW level** PW_{S,X}: closure in H(S′), S′ = S∪S_0, of θ-functions of f⊗(unramified vector on S_0) with f̂ supported in the box {|x_v|_v ≤ X, v∈S}. **Invariant level** P̃W_{S,Y}: same with {∏_{v∈S}|x_v|_v ≤ Y}. Subscript 0 adds f(0)=f̂(0)=0. Subspace Fréchet topology.
- Chapter 7 proves only support and semigroup statements (7.3.2.2, 7.3.2.4). **It contains no statement that multiplication by |·|^a is continuous on PW levels.**
- **Every basis and nuclearity claim in the chapter is in the fine Fréchet topology or its strong dual. No Hilbert or Sobolev norm appears in Chapter 7.**

## 3. Tests

**(i) Thm 7.1.3.2.**
- Restatement: (1) local factors at places of distinct residue characteristic share at most one pole; (2) bounds on Archimedean pole orders; (3) pole order ≤ [F:Q] at finite-place poles with at most r_1+r_2+|S_0|(|S_0|−1)/2 exceptions; (a) for χ = χ_0|·|^{ix} with χ_0 of finite order, the only exception is s = −ix; (b) Schanuel-conditional and six-exponentials variants.
- (1), (3), (3a) are correct [V]: q_v^s = χ(π_v) fixes s modulo 2πi/log q_v, and log p, log p′ are Q-independent.
- Function fields: every q_v is a power of q, so the lattices 2πiZ/log q_v are commensurable; for χ=1 every local factor has poles at all of 2πiZ/log q, and multiplicity grows like |S_f|. The explanation is sound [V].
- **(2) is false as stated**: "m odd ⇒ order ≤ r_2". For F=Q and χ odd, Γ_R(s+1) has a pole at s=−1 while r_2=0. Lemma 7.1.2.2 also has "m ∈ |k|/2 − N" for complex places (should be −|k|/2 − N, contradicting its own "m ≤ 0"). Inconsequential downstream.

**(ii) Bases (7.3).**
- Single prime, model case [V]: E_{S,S_p} ≅ S(R)_even/(1−D_p)S(R)_even, where D_p g = g(p·), for every S∋p; the other primes cancel. The map g ↦ u(ξ) = Σ_n p^n|ξ|ĝ(p^nξ) is an isomorphism onto C^∞(R_{>0}/p^Z) ≅ s(Z). The δ̂_c are Fourier coefficients of u. So the exponential system is an absolute basis and 7.3.1.6(1)–(5) hold.
- The Fourier system avoids small denominators because Z_S(f̂,·) is evaluated on Re=1.
- Two primes: the union of the p- and q-systems is **not claimed** to be a basis. Thm 4.6.1.5, the source of all bases, assumes commensurable logarithms. For mixed S_0 only "topologically free" is claimed (7.1.4.3, 7.3.1.2), which is correct.
- Small denominators do enter in two places:
  - **Polar system in 7.3.1.6.** a_k = (Laurent data of ρ_S at c)·δ̂, and ρ_S contains 1/(1−χ(q)q^{−s_c}) for q∈S∖S_p. For N_p(c)=1 this is a rescaling and harmless [V]. For N_p(c)≥2 it is a triangular block whose condition number is governed by dist(s_c, zeros at q)^{−1}. A polynomial bound needs Baker's theorem (available for finite-order χ; for general unitary χ I could not determine). The draft gives no estimate; the author half-concedes at 20717–20732.
  - **Thm 7.1.2.3.** Absolute convergence of the residue series with ≥2 primes needs the same bound. The proof gives only grouped convergence along T_k.
- Thm 7.3.3.4 in the model [V]: PV(PW_X) = PW_{pX} ∩ PV(H) and PW_{pX} → E_{S,S_p} is onto for every X>0. For invariant levels with infinite unit group: could not determine.

**(iii) Thm 7.4.2.1.**
- Model [V]: H ≅ S(R)_{even,0}, H/PV_pH ≅ s(Z), and A(φ) is diagonal with eigenvalues φ̂(2πim/log p), hence nuclear. Trace = Σ_m φ̂(2πim/log p) = log p · Σ_{k∈Z} φ(p^k) by Poisson.
- The theorem states only the spectral form; the Poisson step is deferred to 30050.
- **Normalisation:** this is not Weil's local term. It contains all k∈Z, including k=0 (log p·φ(1), divergent when summed over p) and has no |π^k|^{1/2}. A shift by |·|^{−1/2} (as in (11.3.2.5)) gives p^{−k/2}φ(p^k) on one side and p^{+|k|/2} on the other. Agreement with Weil requires φ supported in |g|>1 (as Ch. 11 assumes) and yields only the k≥1 half.
- The proof as written is inadequate: 7.1.4.3 gives minimality only. The missing growth bounds are obtainable from 7.3.1.6(4) plus the isomorphism of Thm 6.2.1.1, neither of which is cited.

**(iv) Thm 7.5.0.1.**
- Restatement: H/PV_{S_0}H → S_E(C_F)(χ)/P_{S_0}S_E(C_F)(χ) is a topological isomorphism. Corollary: every φ∈AS(C) is Λ(s,χ)u + ∏_{v∈S}(1−χ(p_v)q_v^{−s})·v with Λu, v ∈ AS(C).
- Model, S_0={p} [V]: one must interpolate (φ(s_m)) ∈ s(Z) by ζ(s)G(s). The values G(s_m) fill s(Z), and ζ(it) is polynomially bounded above and below (1-line bound plus functional equation). True.
- Several primes: follows by an algebraic five-lemma induction with no Diophantine input [V].
- The draft's injectivity argument (22519–22531, "maps onto a topologically free set") is not valid reasoning; injectivity follows instead from Thm 6.3.2.2 [R].

## 4. What Chapter 11 can cite

- **(a) Trace on a per-prime quotient in a Hilbert/Sobolev completion: nothing.**
  - Ch. 11 uses its own Thms 11.2.0.2, 11.2.2.1 and Cor 11.2.0.5.
  - Line 29593–29597 asserts that the Sobolev quotient "is the completion of" the Chapter 7 quotient; Chapter 7 does not support this.
  - Warning for the Ch. 11 reviewer: on an H^s-type norm along the line carrying the zeros of 1−p^{−s}, multiplication by 1−p^{−s} is not bounded below (test on bumps concentrating at a zero), so closed range of PV_{S_p} cannot be imported from the Fréchet setting. Whether this bites depends on the definition of W^{s,2}_0; could not determine.
- **(b) Convergence as the number of removed Euler factors grows: nothing.** Everything is for fixed finite S. N_S in 7.1.1.1 and the exception count in 7.1.3.2 grow with S.
- **(c) Uniform in p:** only N(ε_p) ≤ [F:Q] (cited at 32170 and in Rem 11.2.2.2), which is trivial. The polynomial in 7.3.1.6(4) and λ(X) are not uniform.
- **Actually cited by Ch. 11:** Prop 7.3.2.2(1) (density of PW levels; fine [V]), Prop 7.3.2.4(4) (trivial inclusion), and the formula (7.4.2.1).
- **Circularity:**
  - 7.4.2.1's trace computation cites (11.2.2.12); Ch. 11 cites 7.4.2.1 back only as "see also" and for its right-hand side. Presentational, not logical.
  - 7.4.3.2 → (10.3.1.8).
  - 7.4.3.1 → proof of 7.5.0.1 (later), and "closed range by Theorem 7.1.4.3", which that theorem does not state.

## 5. Ranked problems

1. **(B) No Hilbert-space content; Fréchet results do not pass to completions** (§4a). This is the serious structural point for the global argument.
2. **(B) Thm 7.4.2.1 proof**: wrong and nonexistent references, forward citation, and minimality used as if it were a basis. The statement is true in the model; the normalisation mismatch with Weil's term is not addressed here.
3. **(C) Def 7.3.3.3 (7.3.3.5–6)**: quotient PW_{q^{−1}X}/PV(PW_X), but PV(PW_X) ⊂ PW_{qX} by the draft's own Prop 7.3.3.2, so the denominator is not inside the numerator. The proof of 7.3.3.4 then works with PW ∩ PV(H) (7.3.3.18), a different denominator; their equality is exactly the "cartesian" claim left unproved at 21386.
4. **(B) Polar-system basis claim in 7.3.1.6 when N_p(c)≥2**, and unordered convergence in 7.1.2.3: both need a Baker-type bound that is absent.
5. **(B/D) Thm 7.4.3.1**: placeholders at 22197 and 22264; the closedness step is circular.
6. **(B) Thm 7.4.1.1** (unused):
   - boundedness of renormalised bi-orthogonal elements needs lower bounds on |Λ^{(N(ρ))}(ρ)|, which are unknown;
   - "N(ρ)! = O(|Im ρ|)" (22013) is unjustified;
   - the span with m ≤ N−1 is not obviously invariant.
   - Could not determine truth.
7. **(A, minor) 7.1.3.2(2) and Lemma 7.1.2.2(1)**, as in §3(i).
8. **(C) Formula (7.1.2.3)** sums over (v,m), so a pole shared by two finite places (always s=0 for χ=1 and |S_f|≥2) is counted twice. Thm 7.1.4.3(1) has the same miscount (product over p of J_{S_0,p}). Laurent indexing is inconsistent between 7.1.2.1, 7.1.2.3 and 7.2–7.3.
9. **(D) Thm 7.3.1.2 proof**: the test function u (20162–20186) leaves poles at places of S_0 not through c_0, and "pole order m_0 > m_{S_0}(c_0)" contradicts f_1∈S_00. Index sets disagree between statement and proof (20049 vs 20081). The hypothesis says S_0 "contains all Archimedean places" while PV is defined for finite places. The result is true [V].
10. **(D) Smaller items:**
    - 7.2.1.1(3) reads "m ≤ m_S(f,c) for all f" (false; should be m_S(c)).
    - (7.3.2.2) has 1_{O^×} against 1_O in (7.3.2.5); "|x_v|_v ∈ [−X,X]".
    - The absolute-convergence step (7.4.3.17) is invalid, though the conclusion is trivial from supp φ ⊂ {|g|>1} [V].
    - The proof of 7.1.2.3 opens "choose A∈(−1,0)" for a statement with A>0.

**Checked and found correct [V]:** 7.1.1.1 (statement); 7.1.3.2(1),(3),(3a); 7.3.1.6 Fourier system, 7.3.2.2, 7.3.2.4(4), 7.3.3.4, 7.3.4.1(4)–(5), 7.4.2.1, 7.4.3.2 (value of the trace), 7.5.0.1 and 7.5.0.3, all in the model case; Lemma 7.3.1.5.

**Not independently checked [R]:** everything imported from Chapters 4–6 and Appendices B, D (Thms 4.6.1.5, 4.6.2.1, 5.2.3.1, 5.4.1.1, 6.2.1.1, 6.3.2.1–2, B.3.2.1, B.6.1.6); 7.1.4.2(2); 7.2.1.4; the general number-field case with infinite unit group and ramified χ.

