<!-- Report of an automated reviewer (a Claude subagent) asked to referee this part of the draft. Unedited. Items marked [V] were derived by the reviewer; they have not all been independently re-checked. -->


# Referee report: Masullo draft, Ch. 12 (lines 30052–31570), Ch. 13 (31571–31650), Ch. 14 (31651–32348)

I read the whole range sequentially, plus the cited earlier items (11.3.1.4), Thm 11.3.2.1, Def 9.3.3.1, Thms 10.3.2.1, 10.4.2.8, 10.4.3.1, 10.4.3.4, Def 10.4.3.7, Rem 11.2.2.2, Lemma C.3.2.2. Items marked **[V]** I checked by my own reasoning; **[R]** I only report.

**Bottom line.** The main theorem 12.5.1.1 has a six-sentence proof that rests on an empty section (§12.3), an acknowledged-incomplete S-local theorem about a different operator, and a Chapter 11 "overview". Chapter 13 contains no proof and no statement of GRH. The chain to GRH is not established in this range.

## 1. Inventory

| Item | Lines | Content | Proof status |
|---|---|---|---|
| Def 12.1.1.1 | 30095 | Smoothening φ̃(x) = lim_k μ(U_k)⁻¹∫_{xU_k}φ for a D′-sequence {U_k}; "regular point" = limit exists | definition |
| Thm 12.1.1.2 | 30141 | G lca second countable, λ = fμ_G with f continuous and nowhere zero, T nuclear on L²(G,λ) with kernel k. (1) a.e. diagonal point is regular for k (using U_k×U_k), k̃(x,x) ∈ L¹(λ), ∫k̃(x,x)dλ = Tr T. (2) ∫ρ k̃(x,x)dλ = Tr(M_ρT) for ρ ∈ L^∞. (3),(4) weak-L¹ convergence of diagonals under S¹-convergent finite-rank approximants | Full modulo deferring the core of (1) to Brislawn. **[V]** correct. Notational slips only ("P_mTP_m → T" means partial sums) |
| Thm 12.1.1.3 | 30372 | a>0, s≥3, φ ∈ D(C_F). (1) a.e. diagonal point regular for k^spec, k^geom. (2) Tr(P^geom_{ρ,a}A(φ)) = ∫ρ k̃^geom(x,x)dμ and Tr(P^spec_aA(φ)) = ∫k̃^spec(x,x)dμ. (3) if φ(1)=0, k̃^geom(x,x) ∈ L¹ and lim_{Λ→∞, εΛ=o(1)} Tr(P^geom_{ρ,a}A(φ)) = ∫k̃^geom(x,x)dμ | Short and correct given the Ch. 10 nuclearity **[V]**. Stated only for the I-free kernel k_{φ,a,s}, not the k_{φ,1/2,I,s} used in 12.5. Truncated sentence at 30412; wrong labels at 30442 and 30447; cites non-existent parts "Thm 10.4.3.1(4)" (30426) and "10.4.3.4(4)" (30449), both theorems having only parts (1)–(3) |
| Rem 12.1.1.4 | 30449 | P^geom_aA(φ) is not Hilbert–Schmidt, hence the truncation | remark |
| Lemma 12.2.1.1, Cor 12.2.1.2, Def 12.2.1.3 | 30525–30648 | Bourbaki: a continuous u₀ ≥ 0 with Σ_h u₀(h⁻¹x) = 1 and compact supp u₀ ∩ HK ("H-indentation"); L¹(G/H) → L¹(G) isometric section u ↦ u₀·(u∘π) | Full, standard. Dangling non-sequitur sentence at 30630–30631 |
| Rem 12.2.1.4 | 30652 | "Fundamental domain" D: connected, non-empty interior, D ∩ gD = ∅ | see §7, C3 |
| Situation 12.2.2.1, Prop 12.2.2.2 | 30693, 30712 | u₀^Δ(x,y) := Σ_h u₀(h⁻¹x)u₀(h⁻¹y); Ψ^Δ(u) := u₀^Δ·(u∘(π×π)); "skewered diagonal" identities (12.2.2.4)–(12.2.2.7): ∫_{G/H}ũ(x,x) = ∫_D Σ_h Ψ^Δ(ũ)(h⁻¹x,x)dx | Full, correct, but tautological (§2) |
| Prop 12.2.2.4 | 31000 | G_k increasing open subgroups, D ⊂ G₀, β_k = 1_{G−G_k}: lim_k ∫_D Σ_h Ψ^Δ(ũ)(x,h⁻¹x)β_k(h⁻¹x)dx = 0 | Full; one false containment (31075), fixable; wrong label at 31104; vacuous (§2) |
| §12.3 | 31108–31109 | — | **Confirmed empty**: heading plus footnote marker; footnote text "Include section." at 31175 |
| Thm 12.4.1.1 | 31123 | §3 | Sketch with author notes |
| Thm 12.5.1.1 | 31505 | §4 | Six sentences |
| §13.1, §13.2 | 31592–31593 | — | Empty headings |
| Thm 13.3.1.1 | 31600 | §5 | No proof; footnote "Correct statement." |
| Thm 13.3.1.2 | 31644 | No statement | "Insert statement." |
| Prop 14.1.1.1 | 31733 | Weil group facts | By citation; fine |
| Conj 14.1.2.1, 14.1.2.2 | 31967, 32009 | GRH+GSH; Langlands for W_Q | conjectures |
| Prop 14.1.2.3 | 32040 | Conditional: zeros on the line and N(ρ) ≤ [F:Q] off centre | Full **[V]** (even with shared zeros, N ≤ Σn_λ ≤ Σn_λd_λ = [F:Q]) |
| Prop 14.1.2.5 | 32087 | Conditional on rk ≤ ord (BSD): a Hecke character of Q(√−3) with central order > 2 | Full given the hypothesis |

**Author notes and placeholders:**
- 31175 "Include section."
- 31176–31180 "Extend Definition 9.3.3.1 … Return here … Then study the convergence of the integral in (12.4.1.23) …"
- 31250 "See previous footnote."
- 31251 "Return here after the Proposition is updated."
- 31648 "Correct statement."
- 31649 "Insert statement."
- 31650 "State and prove the Main Theorems, also explaining how to deduce them by approximation φ → e^{−s|log t|} …"
- 31937 "Correct this subsection."
- 32347 "Say a few words on GL_n … ongoing work with Brian Conrad."
- Unresolved "Theorem ??" at 31643, 31925, 32160.
- Cited from outside the range: 28720–28721 "Return here."; 29895–29904 "here I am omitting several items … We are going to omit all of this from this overview".

## 2. "Diagonal mass"

**Definition.** For k ∈ L¹_loc(G×G), the mass is ∫k̃(x,x), with k̃ the limit of averages over xU_k × yU_k. It equals a trace only under Thm 12.1.1.2: T nuclear on L²(G, fμ_G), f continuous and nowhere zero. For the un-truncated geometric kernel it is defined only when φ(1)=0, where k̃^geom(x,x) = −k̃^spec(x,x) and the "geometric mass" is tautologically −Tr(P^specA(φ)).

**[V] Prop 12.2.2.2 carries no information.** Since u∘(π×π) is H×H-invariant, Ψ^Δ(ũ)(h⁻¹x,x) = u₀^Δ(h⁻¹x,x)·ũ(πx,πx), and Σ_h u₀^Δ(h⁻¹x,x) = (Σu₀)² = 1. The off-diagonal terms h ≠ 1 never see off-diagonal values of u. With u₀ = 1_D, u₀^Δ(h⁻¹x,x) = δ_{h,1} for x ∈ D, and (12.2.2.4)–(12.2.2.7) reduce to ∫_D ũ(πx,πx)dx = ∫_{G/H}ũ(x,x). This is not Connes' Σ_ξ∫k(x,ξx), where the lifted kernel on A_S × A_S is genuinely non-periodic.

**[V] Chopped kernels.** α_k lives on GL₁(A_F) and is not F^×-invariant, so (α_{k+1}−α_k)·k^geom is not a function on C_F × C_F and Def 12.1.1.1 / Thm 12.1.1.2 do not apply. The only available meaning is ∫_D Σ_ξ Ψ^Δ(k̃)(x,ξ⁻¹x)α(ξ⁻¹x)dx = ∫_D k̃(πx,πx)·w_α(x)dx, with weight w_α(x) = Σ_ξ u₀^Δ(x,ξ⁻¹x)α(ξ⁻¹x) ∈ [0,1]. So:
- every piece's "mass" is a weighted integral of the same function −k̃^spec(x,x);
- the weights depend on the arbitrary indentation u₀;
- no orbital values φ(π_v^k) can arise from this definition.

**[V] Prop 12.2.2.4 is vacuous.** Its u₀ is supported in G₀, so for x ∈ D ⊂ G₀, u₀^Δ(x,y) ≠ 0 forces y ∈ G₀ ⊂ G_k, where β_k = 0. Every integrand is identically 0 for every k. With this indentation each k_p has mass 0 for all φ, contradicting the value (log q_v/μ_v(O_v^×))Σ_kφ(π_v^k) of Thm 11.3.2.1. That theorem uses a different, discontinuous "indentation" (11.3.2.2), which is outside Def 12.2.1.3.

**[V] Index clash.** Ch. 11's strata are decreasing in k (units at the first k primes); Prop 12.2.2.4's G_k are increasing. With Ch. 11's α_k, α_{k+1}−α_k ≤ 0, so k = α_∞k − Σ(α_{k+1}−α_k)k, not "k_S + Σk_p".

## 3. Thm 12.4.1.1 (S-local trace)

**Hypotheses.** S finite, containing the Archimedean and ramified places; Pic(O_{F,S}) = 1; φ ∈ D(C_F) invariant under Π_{v∉S}O_v^×. There is no χ, I, s or ε in the statement, and no condition φ(1)=0.

**Statement.** μ_{S,1}(J¹_{F,S})⁻¹∫_{J_{F,S}}k^PW_{S,φ,λ,λ′}(x,x)dμ_S = Σ_{v real}½∫′φ(g)|g|^{1/2}/|1−g| + Σ_{v complex}(1/2π)∫′(same) + Σ_{v∈S_f}(log q_v/μ_v(O_v^×))∫′(same) + φ(1)log(λλ′) + o(1), as λ,λ′ → ∞.

**Operator.** k^PW is defined only inside the proof (31350), as the kernel on A_{F,S} × A_{F,S} of P_{ρ,λ}∘A_φ̃∘P̂_{ρ,λ′} on S(A_{F,S}). This is Connes' R_ΛU(h) with two parameters. The left side as written (multiplicative measure, diagonal only) is not what the proof computes (Σ_{ξ∈O_S^×}∫_{E_{S,0}}k^PW(x,ξx)dν_S): the statement is ambiguous.

**Comparison with Connes.** It is his Theorem 4 divided by the volume: φ(1)log(λλ′) is his 2h(1)log′Λ, and S is finite. It does not depend on I or s. The spaces W^{s,2}PW^inv and W^{s,2}_{1/2}H₀ are mentioned at 31189–31204 and immediately replaced by E = |·|^{1/2}H₀(O_S^×, S₀₀(A_{F,S})) "by Lemma C.3.2.2", whose hypotheses (nuclearity, factorisation) are asserted, not verified.

**Completeness.** Sketch.
- Steps I–II are formal distribution calculus.
- Step III reproduces Connes up to (12.4.1.24) **[V]**: the change of variables w = xu, the log(λλ′) − log|w| weight and Σ_ξη_ξ(0) = φ(1) are right; the final swap φ(g⁻¹) ↔ φ(g) is right.
- Then "the calculation from [Co] now applies" (31466), with no treatment of the ξ-sum or the o(1).
- "Prop 12.2.2.2's recipe" (31239, 31255) does not apply: k^PW is not of the form u₀^Δ·(u∘π×π).
- Footnotes 2–4 concede the cutoff is (0,λ], not the [1/Λ,Λ] used globally, and that convergence of (12.4.1.23) is still "to study". **[V]** With a two-sided cutoff [1/λ″,λ] the weight becomes log λ + min(log λ′ − log|w|, log λ″). Letting λ′ → ∞ before λ″ leaves only φ(1)log(λλ″), with no local terms. The local terms depend on the order of limits; "as λ,λ′ → ∞" hides this.

**a = 1/2.** Line 31500 promises to explain its "necessity"; nothing in the range does. **[V, heuristic]** With a general twist the same computation gives φ(g)|g|^{1−a}/|1−g|, matching Weil shifted by a. The S-local side does not single out a = 1/2.

## 4. Thm 12.5.1.1

**Statement.** F a number field, φ ∈ D(C_F) with φ(C_F¹)=0 (vanishing on norm-one classes, not "supported away from norm 1"). Then Σ_{v real}½∫′ + Σ_{v complex}(1/2π)∫′ + Σ_{all finite v}(log q_v/μ_v(O_v^×))∫′φ(g_v)|g_v|^{1/2}/|1−g_v| = Mφ(|·|^{1/2}) + Mφ(|·|^{−1/2}) − Σ N(c)Mφ(c|·|^{−1/2}), the sum over zeros c in the interior of {σ(c) ∈ 1/2+I}. I and s are never quantified; S appears only in the proof.

**Proof, step by step (31539–31570):**
1. *Choice of S.* It mentions "the character χ", absent from the statement. **[V]** With T < N(p_v) and φ(1)=0, the v ∉ S terms on the left vanish, so the left side is Σ_{v∈S}.
2. *"By (11.3.1.4): ∫k_S + Σ_{p∤S}∫k_p = ∫k."* (11.3.1.4) is a definition inside an overview; it defines neither k_S nor a mass (§2). This single line is where the infinite sum over p is exchanged with the diagonal integral; no result is cited. Prop 12.2.2.4, the only candidate in range, is not cited and is vacuous. The missing §12.3 is exactly this step.
3. *"By Thm 11.3.2.1 each ∫k_p = 0."* That theorem assumes supp φ ⊂ C_F^{>1}, not φ(C_F¹)=0; its right side has a free v; its proof is a narrative. The Λ → ∞ limit is taken inside each piece separately (30043), with no uniformity in p. The exchange of Σ_p with lim_Λ is not justified anywhere in the range.
4. *"By Thm 12.4.1.1, ∫k_S = LHS − Mφ(|·|^{1/2}) − Mφ(|·|^{−1/2})."* Not delivered:
   - 12.4.1.1 concerns k^PW on A_{F,S}, never identified with k_S;
   - it contains no pole terms at all;
   - it is an asymptotic in (λ,λ′) carrying a volume normalisation; no limit or normalisation is discussed.
5. *(12.5.1.4): ∫k = −ΣN(c)Mφ.* Fine via Thm 12.1.1.3(3) (uncited, and stated without I), 10.4.2.8 and 10.3.2.1. Per (10.3.2.4), boundary zeros b = ±α count with min{N, [(s−1)/2]+1}; the statement ignores them.

**[V] The proof is insensitive to α, s and any central-vanishing condition.** Its ingredients allow α ≥ 0 and s > 1 (11.3.2.1), resp. s ≥ 3 (Def 10.4.3.7). Yet:
- Rem 11.2.2.2 and 32193–32194 say s = 2[F:Q] is "forced";
- 31931–31932 and 32251–32257 say the test functions must vanish to order [F:Q] at central points, and that this "enables the deconstruction of the global geometric kernel".

None of this appears in 12.5.1.1 or its proof. Run verbatim with α = 0, the argument plus Weil gives N(ρ) ≤ [(s−1)/2]+1 at every zero, the centre included (deduction in §5). That is false:
- s = 3 gives a cap of 2; but ζ_K for an A₄-extension K/Q has every zero of the 3-dimensional monomial Artin L-function with multiplicity ≥ 3.
- s = 2[F:Q] with F imaginary quadratic gives a cap of 2; but the L-function of a CM elliptic curve over Q of rank ≥ 3 and root number −1 has central order ≥ 3 by Gross–Zagier–Kolyvagin. I did not verify a specific curve offline.

So the argument as written proves too much.

## 5. Chapter 13

**Stated.** Only Thm 13.3.1.1, flagged "Correct statement", with no proof. It reads: with N_spec = min{N, [F:Q]}, and φ whose Mellin transform vanishes to order [F:Q] at the τ-central point of every component (13.3.1.2), Σ_{σ(c)=1/2}N_spec(c)Mφ(c|·|^{−1/2}) equals the Weil geometric side. This is the α = 0, s = 2[F:Q] case. It is not "the statement of Thm 12.5.1.1" as 31598–31599 claims: the hypotheses, the multiplicities and the local normalisations (no ½, 1/2π, 1/μ_v(O_v^×)) all differ. "[F:Q]-codimensional" is right only per isotype.

**Missing.** §13.1, §13.2, the statement and proof of 13.3.1.2 (GRH and the multiplicity bound), and the "Positivity Criterion (Theorem ??)".

**[V] Deduction, conditional on 13.3.1.1.** Subtracting Weil gives Σ_c m(c)Mφ(c|·|^{−1/2}) = 0 on the class A, with m = N off the line and N − N_spec on it. A is stable under translation by τ(y), so Σa_c y^{−z_c} ≡ 0. Its Laplace transform Σa_c/(s+z_c) is meromorphic with residues a_c, so every a_c = 0. For non-central c one can choose φ ∈ A with Mφ(c) ≠ 0 (multiply a Mellin transform by sⁿ). Hence GRH, and N ≤ [F:Q] off centre. This is equivalent to the L′/L-holomorphy and Montel route. Two cautions on that route:
- φ_z = t^{−z}1_{t>1} must be smoothed at t = 1, since Σ1/|z−ρ| diverges;
- footnote 3's e^{−s|log t|} violates both φ(1)=0 and (13.3.1.2).

**Plausibility.** Central terms vanish on both sides, so there is no constraint there. The off-centre bound N ≤ [F:Q] is not known to be false: for non-abelian ζ_K the forced multiplicities are dim ρ ≤ √[K:Q], and the bound is consistent with GSH (Prop 14.1.2.3).

**[V] But the "central point" depends on the arbitrary section τ.** For a CM Grössencharacter of imaginary quadratic K, nontrivial on S¹ ⊂ C_K¹, the section τ′(t) = t^{1/2}e^{iθ log t} moves x₀. The true centre s = 1/2 then becomes "generic", and 13.3.1.1 would give N(1/2) ≤ 2, false for the rank ≥ 3 CM examples. As stated ("upon choosing" τ), 13.3.1.1 is false for non-canonical τ. The intrinsic description at 31933–31944 ("unique point allowed to be a multiple pole of partial Euler products") is wrong or void: for χ = 1 all poles of Π_{v|p}L_v on Re s = 0 are multiple, and for generic χ none are.

## 6. Chapter 14

- **§14.1.1.** Standard recollection of Weil groups and Artin–Weil L-functions, by citation.
- **§14.1.2** (flagged "Correct this subsection"). Conditional consistency check 14.1.2.3 is correct. 14.1.2.5 is conditional on BSD, yet the text asserts an "affirmative answer" (31999–32000). The closing discussion of m_F(χ) is heuristic, with unproved assertions.
- **§14.2.** Prose claim that the method fails for function fields because Thm 7.1.3.2 fails; no theorem. Minor error: "gonality … equal to g+1" (32321) — gonality is at most ⌊(g+3)/2⌋ geometrically; only gonality < 2g is needed. Mis-reference "Theorem 11.2.2.1" (32305).
- **§14.3.** One claim (bound n[F:Q]) and a placeholder footnote. Empty.

## 7. Ranked problems

**(B) Genuine gaps**
1. Proof of 12.5.1.1, steps 2–4. No definition of k_S or of a well-defined mass for k_p; no identification of k_S with Connes' S-local kernel; pole terms from nowhere; no handling of Σ_p ↔ ∫ ↔ lim_Λ; §12.3 empty. This is the heart of the claimed GRH proof and it is absent.
2. Thm 12.4.1.1: proof incomplete by the author's own footnotes; the cutoff does not match the global one; the result depends on the order of limits.
3. Chapter 13: no statement or proof of GRH; "Theorem ??".
4. No use of the "necessary" a = 1/2, s = 2[F:Q] or central-vanishing in the proof of 12.5.1.1.

**(A) False as written**
1. 12.5.1.1's argument at α = 0 (admitted by all cited hypotheses) yields false multiplicity bounds (§4). For I = {0} the literal statement has an empty spectral sum, contradicting Weil.
2. 13.3.1.1 for arbitrary τ (§5).
3. 31075: containment S ∩ π⁻¹π(K) ⊂ S ∩ π⁻¹π(K∩G₀) is false; fixable using finitely many cosets.
4. 32321: gonality claim.

**(C) Not well defined**
1. "∫_{C_F}k_p(x,x)dμ" and k_S (§2); indentation-dependent.
2. Left side of (12.4.1.1); I and s in 12.5.1.1.
3. "Fundamental domain" (Rem 12.2.1.4): no connected set with non-empty interior exists in GL₁(A_F); and "μ-measure zero" uses the measure on the quotient.
4. "Central zero" (31933–31944).

**(D) Unfinished or cosmetic**
- Label slips: 30442, 30447, 31104, 31160, 31257, 31492.
- Truncated sentence 30412; dangling 30630.
- "G ≃ G₀ × Πξ_k^Z" should be a direct sum.
- Hypothesis mismatch φ(C_F¹)=0 vs supp φ ⊂ C_F^{>1}.

**Checked and found correct [V]:** Thm 12.1.1.2; Thm 12.1.1.3 (given Ch. 10); Lemma 12.2.1.1 and Cor 12.2.1.2; Props 12.2.2.2 and 12.2.2.4 as formal statements; the algebra (12.4.1.13)–(12.4.1.24); the φ(g⁻¹) ↔ φ(g) symmetry; vanishing of the v ∉ S local terms; the sign bookkeeping of (12.5.1.1)–(12.5.1.4); the deduction "13.3.1.1 + Weil ⇒ GRH + bound"; Prop 14.1.2.3.

**Could not determine:**
- whether Ch. 10's nuclearity claims hold (outside range);
- how the author intends the Fourier-side cutoff λ′ to arise from the global kernel, which has only the M_ρ cutoff;
- whether the volume normalisation in 12.4.1.1 is compatible with μ on C_F.

