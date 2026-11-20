<!-- Report of an automated reviewer (a Claude subagent) asked to referee this part of the draft. Unedited. Items marked [V] were derived by the reviewer; they have not all been independently re-checked. -->

REFEREE REPORT: Appendix C (layout.txt lines 39568–44277)

Summary: the three results the main text leans on (Lemma C.3.2.2, Corollary C.3.5.5, Theorem C.1.5.5) are correct as stated. The appendix does contain several false sub-statements, all locally fixable and none load-bearing inside the appendix. The real exposure is in how the main text checks hypotheses. I read all of C.3 with proofs, C.1.5–C.1.6 and C.4 closely, and skimmed the rest of C.1, C.2 and C.5.

## 1. Inventory

**C.3 (complete)**

| Result (line) | Content | Proof status |
|---|---|---|
| Lemma C.3.1.2 (41633) | T nuclear iff T = Σ λ_m φ_m ⊗ x_m, (λ) ∈ ℓ¹, (φ_m) equicontinuous, (x_m) in a Banach disc | Citation (Schaefer). Indices n/m garbled |
| Prop. C.3.2.1 (41655) | E with approximation property (AP): Trace(A) = Σ λ_m φ_m(x_m) is well defined; invariant under conjugation | Citation (Litvinov); conjugation part proved |
| Lemma C.3.2.2 (41700) | E1, E2 with AP, T: E1→E2 continuous injective, A0: E2→E1 nuclear, A = T A0, A1 = A0 T. Then A1 is nuclear and Trace(A1) = Trace(A) | Proof given; last step is a hand-wave (41759–41766) |
| Lemma C.3.3.1 (41804) | B_SOT(H) is quasi-complete; bounded sets metrizable if H separable | Proved / cited |
| Lemma C.3.4.1 (41831) | T trace class, Σ orthonormal basis: (1) Σ\|⟨Tϕ,ϕ⟩\| < ∞; (2) that sum is basis-independent; (3) Σ⟨Tϕ,ϕ⟩ is basis-independent | Citation (Conway) |
| Lemma C.3.4.3 (41858) | A compact, Q_m → Q strongly (sequence) ⇒ Q_m A → QA in norm | Full |
| Lemma C.3.4.4 (41882) | Ideal and norm properties of N(H); (2) asserts ‖AT‖_Tr = ‖TA‖_Tr ≤ ‖A‖‖T‖_Tr; (5) P_i → 0 strongly (net), F finite rank ⇒ P_iF → 0 in trace norm | Citations; (5) proved |
| Prop. C.3.5.1 (41914) | H separable, mutually orthogonal H_i with dense sum, T nuclear: P_{Σ_k}T → T in trace norm, traces converge | Full (42082) |
| Lemmas C.3.5.3, C.3.5.4 (41959, 42048) | Min-max; σ_m(AB), σ_m(BA) ≤ σ_m(A)‖B‖ | Full |
| Cor. C.3.5.5 (42115) | H separable, H_1 ⊂ H_2 ⊂ … closed with dense union, P_i orthogonal projectors, T nuclear: (1) P_i → Id strongly; (2) P_iT → T and TP_i → T in trace norm; (3) traces converge | Full |
| Thm. C.3.6.1 (42188) | Schmidt decomposition of compact operators | Sketch |
| Lemma C.3.6.3 (42247) | (1) σ_m(A+B) ≤ σ_m(A)+σ_m(B); (2) \|σ_m(A)−σ_m(B)\| ≤ ‖A−B‖; (3) σ_{m+n}(AB) ≤ σ_m(A)σ_n(B) | Citation (Jarchow 19.8) |
| Prop. C.3.6.4 (42270) | E′⊗̂_πF ≅ S_1, E′⊗̂_εF ≅ K(E,F), Hilbert–Schmidt completion ≅ S_2 | Citation (Ryan) |
| Prop. C.3.6.5 (42303) | A ∈ S_p, C_j → C strongly, B_k → B strongly with B_k self-adjoint (sequences): C_jA → CA, AB_k → AB, C_jAB_k → CAB in S_p | Full |
| Thm. C.3.7.1 (42434) | Trace of a nuclear integral operator = diagonal integral of the (smoothened) kernel | Citation (Brislawn) |

**Main results elsewhere**
- Lemma C.1.5.4 (40068): Grothendieck factorization. Proved.
- Thm. C.1.5.5 (40100): open mapping theorem. Proved.
- Thm. C.1.5.11 (40261): limit subspace ⇔ bounded lifting. Citation (Wengenroth).
- Cor. C.1.5.13 (40281). Proved.
- Lemma C.1.6.1. Proved.
- Props. C.2.3.9–C.2.3.14: tensor products versus inductive limits and embeddings.
- Lemma C.2.4.10 (41376): nuclearity passes to subspaces, Hausdorff quotients, products, countable sums. Citation.
- Lemmas C.2.4.12, C.2.4.16: nuclear ⇒ AP. Citation.
- Thm. C.4.3.5 (42735): continuous, compactly supported, E quasi-complete, finite Radon measure ⇒ Pettis integrable. Proved.
- Lemmas C.4.3.7–C.4.3.12, C.4.4.1 (Fubini), C.4.4.5 (Weil).
- Thms. C.5.1.24, C.5.2.6, C.5.4.1.

**Author notes and placeholders**
- 39780, 39788: citation "[?]".
- 40180 (fn 1): cross-references to the open mapping theorem still to be adjusted.
- 40235–40241 (fn 2–4): Example C.1.5.7 is unspecified; "Give reference for why F as subspace is not LF".
- 40242 (fn 5): the Vogt reference.
- 40504 (fn 6); 40746, 40748, 40812, 40863 (fn 7–10).
- 40977 (fn 11): Prop. C.2.3.10 is "never cited".
- 41027 (fn 12).
- 41082 (fn 13): "Inserted hypothesis here that E and F are Hausdorff".
- 41083 (fn 14): proof of C.2.3.13(3) unclear.
- 41293 / 41313 (fn 15): Remark C.2.4.5 breaks off mid-argument.
- 41369, 41413, 41414, 41519 (fn 16–19).
- 42986 (fn 20): "Completeness of measures has been added" in Lemma C.4.4.1.
- 43047 (fn 21): same question for Lemma C.4.4.5.
- 43303: "§??".
- 42185: stray sentence fragment.
- Remark C.5.1.27 is duplicated as C.5.1.29.

## 2. Assessment of (i)–(vi)

**(i) Lemma C.3.2.2: correct, by my own argument.** Write A0 = Σ λ_m φ_m ⊗ y_m with y_m in a Banach disc B ⊂ E1. Then T A0 = Σ λ_m φ_m ⊗ Ty_m (T(B) is a Banach disc) and A0 T = Σ λ_m (φ_m∘T) ⊗ y_m. Both traces equal Σ λ_m φ_m(Ty_m). Injectivity of T is not needed; AP is needed only so that the traces are well defined (I re-derived C.3.2.1).
- The printed proof instead passes to a limit in the topology of precompact convergence "by adapting the method of [Lit-I]". The trace is not continuous in that topology, so this step is a gap in the proof, though not in the statement.
- Hypothesis (4), that A0 is nuclear into E1 with E1's own topology, is essential. Counterexample: E2 = ℓ², E1 = ℓ²(w) with w_{2k} = k⁴, w_{2k+1} = 1, T the inclusion, A e_{2k+1} = k⁻² e_{2k}, A e_{2k} = 0. Then A is nuclear on ℓ², A0 is bounded, but A1 is an infinite-rank partial isometry on ℓ²(w), hence not even compact.
- Nothing in Appendix C covers quotients or trace additivity along an invariant closed subspace. In Hilbert space additivity holds (tr A = tr PAP + tr (1−P)A(1−P)). In a Banach space a closed subspace of a space with AP can fail AP, and then the "trace" of the restriction is not well defined (the zero operator has representations with trace 1).

**(ii) Corollary C.3.5.5: correct as stated.** It requires orthogonal projectors, nested ranges and union dense in H (limit = Id). Both orders are stated; TP_i is proved via adjoints, legitimately since P_i = P_i*. Prop. C.3.6.5 is the correct general form (right factor self-adjoint).
- For non-self-adjoint projections the right-composition fails. Take P_n = I − ⟨·,e_n⟩(e_1+e_n) (bounded projections, P_n → I strongly) and T = ⟨·,e_1⟩e_1. Then TP_n − T = −⟨·,e_n⟩e_1 has trace norm 1 for all n.
- Trace convergence survives regardless, since tr(TP_n) = tr(P_nT).
- C.3.6.5 is for sequences; nets need uniform boundedness.

**(iii) Bases versus traces.** Lemma C.3.6.3 is not about bases; it is the singular-value lemma, and part (1) is false (see §4). The appendix contains no lemma computing a nuclear trace from a Schauder or Markushevich basis: only C.3.4.1 (orthonormal bases) and a prose remark (41425–41427) that with AP traces "can be computed as matrix traces relative to a Schauder basis". Lidskii's theorem appears nowhere in the 940 pages (grep).
- Schauder case: the remark is true, contrary to the concern in the brief. For a Schauder basis with equicontinuous partial-sum projections P_N, tr(P_NA) = Σ_{m≤N} θ_m(Ae_m) → Tr(A) by dominated convergence on Σ λ_kφ_k(P_Nx_k). Convergence is in basis order only.
- Markushevich case: false. If the basis is not Schauder, uniform boundedness gives x, φ with Σθ_m(x)φ(e_m) divergent, and the rank-one operator φ⊗x has divergent diagonal sum. Concretely: exponentials in C(T), φ = δ_0, f with Fourier series divergent at 0.

**(iv) Nuclearity of quotients and induced operators.** C.2.4.10 is correct (citation). "Nuclear operator" on a general locally convex space (41620) is well defined. I verified that on a quasi-complete nuclear space, nuclear = bounded (maps some 0-neighbourhood into a bounded set). This is restrictive: convolution by a test function on a Schwartz-type Fréchet space is typically not bounded.

**(v) Pettis integrals.** C.4.3.5 is correct, but only for finite measures and compactly supported continuous integrands into a quasi-complete space. B_SOT(H) qualifies (C.3.3.1), as does L_S(E,E) for barrelled quasi-complete E (C.2.1.7). C.4.3.11 covers the Hilbert case with ‖f(x)‖ integrable. Continuity of g ↦ φ(g)ρ(g) into the chosen operator topology must be supplied by the main text.

**(vi) Open mapping.** Theorem C.1.5.5 (continuous linear surjection from a countable union of Fréchet images onto a Hausdorff LF-space is open) is correct, and I checked the proof. Two small points:
- If F is not locally convex, the appeal to the universal property needs the fact that countable locally convex inductive limits are also inductive limits in the category of topological vector spaces.
- In Lemma C.1.5.4 the second Baire step uses only density of p(H_k0), where non-meagreness is needed (40078–40088); standard fix.

The target must be LF in its own topology. A closed subspace of an LF-space with the induced topology does not qualify; the appendix handles this correctly through limit subspaces. Cor. C.1.5.13 is correct given C.1.5.11, but assumes E/F is itself a strict LF-space of nuclear Fréchet spaces.

## 3. Range of validity and later uses

- **Hilbert only:** C.3.3–C.3.7.
- **Any locally convex space with AP:** C.3.2.1, C.3.2.2.
- **General:** C.1, C.2, C.4, C.5 (quasi-completeness where stated).

Main-text uses I sampled (these are outside my range, so observations only):
- 27805 (Ch. 10): closed subspace of a Hilbert space; A0 = (orthogonal projection)∘A is nuclear. Valid.
- 25739 (Ch. 9): nuclearity on W^s_I is inferred from nuclearity on L² and then C.3.2.2 is invoked. This needs the factor L² → W^s_I to be nuclear, which the cited Schaefer corollary does not give; my ℓ²(w) example shows it is not automatic.
- 31210 (Ch. 12): E1 is a nuclear space. For nuclear Fréchet or strict nuclear LF E1, I checked that every continuous map from a Banach space into E1 is nuclear, so what must be verified there is continuity of the factor map into E1's own topology.
- 27840: cites C.3.5.5 for multiplication operators M_ρ, which are not projections. The conclusion follows from C.3.6.5 (left composition).
- 29478: the limit is P^geom, not Id. It needs orthogonality, nestedness and density in the range of P^geom.
- 30200–30202: "P_m T P_m → T" with P_m the individual eigenprojections is false as written (P_m → 0 strongly); it should use partial sums, and it presumes T ≥ 0.
- 30294–30331: cite C.3.4.4, which covers only finite-rank F, for nuclear T.
- 27273: A(φ)∘P_{B_K} with orthogonal P_{B_K}. Consistent with C.3.6.5.

## 4. Ranked problems

**(A) False as stated (all locally fixable; none invalidates C.3.2.2, C.3.5.5 or C.3.6.5)**
1. Lemma C.3.6.3(1) (42249). Counterexample: A = diag(1,0), B = diag(0,1), σ_2(A+B) = 1 > 0. Correct form: σ_{m+n−1}(A+B) ≤ σ_m(A)+σ_n(B). It is used at 42334 to "derive" the Schatten triangle inequality, which is true but does not follow this way.
2. Lemma C.3.4.4(2) (41886): the equality ‖AT‖_Tr = ‖TA‖_Tr. Counterexample: T = E_11, A = E_12 gives AT = 0, TA = E_12. Not used in the appendix.
3. Lemma C.3.4.1(2) (41837). Counterexample: T = [[0,1],[1,0]] gives 0 in the standard basis and 2 in the eigenbasis.
4. Lemma C.5.1.13(1) (43428) and Def. C.5.1.23: global Lipschitz bound. Counterexample: f(x) = x². Only the local statement is proved.
5. Formula (C.5.3.8) (44200): the exponent should be k, not k−1.
6. Minor false sentences: 42082 ("P_iT nuclear since finite rank"); 40273 ("Schwartz implies nuclearity", reversed); 41545 ("E is a nuclear Fréchet space" for an LF-space).

**(B) Gaps**
- Proof of C.3.2.2 (final limit step).
- Baire step in C.1.5.4.
- Remark C.2.4.5, unfinished.
- Proof of C.2.3.13(3) (author's own footnote 14).

**(C) Not well defined**
- Def. C.5.1.26: the topology is described by uniform convergence only, contradicting Remark C.5.1.28.
- Lemmas C.4.3.9–C.4.3.12: complex μ where |μ| is needed.
- Prop. C.3.5.1: "cofinal subsequence" must be increasing.
- Def. C.5.3.1: indices.
- Prop. C.2.3.13(1): stray J, F_j.

**(D) Unfinished**
- Example C.1.5.7 and the footnotes listed in §1.

## 5. Verified versus reported

**Verified by my own argument:** C.3.2.1; C.3.2.2 (new short proof); C.3.4.3; C.3.4.4(5); C.3.5.1; C.3.5.3–C.3.5.5; C.3.6.3(2),(3); C.3.6.5; C.1.5.1; C.1.5.4–C.1.5.5; C.1.5.13 (modulo C.1.5.11); C.1.6.1; C.2.3.10–C.2.3.12; the embedding in C.2.3.13(2); C.2.3.14 (modulo C.1.5.13); C.2.5.1–C.2.5.2; C.4.3.1; C.4.3.5; C.4.3.7–C.4.3.8; C.4.4.1; C.5.4.1; C.5.4.3; and all counterexamples above.

**Reported only (citations not checked against sources):**
- C.1.5.11: consistent with Wengenroth's acyclic ⇔ regular theory, not reproved.
- C.2.3.6(2); C.2.3.9(1); C.2.4.x; C.3.6.4; C.3.7.1 (Brislawn); C.5.1.30; C.5.2.6.

**Could not determine:**
- C.2.3.13(1) (products versus the inductive tensor product).
- C.2.3.13(3) for completed tensor products in the bornological case.
- C.4.4.4 without σ-compactness.
