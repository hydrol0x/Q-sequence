<!-- Report of an automated reviewer (a Claude subagent) asked to referee this part of the draft. Unedited. Items marked [V] were derived by the reviewer; they have not all been independently re-checked. -->

REFEREE REPORT: Chapter 11 "The Shell Structure" (lines 28673-30052)
File: /tmp/claude-0/-home-user-Q-sequence/85c7cd58-d569-5e27-bf4a-0ff8a903944a/scratchpad/masullo/layout.txt

Whole range read sequentially. "Model" = F=Q, chi=1, u=log x, weight w=(1+u^2)^{s/2}, sigma=s/2, P_p phi(u)=phi(u)-phi(u+L), L=log p (Mellin side: multiplication by 1-p^{-it} on H^sigma(R_t)). Items marked [V] I proved myself; [T] is reported from the text.

## 1. Inventory

**11.1.1 (28701-28963)**
- Lemma 11.1.1.1: a pointwise limit of Schwartz-Bruhat functions is Borel on GL_1(A_F). Full proof, trivial, correct.
- Prop 11.1.1.2: f_k -> f pointwise on Z; alpha >= 0 with J(alpha)(g)=sum_{xi in I_Z} alpha(xi g) in L^r(Z,eta); hypothesis (11.1.1.2): sum_xi |f_k(xi g)| <= J(alpha)(g). Claims (1) sum f(xi g) converges absolutely and Phi(f) is Borel; (2) Phi(f_k) -> Phi(f) in L^r. Full proof (about 75 lines); it cites (11.1.1.11) where (11.1.1.2) is meant.
- Cor 11.1.1.4 (pointwise version) and Cor 11.1.1.5 (C_F^1-isotypic version): short proofs with broken labels ((11.1.1.12)/(11.1.1.13) cited in the wrong corollary) and stale notation ("c" for omega, "T_{v0}").

**11.1.2 (28967-29197)**
- Thm 11.1.2.1 (s >= 2[F:Q], rho in {1_{|g|>1/Lambda}, 1_{1/Lambda<|g|<Lambda}}). Let W_{0,rho}P_{S_i}H be the closure of M_rho PV_{S_i} H_{0,cont}.
  - (1) The intersection over a cofinal S_k is closed and independent of the sequence.
  - (2) For S_i inside S_i', the unrestricted and the rho-restricted spaces are nested; the unrestricted inclusion (11.1.2.5) is strict; for any Lambda_k -> infinity the restricted inclusion (11.1.2.6) is strict along a subsequence.
  - (3) The intersection equals the closed span of rho(g) sum_xi (f tensor prod_{v not in S} 1_{O_v^x})(xi g), f in S(A_{F,S}), f(0)=fhat(0)=0.
  - Proof: (1) complete; (2) begins "(2): [fn 4 Return here]" with no proof of the inclusions and "[fn 5 Return here]" in the middle of the contradiction argument; (3) one inclusion proved, the converse asserted.

**11.2 (29201-29390)**
- Prop 11.2.0.1 (s >= 0): H_{0,cont} is dense in W_0^{s,2}(C_F); (1) PV_{S0} is continuous; (2) for s >= 2|S0| its extension has closed range, equal to the intersection of the kernels of phi -> integral phi chi |g|^eps (log|g|)^m. Proof of (2) is a 10-line sketch ("proceeding as in ... Theorem 10.2.1.1, using the Approximation Principle").
- Thm 11.2.0.2: eta_{chi,eps,m} = chi |g|^eps (log|g|)^m, eps a zero of prod_{v in S0}(1-q_v^{-s-it_v}), m <= N_s(eps)-1, N_s = min(N, floor((s-1)/2)+1), lie in W^{-s,2}; for s >= 2|S0| they form a Markushevich basis of (PV_{S0}W)^perp. Proof: 8 lines, "formally analogous" to 10.2.1.1.
- Prop 11.2.0.4 / Cor 11.2.0.5: the eta's have norms in [1/C, C] ("normalized"). Short proofs.

**11.2.1 (29392-29562)**
- Def 11.2.1.1 / 11.2.1.3: Paley-Wiener levels and projectors P^PW, Q^PW. Notation is inconsistent: three different names for the target space; S', X undefined.
- Thm 11.2.1.2 / 11.2.1.4: (1) P^PW -> P_a^geom strongly; (2) P_{rho,a}^geom A(phi) P^PW -> P_{rho,a}^geom A(phi) in trace norm, hence traces converge. Proofs of 4 and 2 lines.

**11.2.2 (29564-29712)**
- Thm 11.2.2.1 (s >= 2[F:Q]): A(phi) is nuclear on E = W_0^{s,2}H / PV_{S_p}W_0^{s,2}H with trace sum_eps N_s(eps) integral phi chi |g|^eps. Sketch proof deferring convergence to 10.3.1.1(1).
- Remark 11.2.2.2: fine.

**11.3.1.1 (29716-29943)**: informal overview, no statements. First-person omissions at 29895-29904 ("here I am omitting several items ... We are going to omit all of this").

**11.3.2 (29945-30051)**
- Thm 11.3.2.1 (a=1/2, s>1, I=[-alpha,alpha], supp phi in |g|>1): 
  sum_{xi in F^x} integral_{g in E_F^1} ((alpha_{k+1}-alpha_k) k^Delta_{geom,a,I,s,phi})(tau(t), xi g tau(t)) dmu^1(g) dt/t = (log q_v / mu_v(O_v^x)) sum_{k in Z} phi(pi_v^k).
  Proof: about 45 lines of prose with no estimates.

**Author notes**: "Return here" footnotes 1-6, with markers at 28700, 28702, 28976 (theorem title), 29099, 29116, 29197 and footnote text at 28720, 28721, 29017, 29139, 29140, 29210.

## 2. Dependencies [T]
- 11.1.2.1 uses 11.2.0.1 and 11.2.0.2 (forward references), 6.3.2.2, 6.2.1.1, 11.1.1.2, A.2.3.10.
- 11.2.0.1 uses 5.3.1.5, 10.2.1.1 (a=0), a Cassels-Fröhlich non-vanishing theorem, 9.3.2.1.
- 11.2.0.2 uses 10.2.1.1, 6.3.2.2, 9.3.2.1.
- 11.2.1.2 uses 7.3.2.2(1), C.3.5.5; 11.2.1.4 uses 7.3.2.4(4).
- 11.2.2.1 uses 11.2.0.2, 11.2.0.5, 10.3.1.1.
- 11.3.2.1 uses 11.1.2.1, Prop 12.2.2.2 (forward, Chapter 12), 2.2.3.2, 10.3.2.1, (11.2.2.12), 7.4.2.1, B.4.1.2.
- Near-circularity: the proof of Thm 7.4.2.1 (line 22046) cites "the calculation from (11.2.2.12) of Theorem 11.2.2.1".

## 3-4. Findings, ranked

**P1 (A) Prop 11.2.0.1(2) is false: PV does not have closed range on the 0-line.** [V]
- P_p is injective on L^2_w. Take phi_n(u)=psi(u/n), psi in C_c^infinity. Then ||phi_n||^2 ~ n^{1+s} while ||P_p phi_n||^2 <= C n^{-2} n^{1+s}. So P_p is not bounded below, and by the open mapping theorem its range is not closed. This holds for every s >= 0.
- The range is also not the intersection of the kernels: G(t)=(t-t_0)|t-t_0|^alpha (localised) with sigma-3/2 < alpha <= sigma-1/2 lies in H^sigma and vanishes at t_0, but G/(1-p^{-it}) is not in H^sigma.
- What is true: the closure of the range equals the intersection of the kernels (annihilator = {T in H^{-sigma}: mT=0}). The "Approximation Principle" argument can only give density.
- Lemma 5.3.1.5 concerns the Schwartz-type topology; the claim at 29219-29222 that closedness persists in Sobolev norm is unsupported.
- Consequences: the identity (11.2.0.3) is false; E^s_{0,S_p} as defined in (11.2.2.1) is a quotient by a non-closed subspace, so not a Hilbert space. Repair: use closures throughout.

**P2 (A) Thm 11.1.2.1(2), strictness of (11.1.2.6), is false.** [V]
- Claim: for every finite S_i, every Lambda, both rho's, the closure of M_rho PV_{S_i} H equals M_rho W^{s,2}.
- Proof: let f in W^{-s,2}, supported in |g| >= 1/Lambda, annihilate M_rho PV_{S_i} H. By the density of H (the draft's own 11.2.0.1), prod_v P_v^* f = 0, where P_v^* f(x)=f(x)-f(pi_v x). Put h = prod_{v != v_1} P_v^* f. Then h vanishes for |g|<1/Lambda and is pi_{v_1}^Z-invariant, so h=0. Induct to get f=0.
- Model with one prime, explicitly: any psi on u > -log Lambda extends by -per(psi) on one period to a function with zero periodisation.
- So (11.1.2.6) is an equality for all Lambda, in the model and in general given density.
- The proof's step "M_{rho_Lambda} -> Id strongly forces (11.1.2.5) non-strict" is a non sequitur: equal closures of M_rho X' and M_rho X for all Lambda do not give X'=X.
- Corollaries [V]: (1) is true but the limit is all of M_rho W. (3) is true but vacuous, since both sides are M_rho W: C_c^infinity functions on |g|>1/Lambda are realised after fixing fhat(0) with mass in |g|<1/Lambda. The "carving" therefore carves nothing on the 0-line.
- Strictness of (11.1.2.5) is true for s>1 [V]: delta at a new zero 2 pi k/log p. The proof cites 11.2.0.2, whose hypothesis s >= 2|S_i'| is not available.
- (11.1.2.11) is justified by "M_rho is idempotent hence has closed range", which does not show that M_rho of a closed subspace is closed. Unneeded for (1).
- (3) converse inclusion: only asserted ("W-bar_{S,Lambda} is exactly R_{Lambda,S}...", with R_{Lambda,S} undefined). (B)

**P3 (C, and B) Thm 11.3.2.1 is not well defined and its proof does not establish it.**
- Statement:
  - v is free on the right; k is both the stratum index and the summation index. The overview has sum over v in S_p.
  - No integral sign or range for t.
  - k_{geom,a,I,s,phi} is the a.e.-defined L^2 class of (10.4.3.50), defined for s >= 3 (here s>1). It is evaluated on a null set with no smoothening.
  - alpha_k lives on GL_1(A_F) and is not F^x-invariant; the variable it multiplies is unspecified.
  - (11.3.2.2) as printed is identically 0 [V]: for fixed x and xi at most one g in E^1 has xi g x in tau(R_{>0}), a mu^1-null set.
  - If instead u_0 = 1_{T.E^1}, then by (12.2.2.1) u_0^Delta(tau(t), xi g tau(t)) = delta_{xi,1}, and for F=Q (taking E^1 inside {1} x Zhat^x, which I did not check against A.2.3.14) (alpha_{k+1}-alpha_k)(g tau(t)) = 0. The left side would then be 0, not equal to the right side.
- Internal inconsistency [V]: Poisson summation applied to (11.3.2.5) (exponent eps_p - 1/2, fixed chi) gives log p sum_n phi(p^n) p^{-n/2} in the model, not log p sum_n phi(p^n). The right side of (11.3.2.1) has no chi and no |pi_v^k|^{1/2}; it matches (7.4.2.1), not (11.3.2.5). "(11.3.2.5) is the right side of (7.4.2.1)" is literally false.
- Proof gaps:
  - (i) The strata are decreasing, so alpha_{k1}(alpha_{k+1}-alpha_k) = 0 for k1 >= k+1 on the same variable [V]. Then (11.3.2.3) vanishes and "preserves the value" fails. Also supp alpha_{k0} does not contain GL_1(A_{F,S'}) x prod O_v^x, and lim alpha_{k1} is the indicator for S, not beta_{S'}.
  - (ii) Xi_k is not confined to a finite S' [V]: xi = p_{k+1} q for any larger prime q.
  - (iii) k1 -> infinity: only an "effect on an arbitrary Schwartz-Bruhat function" (strong, at best) is described, with no trace-norm convergence. The operator S(A_F) -> W_I^s is not an endomorphism, so its "trace" is undefined. Prop 12.2.2.2 concerns kernels on G/H x G/H, and the alpha-cut kernel is not one.
  - (iv) lambda': "large enough", no argument. The truncation ">lambda'" in (11.3.2.4) shrinks to the empty set as lambda' grows; presumably ">= 1/lambda'" is meant.
  - (v) Lambda -> infinity with epsilon Lambda = o(1): asserted. The left side of (11.3.2.1) contains no rho, and absolute convergence without the cutoff is never shown. No uniformity between the three limits.
  - (vi) Thm 11.1.2.1 (a=0, s >= 2[F:Q], a statement about subspaces) is invoked for convergence in W_I^s at a=1/2. (11.2.2.12) lives on the 0-line.
- Only the corollary "the right side vanishes when q_v exceeds the support of phi" is correct, and it is trivial.

**P4 (B) Thm 11.2.1.2(2) and 11.2.1.4(2): the limit is misidentified.** [V]
- With T = M_rho P^geom A(phi) nuclear and P^PW -> P^geom strongly, T P^PW -> T P^geom = M_rho A(phi) P^geom by (10.4.1.10).
- This differs from T by M_rho P^geom A(phi) P^spec, and the draft itself asserts P^geom A(phi) P^spec != 0 (27616).
- C.3.5.5 needs a dense union in the whole space, which fails at a=1/2.
- So (11.2.1.5) computes Trace(M_rho A(phi) P^geom); its equality with Trace(P^geom_{rho,a} A(phi)) is unproved.
- Part (1) is correct.

**P5 (A, minor and fixable) Prop 11.1.1.2(2) and Cors 11.1.1.4/5 are false as stated.** [V]
- A bound on sum_xi |f_k(xi g)| is not a termwise majorant.
- Counterexample: f_k = (psi(. - k)+psi(. + k)) tensor 1_Zhat. Then f_k -> 0 pointwise and sum_n |f_k(nx)| <= C(1+1/x), which is of the form J(alpha), yet Phi(f_k)(1) = psi(0) for all k.
- Repair: assume |f_k| <= alpha termwise. That holds in the one application (|P_{S_k} f| <= |f_S| tensor 1_Ohat), so the forward inclusion of 11.1.2.1(3) stands.

**P6 (A, boundary) N_s.**
- eta_m lies in W^{-s,2} iff m < (s-1)/2 [V]. The floor formula fails when s is an odd integer (e.g. s=1, m=0; s=3, m=1). It is harmless under s >= 2[F:Q].
- Prop 11.2.0.4 lets m run to N(eps)-1 with only s>1.

**P7 (B/D) Bases.**
- Thm 11.2.0.2 is plausible as a statement about the orthogonal of the closure [V in the model: minimal and total]; the proof is a sketch.
- The proof of 11.1.2.1(2) calls it a "Schauder basis". For S_0 with two residue characteristics the zeros 2 pi Z/log p and 2 pi Z/log q come arbitrarily close, so the system is not uniformly minimal and is not a Schauder basis [V].
- Thm 11.2.2.1 says the bi-orthogonal set is "also bounded" and cites Cor 11.2.0.5, which does not give that. It is true for a single p by periodicity of the zero set (period 2 pi/log p) [V].

## Checked and found correct [V]
- Lemma 11.1.1.1; Prop 11.1.1.2(1) (Fatou).
- Density of H in W_0^{s,2} for F=Q: zeta(it)(it-1) is smooth and non-vanishing, so T=0. For general F I could not determine whether "L(s,chi)" in 6.3.2.2/10.2.1.1 is the completed L-function; if it is the finite one, the trivial zeros on Re s=0 would break the cited argument.
- Prop 11.2.0.1(1).
- Thm 11.1.2.1(1), strictness of (11.1.2.5), and (3) (true but trivial).
- Thm 11.2.2.1 in the model, with E taken modulo the closure: E is isomorphic to l^2(Z), A(phi) is diag(M phi(i t_k)), and the trace is sum_k integral phi x^{i t_k} = log p sum_n phi(p^n). Formula (11.2.2.4) holds.
- Remark 11.2.2.2.
- Poisson equivalence of (7.4.2.1) with the right side of (11.3.2.1) for F=Q.

## Overall
The chapter's rigorous content (11.1.1, and 11.2.2 after replacing ranges by closures) is elementary. The two structural claims meant to carry the strategy do not hold up: the carving theorem 11.1.2.1 is vacuous or false on the 0-line, and Thm 11.3.2.1 is neither well defined nor proved. All three limit interchanges in 11.3.2.1 are unjustified.
