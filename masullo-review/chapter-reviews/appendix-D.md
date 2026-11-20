<!-- Report of an automated reviewer (a Claude subagent) asked to referee this part of the draft. Unedited. Items marked [V] were derived by the reviewer; they have not all been independently re-checked. -->

REFEREE REPORT: Appendix D "Schwartz-Bruhat functions" (layout.txt lines 44277-48803)

VERDICT. The basic objects are correctly defined and the main structural statements are true, but one theorem is false as stated, the topology on S_I(G) is used inconsistently, and the periodisation theorem is proved only for compact subgroups. Many D.3 proofs are unfinished: there are 21 internal reviewer/author footnotes, one of which says "Too many loose ends".

1. INVENTORY (status; "true" = I re-derived the statement)

D.1
- D.1.1.1, D.1.1.2, D.1.2.3-D.1.2.5, D.1.2.7 (duality, Fourier transform, fundamental domains, Poisson): citations to Rudin, Deitmar-Echterhoff, Bourbaki. Fine.
- D.1.2.1 (Weil formula, 44476): citation; one clause is false (problem 6).
- D.1.3.1-D.1.3.7 (S(G) for G = R^m x T^n x Z^r x F: Fréchet, nuclear, Montel, completed pi-tensor product of its factors): full proofs; footnotes 1, 2 mark omissions.
- D.1.4.x (structure theory): citations.
- D.1.5.1-D.1.5.4 (good subgroup k: compact with compactly generated annihilator; structural pair (k,Γ); S(G) = colim S(Γ/k)): full. Proof of D.1.5.4(i) at 45338 wrongly says k is a product of T-factors and a subgroup of F; this is fixable, and D.1.6.18 does it properly.
- D.1.5.6, D.1.5.7 (G second countable: countable strict LF, complete, nuclear, Montel, barrelled, bornological; strong dual complete, nuclear, Montel): full; true.
- D.1.5.9, D.1.5.10 (acyclicity): citations to Wengenroth and Vogt.
- D.1.6.x (one-parameter subgroups, Diff(G), symbols): full, minor slips.
- D.1.6.18 (averaging over a compact k maps S(A) onto S(A/k)): full.
- D.1.6.19 (F(Df) = p(D)·F(f); F: S(G) → S(Ĝ) is a topological isomorphism; compatibility with projectors): (1), (2) proved modulo measure constants; (3) is asserted, and footnotes 3-8 doubt it.
- D.1.7.1 (periodisation Φ_k: S(G) → S(G/k) for closed k is continuous and surjective, a quotient map if G is second countable, plus the Poisson identity): problem 3.
- D.1.8.1 (S(G1) ⊗̂_ι S(G2) ≅ S(G1 x G2), and duals): proof via Appendix C; (1) true.
- D.1.8.3, D.1.8.4 (supports): full.
- D.1.9.1-D.1.9.4 (G x S(G) → S(G) jointly continuous): full; true.
- D.1.10.x (seminorm families on S(C_F), S(C_{F,S})): full or sketch; skimmed.

D.2
- D.2.1.1 (modulated group: second countable, proper non-trivial |·|: G → R_{>0}, so G^1 is compact).
- D.2.2.1-D.2.2.3 (isotypes): proofs; footnote 10 says the wrong lemma is cited, footnote 11 says D.2.2.3 is never used.

D.3 (all read)
- D.3.1.1 (Cauchy estimates on substrips): full, correct.
- D.3.1.2, D.3.1.3 (AS(C_I), I open, is Fréchet; the L^p-on-lines topology equals the Schwartz topology on lines): full, correct.
- D.3.2.1, D.3.2.3 (S_I(R_{>0}), any interval, projective topology; nuclear Fréchet): full, correct. Parts (4)-(6) are "by definition" (footnote 12).
- D.3.2.5 (I open: Mellin gives S_I(R_{>0}) ≅ AS(C_I)): surjectivity is a sketch citing B.2.1.8 (footnote 13). True.
- D.3.2.7 (weighted L^2 seminorms on S_E(R_{>0})): correct, by Plancherel.
- D.3.3.1-D.3.3.3 (S_I(G); S_I(k,G) projective; S_I(G) = inductive limit over k, 47874). D.3.3.2: sketch.
- D.3.3.7 (47928): (1) S(G^1) ⊗̂_ι S_I(R_{>0}) ≅ S_I(G); (2) strict LF, complete, nuclear, Montel; (3) dual; (4) for compact I, inductive = projective topology. Depends on D.3.3.10 and C.2.3.12-14.
- D.3.3.10 (bounded sets; S_I(R_{>0}) ⊗̂ S(k,G^1) ≅ S_I(k,G)): proof flagged by footnotes 17-21; problems 4, 5.
- D.3.3.12 (isotypic projector; continuity of the G-action): proof is for the wrong topology (problem 2).
- D.3.3.13 (I open: Mellin gives S_I(G) ≅ S(Ĝ^1) ⊗̂ AS(C_I)): full; correct given D.3.3.7(1).
- D.3.4.2 (uniform Riemann-Lebesgue): false as stated (problem 1).
- D.3.5.1 (Poisson with jumps): citation to B.4.1.2.
- D.3.6.1 (C_c^∞(G) dense in S_I(G)): true; the proof has two defects (problem 8).

Author notes (footnote number: line): 1: 44840; 2: 45052; 3: 45877; 4: 46004; 5: 46075; 6: 46077; 7: 46129; 8: 46131; 9: 47322; 10: 47430; 11: 47433; 12: 47736; 13: 47738; 14: 47902; 15: 47953; 16: 48007; 17: 48114; 18: 48116; 19: 48118; 20: 48119; 21: 48179. Also "Chapter ??" at 46144.

2. CHECKS

(a) The definition is Bruhat's. "k good" is equivalent to G/k Lie, so the pairs are Bruhat's pairs. Transition maps are closed topological embeddings (D.1.5.4), and second countability gives a cofinal sequence. So S(G) is a countable strict LF-space; completeness (Schaefer II.6.6), nuclearity and the Montel property follow. Test cases:
- Q_p: locally constant, compactly supported; finest locally convex topology.
- Q_p^×: invariant under some 1+p^m Z_p, rapidly decreasing in the valuation.
- A_Q: S(R) ⊗ S(A_f), complete. A_Q is not compactly generated.
- R_{>0} x K: union over k of S(R x K/k).

(b) Appendix D has no Mellin theorem for compact or half-closed I; D.3.2.5 and D.3.3.13 are for open I only, and B.2.2.3(1) (36091) gives one direction. By my argument the correct image of S_{[a,b]}(R_{>0}) is the functions holomorphic on the open strip whose derivatives all extend continuously to the closed strip with s^N Φ^(k) bounded there. For I = R the image AS(C) and its topology are right. The formalisation of "uniformly Schwartz" is right only if J ranges over bounded intervals with closure in I; the parenthetical at 47525 omits "bounded" (with I = J = R it would force Φ = 0). Line 47633 says "positive rationals" for arbitrary I.

(c) The Mellin transform of an element of S_E is entire and rapidly decreasing on every bounded vertical strip. No growth order in Re(s) is claimed, correctly: the transform of e^{-x^2} (x = log t) is √π e^{s²/4}, and slower decay gives faster growth. Surjectivity holds: invert along one line, use Cauchy for independence of the line; each t^σ φ is then the inverse Fourier transform of a Schwartz function.

(d) S_I(R_{>0}) and S_I(G) are well defined for every non-empty interval; AS(C_I) for every open I, bounded or not. I found no ill-definedness. The defects for non-compact I are problems 1, 2, 5.

(e) See problem 3.

(f) See problem 6. Otherwise the hypotheses are adequate; σ-finiteness is correctly required in D.1.2.3.

3. WHAT LATER CHAPTERS MAY CITE
- S(G) for second-countable G: strict LF, complete, nuclear, Montel, with jointly continuous translation by G itself (D.1.5.7, D.1.9.2).
- F: S(G) ≅ S(Ĝ) and Fourier inversion.
- S(G1 x G2) = S(G1) ⊗̂_ι S(G2), inductive tensor product only. The π-topology is strictly coarser when one factor is non-normable Fréchet and the other is not Fréchet (S(R) with S(Q_p); Remark D.3.3.11).
- S_I(G) with the inductive topology: D.3.3.7. Mellin isomorphisms for open I only.
- Not in this appendix: restriction to closed subgroups, restricted products, continuity of the dilation action of ideles on S(A_F) (only translation is treated), compact-I Mellin isomorphisms, kernels of periodisation.
- Silent hypotheses: D.3 needs G^1 compact and |·| surjective, so G ≅ R x compact. This excludes Q_p^×, A_F^× and products of F_v^× over two or more places. Fréchet conclusions need Ĝ^1 finitely generated (G Lie). D.1.7.1 as proved needs k compact.
- Cross-reference slip: the main text cites "D.3.3.7(3)" (10998, 11034, 11114) for what is part (1).

4. PROBLEMS, RANKED

1. (A) Theorem D.3.4.2 (48509-48526) is false. It claims |M(φ)(c)| ≤ C/|p_D(c)| on the whole open strip Ω(G)_I. Counterexample: G = R_{>0}, I = (0,1), D = t∂_t (so p_D = s), B = {φ} with φ(t) = χ(log t) Σ_{n≥1} e^{-n} t^{-1-in}, χ smooth, 0 on x ≤ 0, 1 on x ≥ 1. All (t∂_t)^k φ are O(1/t) at infinity and vanish for t < 1, so φ ∈ S_{(0,1)}. But M(φ)(s) = entire − Σ e^{-n} e^{s-1-in}/(s-1-in) has poles at 1+in, so sup over {0 < Re s < 1, |s| ≥ M} of |s·M(φ)(s)| is infinite for every M. The proof errs at 48613-48620: it takes the constant to be the L^1 norms of t^a(t∂_t)^r φ and t^b(t∂_t)^r φ at the endpoints a, b, which are not in I, and invokes the embedding of S_{[a,b]}. The statement is true on closed substrips, or for compact I. The uses I sampled (8359, 27222, 37692) concern functions whose transforms are holomorphic beyond the strip, so they look repairable.

2. (C) Two topologies on S_I(G). Definition D.3.3.3 gives the inductive one. The proofs of D.3.3.12 (48271, "topological embedding by design") and D.3.6.1 (48722), and the main text (10410-10420, 14180), use the projective one given by the maps T_a. D.3.3.7(4) equates them for compact I only. They differ whenever I is non-compact and Ĝ^1 is not finitely generated (e.g. S_E(C_F)). Proof: S(G^1) = ⊕_m E_m with all E_m ≠ 0 (as at 48216), so the inductive topology is ⊕_m S_I(R_{>0}) ⊗̂ E_m. Take a_m ∈ I tending to an end of I not in I. The seminorm Σ_m sup|t^{a_m}·| ⊗ sup-norm is continuous there, but is not dominated by finitely many T_b: test on φ_0(t/λ) ⊗ g, λ → ∞. So the main text's "projective topology ... nuclear strict LF" (10410-10418) is wrong as written. Repair: the bounded sets agree and the inductive topology is the bornologification, so a map from a bornological space that is continuous into the projective topology is continuous into the inductive one.

3. (B) Theorem D.1.7.1 (46148) is stated for closed k but proved only for compact k. The base case cited is D.1.6.18 (45885, compact k), and 46185 uses "G → G/k is proper". The main text applies it to k = γ^Z (11571, 11578). The statement is true there, by a cut-off ρ with Σ_n ρ(x+nℓ) = 1; the general elementary case is standard but absent.

4. (B, fixable) D.3.3.10 and hence D.3.3.7(1). (D.3.3.7) is unproved (footnote 21), and the bounded-set argument (48071-48102) rests on unverified ultrabornological claims. Short proofs exist:
- S_I(k,G) = C^∞(G^1/k; S_I(R_{>0})), since S_I(R_{>0}) is closed in a product of copies of S(R).
- (D.3.3.6) is bijective by the continuous-norm argument (48041-48070), which is correct.
- A bounded set of operators maps U° into one step, so the bounded sets agree.
- For part (2), k-invariance does not depend on a, so a projectively bounded set lies in one S_I(k,G).
Part (4) rests on C.2.3.14 (not checked); I confirmed it using the direct-sum decomposition.

5. (A, minor) D.3.3.10(3) (47998) and 48147: a countable J accumulating at the endpoints does not suffice when I contains an endpoint. For I = [0,1], ψ_n(x) = n·η(x+n) is bounded in every S_{a}, 0 < a < 1, and unbounded for a = 0.

6. (A, minor) D.1.2.1 (44483): "for every measurable f, f^H is defined a.e." fails for f ≡ 1 on R, H = Z. It needs f ≥ 0 or f ∈ L^1.

7. (D) D.1.6.19: measure normalisations unverified; (D.1.6.25) is not meaningful as printed; the projector property needs μ(Γ^⊥) = 1 (true; footnote 4 doubts it). The isomorphism statement is unaffected.

8. (D) D.3.6.1: after reducing to compact I, the seminorms sup|e^{ax} ∂^k φ| (48758) do not generate the topology, because polynomial weights are missing at the endpoints. The cut-off argument still works with them. Continuity is shown only for the projective topology.

9. (D) Continuity of the G-action on S_I(G) with the inductive topology (footnote 15) is not proved. It follows from Lemma D.1.9.1 with H_n = G.

10. (D) D.3.5.1 is a pure citation; the right side converges only conditionally (B.4.1.4) and hypothesis (2) calls a function with jumps "continuous". I could not determine whether B.4.1.2's hypotheses suffice.

11. (D) C^∞(G) is defined two inconsistent ways (45302 and 45371); characters are not in the second.

5. VERIFIED VERSUS REPORTED
- Verified by my own argument: (a); D.1.8.1(1); D.1.9.2; the isomorphism in D.1.6.19(2); D.3.1.1; D.3.1.2; D.3.2.3; D.3.2.5; D.3.2.7; the statements of D.3.3.7(1), (2), (4) and D.3.3.10(1), (2); D.3.3.13; D.3.6.1; all counterexamples above.
- Reported, not checked: every Appendix B and C citation (B.2.1.8, B.2.2.4, B.4.1.2, C.2.3.12-14, C.1.5), the external references, and the detailed seminorm computations in D.1.10.
