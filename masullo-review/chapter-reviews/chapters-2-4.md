<!-- Report of an automated reviewer (a Claude subagent) asked to referee this part of the draft. Unedited. Items marked [V] were derived by the reviewer; they have not all been independently re-checked. -->

# Referee report: Chapter 4 (lines 8578–12352), with the statements of Chapters 2–3

## 0. Summary

Chapter 4's basis claims are essentially correct but narrower than the strategy needs. It proves (a) for one generator γ, S_E(G)(χ)/P_γ S_E(G)(χ) ≅ χ-homogeneous smooth functions on G/γ^Z, with the exponential system as absolute basis; (b) for several generators, a basis of evaluations and derivatives only when the log|γ_k| are commensurable (Thm 4.6.1.5). It contains no basis statement for two distinct primes, none in any Hilbert or Sobolev norm, none uniform in γ, and no trace formula.

I found three false statements (one apparently unused, two harmless), two more in Chapter 3 (both minor), one circular proof, and several author-flagged gaps.

Coverage: I read all of Chapter 4 except parts of the routine proofs in 4.3. In Chapters 2–3 I read the main statements and spot-checked two proofs; the smaller lemmas of 2.1, 2.2.1, 2.2.4–2.2.5 and 3.1–3.2.1 were not read, so the Chapter 2–3 inventory below is the main results only. Appendices B.3 and D.3 I only glanced at.

## 1. Inventory

**Chapter 4** (P_γϕ(x) = ϕ(x) − ϕ(γx); Φ_γ = periodisation)

- **4.1** Def 4.1.1.1 (8693), Def 4.1.2.1 (8759): Schauder, absolute, shrinking bases. Lemma 4.1.2.4 (8808): absolute basis in a complete barrelled reflexive space gives a dual unconditional basis; proof muddled, rescued by citations to Jarchow. Thm 4.1.2.6 (8916, Dynin–Mityagin, including strict LF): citation only.
- **4.2** Lemma 4.2.1.2 (8982): t^{2πim/log γ} is an absolute basis of C^∞(R_{>0}/γ^Z); full proof. Lemma 4.2.1.3 (9066): (E/M)'_β ≅ M^⊥ for nuclear Fréchet or Hilbert E; citations. Lemma 4.2.1.5 (9156): Φ_γ continuous, open, onto; kernel is the closure of P_γ S_E; (1)–(2) full, (3) has a gap (§5 no. 4). Cor 4.2.1.7 (9362): Fourier functionals bounded and equicontinuous; full. Thm 4.2.2.1 (Paley–Wiener, cited). Prop 4.2.2.2 (9467): compactly supported lifts; (2) misstated. Lemma 4.2.2.4, Prop 4.2.2.5 (9578).
- **4.3** Lemmas 4.3.1.3, 4.3.1.5, 4.3.2.2 (L²(G) = ⊕̂_ω L²_ω(R_{>0})), 4.3.3.1 (averaging projector for a compact group), Cors 4.3.3.3, 4.3.3.4: standard. Lemma 4.3.3.7 (10252) and Cor 4.3.3.8 (10351), averaging over a relatively compact subset X: false.
- **4.4** Discussion 4.4.1.1; Def 4.4.2.1; Lemma 4.4.2.5 ((γ^Z)^⊥); Lemma 4.4.2.6 (10693): characters of G/γ^Z form an absolute basis of S(G/γ^Z), with polynomial seminorm growth for each fixed χ; full.
- **4.5** Prop 4.5.1.1 (10970): Φ_γ on S_E(G), kernels, closed range of P_γ. Cors 4.5.1.5, 4.5.1.6. Prop 4.5.2.1, Thm 4.5.2.3 (11504): compact-support versions. Cor 4.5.3.1 (11554): same kernels on S_I(G) and S(G); proof circular.
- **4.6** Lemma 4.6.1.3 (11677): P_{S_0} has closed range and S_E/P_{S_0} ≅ P_{γ_N}S_E/P_S, any S. Lemma 4.6.1.4 (11744): commensurability criterion. Thm 4.6.1.5 (11786): under commensurability, the functionals D_{ξ,m}(ϕ) = ∫ϕ ξ (log|g|)^m, 0 ≤ m < N(ξ), are an unconditional basis of (S_E(G)(χ)/P_S)'_β, with an absolute biorthogonal basis of polynomial growth; N = 2 in full, general N sketched. Ex 4.6.1.6. Thm 4.6.2.1 (12219): representatives supported in a fixed compact set inside {|g|<1}, any S. Cor 4.6.3.1 (12288): S_E/P_S ≅ S_I/P_S ≅ S/P_S, any S.

**Author notes and placeholders**

- "Return here" footnotes at 11081 and 11134, both inside the continuity proof of Prop 4.5.1.1(1).
- Footnote 3 at 8067: "Why do such identities hold? Must say more", on (3.4.1.5)–(3.4.1.6).
- "Lemma ??" at 3577 and 4666; "Definition ??" at 9835.
- Footnote 15 at 47953: continuity of the G-action on S_I(G) "should be addressed".
- Dangling references: "Proposition 4.2.2.7" (10383, 10555), "Proposition 4.2.2.2(3)" (11487), "Proposition 4.2.1.5" (9551).
- Forward references to Thm 7.1.4.2 inside Chapter 4 proofs (11205, 11847).
- Stale chapter numbers at 5228, 6247, 7894.

## 2. Checks by my own argument

**(i) Toy exact sequence: correct.** Division lemma: if f ∈ AS(C) vanishes at every z_m = 2πim/log γ, then g = f/(1−γ^{-s}) ∈ AS(C), continuously in f. Proof: |1−γ^{-s}| is bounded below on Re s = ±σ and, by periodicity, on circles |s−z_m| = r; apply the maximum principle on the discs, or Cauchy's formula on the strip as the draft does in (4.2.2.5). Hence (1−γ^{-s})AS is closed, equals the kernel of the evaluations, and the quotient is C^∞(R_{>0}/γ^Z), topologically by the open mapping theorem. The draft only asserts closedness "by the Asymptotic Residue Theorem" (9284) and injectivity of AS/(1−γ^{-s})AS → O/(1−γ^{-s})O (9301); the real argument appears later at 9552–9565.

**(ii) Absolute basis: correct. Trace: absent.** The identity Σ_m Mφ(z_m) = log γ · Σ_k φ(γ^k) is true (Poisson), but Chapter 4 never states a trace or nuclearity result; it only cites [Lit-II] at 8739.

**(iii) Two or more primes.** Chapter 4 makes no basis claim here: Thm 4.6.1.5 assumes log|γ_k| ∈ Q·log b (11783–11789; the statement mistypes b_k := log|γ_k| and then takes log b_k). For general S it proves only closed range, compact-support lifts and independence of decay class. Those are true; I checked that L·AS = {f vanishing on Z(L) with multiplicity}, by successive division, also in the incommensurable case.

My analysis of the unclaimed case L = (1−p^{-s})(1−q^{-s}):

- Fréchet topology. The map f ↦ (f(z_m), f(w_n)_{n≠0}, f'(0)) is an isomorphism of AS/L·AS onto s ⊕ s ⊕ C if and only if 1/|1−p^{-w_n}| grows polynomially, i.e. |n log p − m log q| ≥ c·max(|n|,|m|)^{-κ}. Baker's theorem gives this for primes, and for finite-order twists. So the evaluations are an absolute basis, but only through Baker, which the draft never cites.
- For real γ_1, γ_2 with Liouville ratio of logs it fails: any representative F of the biorthogonal element has F(w_n)=1, F(z_m)=0, so sup|F'| ≥ 1/|w_n−z_m|, which is incompatible with equicontinuous basis projections.
- For twists by a general unitary χ, the near-coincidences are a "four exponentials" configuration. The draft controls only exact coincidences there, conditionally on Schanuel (Thm 7.1.3.2(3b), 18990). No quantitative bound is available.
- Hilbert completions of Hardy type (norms on Re s = ±σ, as in (4.2.1.19)). Evaluations on iR have comparable norms and ‖δ_w−δ_z‖ ≲ |w−z|. Since inf|n log p − m log q| = 0 for any two distinct primes, the system is not uniformly minimal and so is not a Schauder basis in any order. Only a block basis of divided differences can survive.

Downstream uses that I sampled (20435, 22666) apply Thm 4.6.1.5 with S = S_p, the places over one rational prime, consistent with its hypothesis. I did not check Chapters 10–12.

**(iv) Section 4.6.** Thm 4.6.1.5 is correct in my judgement. Commensurability makes the zero set periodic, so it is uniformly discrete, coincidences occur in whole progressions, and the constants (4.6.1.26) form a finite set. The Banach–Steinhaus projector argument for N = 2 works; I filled in one unstated step (polynomial growth of the Z_1-part in the middle space). Typos confuse Φ_{χ,γ_1} and Φ_{χ,γ_2} (12003, 12029).

**(v) Q-linear independence of log p.** Chapter 4 uses only the opposite case (Lemma 4.6.1.4). Independence enters in Chapter 7 for exact coincidences ("at most one common pole", 18980). It says nothing about near-coincidences, which are what govern bases.

## 3. Chapters 2–3

- **Thm 2.2.3.2 (4313).** Φ_F(f)(g) = |g|^{-1}Φ_F(f̂)(g^{-1}) + |g|^{-1}f̂(0) − f(0), where Φ_F(f)(g) = Σ_{ξ∈F^×} f(ξg). Correct; for F = Q it is θ_f(x) = x^{-1}θ_{f̂}(1/x) + f̂(0)/x − f(0). Proof by citation to [CF].
- **Thm 2.2.3.4 (4341).** Rapid decay as |g|→∞; |Φ_F(f) − |g|^{-1}f̂(0) + f(0)| ≤ C_N|g|^N as |g|→0; uniform on bounded sets. Correct (checked on the Gaussian for Q). Thm 2.2.5.4 is the ω-isotypic version.
- **Section 2.4** concerns the S-local sum Φ_{F,S}(f)(g) = Σ_{ξ∈O_{F,S}^×} f(ξg), not the global θ. Prop 2.4.1.1 (F = Q) and Thm 2.4.2.1 (6094): |Φ_{F,S}(f)(g)| ≤ C_{B,1}|log|g||^{|S|−1} + C_{B,2} for |g|<1, uniformly on bounded B. Correct order: the S-unit lattice has rank |S|−1 and the count is over a simplex of size log(1/|g|). An upper bound only. Prop 2.4.3.1 and Cor 2.4.3.2 are the trivial O(|g|^{-ε}) and o(|g|^{-ε}) corollaries. The remark at 6072 (imaginary-axis poles of order ≤ |S|) follows.
- **Thms 3.2.2.1, 3.3.1.1.** Tate's global zeta (poles at 1 and |·|, residues −µ_1(C_F^1)f(0) and µ_1(C_F^1)f̂(0), functional equation) and the S-local version Z_S(f,c) = ρ_S(c)Z_S(f̂,ĉ). Standard.
- **Weil's Identity I (Thm 3.4.1.1, 7927).** For f = f_∞ ⊗ ⊗1_{K_v}: Z(f,χ|·|^s) = Z_{S_0}(f_{S_0},·) · Π_{v∈S−S_0}(1−χ_v(π_v)q_v^{-s})Z_v(f_v,·) · L_{Σ−S_0}(s,χ) on Re s>0. Standard Euler unfolding, but the key step carries the author's footnote 3.
- **Weil's Identity II (Thm 3.4.3.3, 8528).** Eigendistribution spaces are one-dimensional; Z_v(·,c) = L_v(c)Δ'_v(c) and Z(·,c) = L(c)Δ'(c), with Δ' holomorphic. Citation to Weil and Kudla. With µ_v(O_v^×) = N(d_v)^{-1/2} (A.3.2.2) and the normalisation ⟨Δ'_v,1_{O_v}⟩ = 1, the local identity is off by N(d_v)^{-1/2} at ramified v, unless L_v is defined as Z_v(E_v,·). Could not determine which.

## 4. What these chapters provide to Chapters 10–12

Provided: Tate theory with uniformity on bounded sets; the log-power bound for S-local θ-functions; the single-γ isomorphism and exponential basis in nuclear Fréchet and LF topologies; the jet basis over one rational prime; closed range of P_S; compact-support representatives.

Not provided:
- Any basis statement after completion. The draft itself warns that completion may leave only a Markushevich basis (8646–8651).
- Any uniformity in γ, p or χ. Lemma 4.4.2.6(2b), Cor 4.5.1.5 and (4.6.1.17) are for fixed χ and S with untracked constants. My estimate (not a proof): in Hardy-type norms on |Re s| ≤ σ the biorthogonal elements grow like a power of p.
- Any multi-prime basis.
- Any trace formula.
- Anything about zeros of L: the kernels are cut out by Euler-factor zeros on iR.

## 5. Ranked problems

1. **(B) Scope gap.** No basis for incommensurable generators, in any topology. As raw evaluations this is impossible in Hardy-type Hilbert norms (§2(iii)). If later chapters need several primes at once, Chapter 4 does not supply it.
2. **(A) Lemma 4.3.3.7(2),(3) and Cor 4.3.3.8(2),(3) are false.** The proof (10301) claims ∫_X ρ(gg')u dg' = ∫_X ρ(g'')u dg'' "by invariance", but gX ≠ X. Counterexample: G = R, E = S(R), X = [0,1]. Then H^0(X,E) = 0; Φ_X is injective and non-zero; it is not idempotent; the closure of span{u−τ_g u} is {∫u = 0} ≠ ker Φ_X = 0. A label search finds no use outside 4.3.
3. **(B) Cor 4.5.3.1 is circular.** The bijections (4.5.3.5) (11594) are asserted, and they are equivalent to the conclusion. The statement is true by division in S(R); I verified this for G = R_{>0}. It feeds Cor 4.6.3.1, used at 20438, 20459, 20707, 21756.
4. **(B, fixable) Lemma 4.2.1.5(3) and Prop 4.5.1.1(4).** Closedness and the division property are asserted, not proved (9284, 9301, 11195); repaired by (4.2.2.5).
5. **(D) Prop 4.5.1.1(1).** The continuity proof carries the two "Return here" notes and uses "a convergent net is eventually bounded" (11073), which is false in non-normable spaces. Fix: continuity on each Fréchet step.
6. **(A, minor) Prop 4.2.2.2(2) and Prop 4.5.2.1(3).** Wrong support of ψ. With γ = 2, K = [1/4,4], ψ a bump on [3,3.5] and ϕ = ψ − ψ(2·): ϕ ∈ ker Φ_2 ∩ D_K, ψ is the unique solution, and it is not supported in the claimed [1/2,2]. Correct: supp ϕ ⊂ [α,β] gives supp ψ ⊂ [γα,β]. The error is (4.2.2.6) as Re s → +∞. Harmless downstream.
7. **(A, minor) Lemma 3.3.2.2 (3.3.2.23).** The residue should be N(d_v)^{-1/2} f(0)/log q_v, not N(d_v)^{-1/2}(1−q_v^{-1}) f̂(0)/log q_v. Check: f = 1_{Z_p} gives Z = 1/(1−p^{-s}), residue 1/log p. The proof uses ν_v = |·|µ_v, contradicting A.3.2.3, and identifies ∫f̂ with f̂(0).
8. **(A, minor) Prop 3.3.1.5(3) (3.3.1.11).** The exponent should be (σ−1/2)[F:Q]. The complex factor Γ(s)/Γ(1−s) is ≍ |τ|^{2σ−1}, and the proof bounds single factors only. Correct for F = Q.
9. **(C)** Thm 4.5.2.3 says "any compact K" but needs 2 log a > log|γ| (false for small K). The signs in (4.4.2.4)–(4.4.2.5) are inconsistent with (4.5.2.3) and (4.6.1.x), possibly because conjugation bars were lost in extraction; could not determine. Thm 3.4.2.2 omits the µ_1(C_F^1) factors of (2.2.5.10).
10. **(D)** Thm 3.4.1.1 footnote 3; the general-N induction in Thm 4.6.1.5; the remaining placeholders.

## 6. Verified versus reported

- **Verified by my own argument:** the division lemma and toy exactness; Lemmas 4.2.1.2 and 4.4.2.6; Thm 4.6.1.5 for N = 2; Lemma 4.6.1.3; Thm 4.6.2.1; Cor 4.6.3.1 for G = R_{>0}; every counterexample in §5; the Baker, Liouville and Hardy-space analysis in §2(iii); Thm 2.2.3.2 and 2.2.3.4 for Q; the order of growth in Thm 2.4.2.1.
- **Reported, not verified:** all results cited to Jarchow, Valdivia or Köthe; appendix inputs (Prop D.3.2.5, Thm D.3.3.7, Thm D.3.3.13, Thm B.3.2.1); the proofs in Chapters 2–3 apart from 3.3.1.5 and 3.3.2.2; the general-N induction; the LF-space details of Prop 4.5.1.1(5).
- **Could not determine:** conjugation and sign conventions; the L_v normalisation in Weil II; whether Chapters 10–12 use only S = S_p.
