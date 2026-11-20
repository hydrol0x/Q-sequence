<!-- Report of an automated reviewer (a Claude subagent) asked to referee this part of the draft. Unedited. Items marked [V] were derived by the reviewer; they have not all been independently re-checked. -->

# The "one prime at a time" step, F = Q, trivial character: what can be proved

**Delivery note.** Saving `REPORT.md` was refused by the harness (sub-agents may not write report files), so this message is the full report. Scripts and outputs are saved in `/tmp/claude-0/-home-user-Q-sequence/85c7cd58-d569-5e27-bf4a-0ff8a903944a/scratchpad/prover/` (`zk.py`, `const.py`, `zeros.py`, `zk_output.txt`, `const_output.txt`, `zeros400.json`).

Tags: **PROVED** (argument below), **GIVEN** (from the task statement), **CITED** (theorem numbers from memory, no network), **CONJECTURAL/NUMERICAL**.

## 0. Verdict

The missing step cannot be supplied. For `0 < a < 1/2` it is, depending on how it is made precise:

- **vacuous** as a Hilbert-space filtration of the twisted theta space (Theorem 1);
- **false, unconditionally**, as a statement about pieces of the kernel (Theorem 4);
- **equivalent to a zero-free half-plane** `Re s > 1/2 + a` as a limit on the one-sided cut-off spaces, hence to RH for all `a > 0` together (Theorems 3, 5);
- in Connes' cut-off form, a theorem for fixed `S`, with uniformity in `S` equivalent to RH (cited only).

The draft's per-prime trace is correct. With the twist it gives exactly Weil's prime terms, but only for half-width `a > 1/2`, where the formula is Weil's explicit formula and carries no information on RH (Theorem 2).

## 1. Setting

`Mψ(s) = ∫ψ(x)x^s dx/x`; `U_λψ(x) = ψ(x/λ)` has multiplier `λ^s`; `A(φ)` has multiplier `Mφ(s)`. Sobolev degree `b = 0`. `M : W_a → H²(Σ_a)`, `Σ_a = {|Re s| < a}`, is an isomorphism (Plancherel, Paley–Wiener); norm = L² of boundary values. Twisted thetas: `M[x^{1/2}Σ_n f(nx)](s) = ζ(s+1/2)Mf(s+1/2)`. Euler-factor removal: `D_p = 1 − p^{-1/2}U_{1/p}`, multiplier `1 − p^{-(s+1/2)}`; untwisted `D_p^0 = 1 − U_{1/p}`, multiplier `1 − p^{-s}`. `E_K(w) := Π_{p≤K}(1 − p^{-w})`.

**(H0) GIVEN.** `V = B_ζ H²(Σ_a)` (`B_ζ` = Blaschke product of the points `ρ − 1/2 ∈ Σ_a`), and for `ψ ∈ C_c^∞(R_{>0})` the compression of `A(ψ)` to `V^⊥` has trace `Σ_{|Re ρ−1/2|<a} Mψ(ρ−1/2)`.

**(W) CITED** (Weil 1952; Bombieri, Rend. Lincei 2000, formula (1.1) with `f = x^{-1/2}φ`). For `φ ∈ C_c^∞((1,∞))`:

$$
\sum_{\rho}M\varphi(\rho-\tfrac12)=M\varphi(\tfrac12)+M\varphi(-\tfrac12)-\sum_p\log p\sum_{n\ge1}p^{-n/2}\varphi(p^n)-\int_1^\infty\varphi(x)\frac{x^{1/2}}{x-x^{-1}}\frac{dx}{x}=:W(\varphi).
$$

**`T_a`** := the draft's main theorem for `I = [−a,a]`: `Σ_{|Re ρ−1/2|<a} Mφ(ρ−1/2) = W(φ)` for all `φ ∈ C_c^∞((1,∞))`.

## 2. Lemmas

**Lemma U. PROVED.** `Z` a multiset in a vertical strip with `O(R²)` points of height `≤ R`; `c_z` bounded, non-zero; `J = (1,∞)` or `(0,c)`. If `Σ_z c_z Mψ(z) = 0` for all `ψ ∈ C_c^∞(J)`, then `Z = ∅`.
*Proof.* For `λ ≥ 1`, `ψ(·/λ) ∈ C_c^∞(J)`, so `Σ_z b_z e^{zℓ} = 0` for `ℓ ≥ 0`, `b_z = c_z Mψ(z)`, `Σ|b_z| < ∞`. Laplace transform: `Σ_z b_z/(w − z) ≡ 0`, meromorphic with residues `b_z`; so `c_z Mψ(z) = 0` for every `ψ`, impossible. ∎

**Lemma R (lattice quotients). PROVED.** `|κ| < a`, `m_p(s) = 1 − p^{-(s+κ)}`, `s_k = −κ + 2πik/log p`, `B_p` their Blaschke product, `N = ΘH²(Σ_a)`, `Θ` inner.
1. `‖m_pF‖ ≥ δ‖F‖`, `δ = min(1 − p^{-(a+κ)}, p^{a−κ} − 1)`; `m_pN = ΘB_pH²` is closed.
2. The operator induced by `A(φ)` on `N/m_pN` is trace class with trace `Σ_k Mφ(s_k) = log p Σ_n p^{-κn}φ(p^n)`.
3. `Π_{p∈P} m_pN = ΘΠB_pH²` strictly decreases in `P`; the intersection over all `P` is `{0}`.

*Proof.* (1) The bound is read off on the two boundary lines. `m_p = B_p·S·O`; `m_p` is entire and zero-free on `∂Σ_a`, so `S = exp(−c_+e^{−iπs/2a} − c_−e^{iπs/2a})`. That forces double-exponential decay on a line `Re s = σ_0 ≠ −κ`, where `|m_p| ≥ |1 − p^{-(σ_0+κ)}| > 0`; so `S = 1`. `|O| ≥ δ` on the boundary gives `1/O ∈ H^∞`.
(2) `N/m_pN ≅ K = H² ⊖ B_pH²`. With `F(z) = ∫g(u)e^{zu}du`, `‖F‖² = ∫|g|²·2cosh(2au)du`, the kernel is `K(z,w) = ∫e^{(z+\bar w)u}du/(2cosh 2au) = (π/4a)sec(π(z+\bar w)/4a)`. For `k_j = K(·,s_j)`, `ω(u) = e^{−2κu}/(2cosh 2au)`, `Ω(u) = Σ_m ω(u + m log p) ∈ [c_1,c_2]`, `c_1 > 0`:

$$
\Big\|\sum_jx_jk_j\Big\|^2=\int_0^{\log p}\Omega(u)\Big|\sum_jx_je^{2\pi iju/\log p}\Big|^2du\in[c_1,c_2]\cdot\log p\sum_j|x_j|^2 .
$$

So `{k_j}` is a Riesz basis of `K` (complete since `F ∈ K`, `F(s_j) = 0 ∀j ⟹ F ∈ B_pH² ∩ K = 0`). The compression `C` has `C^*k_j = \overline{Mφ(s_j)}k_j`, so `C^*` is similar to a diagonal trace-class operator; `Tr C = Σ_j Mφ(s_j)`; Poisson summation gives the closed form.
(3) Same factorisation; every `m_p` vanishes at `s = −κ`, so the intersection consists of functions vanishing to infinite order there. ∎

**Lemma P. PROVED, unconditional.** For `0 < Re w = σ < 1`:

$$
\log E_K(w)=-\frac{K^{1-w}}{(1-w)\log K}\Big(1+O_w\big(\tfrac1{\log K}\big)\Big);
$$

if `Im w ≠ 0`, `limsup_K|E_K(w)| = ∞` and `liminf_K|E_K(w)| = 0`.
*Proof.* `Σ_{p≤K}p^{-w} = ∫x^{-w}dπ(x)`, `π = li + O(xe^{−c√log x})`; one integration by parts; the terms `m ≥ 2` of `−log(1 − p^{-w})` are `O(K^{1−2σ} + log K)`. Then `Re log E_K = −(K^{1−σ}/(|1−w|log K))(cos(θ_w − t log K) + o(1))`, and `t log K` is dense mod `2π` along primes with gaps `→ 0`. ∎

## 3. Formulations (Deliverable 1)

**(A) Filtration and trace additivity.** Space `W_a`; `V_K = closure(Π_{p≤K}D_pV)`; trace of the piece at `p` := trace of the operator induced by `A(φ)` on `V_{p^-}/V_p`. Needed: (A1) this is `log p Σ_n p^{-n/2}φ(p^n)`; (A2) `Σ_{ρ∈strip} + Σ_p Tr_p` equals an independently computed `S`-local quantity.

**(B) Pieces of the kernel.** On thetas the draft's stratum indicator `α_K` acts as `Π_{p≤K}D_p`; level `K` of the geometric operator is `P_VA(φ)Π_{p≤K}D_p`, of mass `−Z_K(φ)` (reading: mass is linear, equals the diagonal integral for convolution kernels and the trace on trace-class operators):

$$
Z_K(\varphi)=\mathrm{Tr}\Big(P_{V^\perp}A(\varphi)\prod_{p\le K}D_p\Big)=\sum_{|\mathrm{Re}\,\rho-1/2|<a}M\varphi(\rho-\tfrac12)\,E_K(\rho)\quad\text{(PROVED from H0)}.
$$

Needed: (B1) the increment at every `p > T` is zero, for every chain of primes; (B2) `lim_K Z_K(φ)` exists; given (B1) it must equal `Z_0(φ)`.

**(C) One-sided cut-off spaces** (the draft's "S-local carvings"/"Paley–Wiener levels": one-sided support, semigroup `λ ≥ 1`). `H_α = L²([1,∞), x^{2α}dx/x)`, `(τ_ng)(x) = g(nx)`, `E_K = Π_{p≤K}(1 − p^{-1/2}τ_p)`, and `E_∞g = Σ_n μ(n)n^{-1/2}τ_ng` on the dense space `D` of compactly supported `g` (finite sums; `E_Kg = E_∞g` once `K ≥ sup supp g`). `E_∞` is the degeneration from global to `{∞}`-local thetas. Needed: convergence `E_K → E_∞` strong enough to pass to traces; at minimum `E_∞` closable.

**(D) Connes cut-offs.** `Tr(R_Λ^SU(h)) − 2h(1)log'Λ − Σ_{v∈S}∫'h(u^{-1})|1−u|^{-1}d^*u → 0` as `Λ → ∞`, uniformly in `S`.

## 4. Results (Deliverables 2, 3)

**Theorem 1 (A, twisted). PROVED.**
(a) `0 < a < 1/2`: `Π_{p≤K}D_p` is an automorphism of `W_a`, of norm `Π_{p≤K}(1 + p^{a−1/2})` and inverse norm `Π_{p≤K}(1 − p^{a−1/2})^{-1}`, both unbounded in `K`; `V_K = V` for all `K`. All quotients are zero, so all per-prime traces are zero, including those of `p ≤ T`. No strong limit exists, and `E_K(s+1/2)` diverges at every non-real `s ∈ Σ_a`.
(b) `a = 1/2`: `1 − p^{-(s+1/2)}` is outer and not invertible; `D_pV` is dense in `V`, not closed; `V_K = V`.
(c) `a > 1/2`: `V_K = B_ζΠ_{p≤K}B_pH²` strictly decreasing; `Tr(A(φ)|V_{p^-}/V_p) = log p Σ_n p^{-n/2}φ(p^n)`; `∩V_K = {0}`.
*Proof.* (a) `|p^{-(s+1/2)}| ≤ p^{a−1/2} < 1` on the closed strip; multiplier norms are sup norms, attained on `Re s = −a` by Kronecker. `(ΠD_p)^{-1} = Σ_{n K-smooth}n^{-1/2}U_{1/n}` converges in norm and `V` is closed and scaling-invariant. Divergence: uniform boundedness and Lemma P. (b) `Re(1 − p^{-(s+1/2)}) > 0` in `Σ_{1/2}`. (c) Lemma R, `κ = 1/2`. ∎

So in the thin strip (A1) reads `0 = 0` and (A2) is `T_a` itself.

**Theorem 2 (what the per-prime trace gives). PROVED, with (W).**
(i) Untwisted factors, thin strip (`κ = 0`, the draft's computation): `V'_K = closure(ΠD_p^0V) = B_ζΠB_pH²`, each `D_p^0` has closed range, quotient trace `log p Σ_nφ(p^n)`, `∩V'_K = {0}`. The diagonal block traces sum to `Σ_{ρ∈strip}Mφ(ρ−1/2) + Σ_{p≤T}log p Σ_nφ(p^n)`. The weights `p^{-n/2}` are missing: these are prime terms of `ζ(s)`, coming from zeros on `Re s = 0`, unrelated to `V`.
(ii) Twisted factors, `1/2 < a < 5/2` (H0 assumed there): block traces sum to `Σ_{all ρ} + Σ_p log p Σ_n p^{-n/2}φ(p^n) = Mφ(1/2) + Mφ(−1/2) − Arch(φ)`, which is (W).
`A(φ)` is not trace class on `W_a`, so the block sum is a regularisation depending on the exhaustion; identifying its value is the whole content.

**Theorem 3. PROVED** (H0, W, Lemma U). `T_a ⟺ ζ(ρ) ≠ 0` for `Re ρ ≥ 1/2 + a`. So `T_a` is true for `a ≥ 1/2`, is a zero-free strip for a single `a < 1/2`, and is RH for all `a > 0`.
*Proof.* By (W), `T_a ⟺ Σ_{|Re ρ−1/2|≥a}Mφ(ρ−1/2) = 0` for all `φ`; Lemma U. ∎

**Theorem 4 (B).**
(i) **PROVED, unconditional.** For `0 < a ≤ 1/2`, `T > 1`, `P` a finite set of primes, the statement "for all `φ ∈ C_c^∞((1,T))` and all primes `p > max(T,P)`: `Σ_{ρ∈strip}Mφ(ρ−1/2)E_P(ρ)p^{-ρ} = 0`" is false.
*Proof.* `A(φ)p^{-1/2}U_{1/p} = A(φ^{(p)})`, `φ^{(p)}(x) = p^{-1/2}φ(px)`, ranging over `C_c^∞((1/p,T/p))`. For large consecutive primes `p' < Tp`, so the intervals cover `(0,c)`. Lemma U with `c_z = E_P(ρ) ≠ 0` gives no zeros in the strip; `ρ_1 = 1/2 + 14.1347i` is there. ∎
(ii) **PROVED, unconditional.** Every coefficient of `Z_K(φ)` diverges (Lemma P). `Z_K^{all}(φ) = Σ_{n|P_K}μ(n)W(φ^{(n)})`.
(iii) **CONJECTURAL/NUMERICAL.** Consistent with Conrad (Canad. J. Math. 57, 2005: at an order-`m` zero the partial product is `∼ L^{(m)}(s)/(m!(e^γ log x)^m)` under `ψ_L(x) = o(√x log x)`), Akatsuka (Kodai Math. J. 40, 2017: pole factor `exp(Li(x^{1−s}))`), and Kuo–Murty (2005):

$$
E_K(\rho)\approx\frac{e^{\gamma}\log K}{\zeta'(\rho)}\exp\big(E_1(-(1-\rho)\log K)\big).
$$

Then `Z_K(φ)` is unbounded when `Mφ(iγ_1) ≠ 0`. I could not prove divergence of the full sum, even under RH: the tail needs a bound on `E_K(ρ)` uniform in `ρ`.

**Theorem 5 (C). PROVED, unconditional.** Let `α > −1/2`. Under `\hat g(z) = ∫_1^∞g(x)x^{α−z}dx/x`, `H_α ≅ H²(Re z > 0)`, `τ_n^*` is multiplication by `n^{-(α+z)}`, `E_K^*` is multiplication by `E_K(1/2+α+z)`, and `χ_w(x) = x^{-w}` (`Re w > α`) satisfies `E_Kχ_w = E_K(w+1/2)χ_w`.
1. `‖τ_n‖ = n^{-α}`; every `E_K` is invertible; `‖E_K‖ = Π(1 + p^{-1/2−α})`. Again each single step loses nothing.
2. `α > 1/2`: `E_K → E_∞` in norm, bounded and invertible.
3. `α ≤ 1/2`: `sup‖E_K‖ = ∞`. For `α < 1/2` there is no weak limit: `‖E_Kχ_w‖/‖χ_w‖ = |E_K(w+1/2)|` has limsup `∞`, liminf `0` for `α < Re w < 1/2`, `Im w ≠ 0`.
4. **`E_∞` on `D` is closable `⟺ ζ(w) ≠ 0` for `Re w > 1/2 + α`.**

*Proof of 4.* `Dom(E_∞^*) = {F : F^♭ ∈ H_α}`, `F^♭(y) = Σ_{n≤y}μ(n)n^{-1/2−2α}F(y/n) = E_∞^*F`. Möbius inversion gives `\hat F(z) = ζ(1/2+α+z)\widehat{F^♭}(z)` on `Re z > 0`.
(⇒) A zero `w_0` forces `\hat F(w_0 − 1/2 − α) = 0` on the whole domain, which is then not dense.
(⇐) `β(z) = ζ(1/2+α+z)(z+α−1/2)(z+2)^{-2}` is bounded and zero-free, analytic across `Re z = 0`, and `β(x) ∼ 1/x` at `+∞`; so it has no singular inner factor and is outer. For `\hat F = βΨ`, `Ψ ∈ H²`, one gets `\widehat{F^♭} = Ψ(z+α−1/2)(z+2)^{-2} ∈ H²`. The domain contains the dense set `βH²`. ∎

**Corollary.** `E_∞` closable on `H_a ⟺ T_{a'}` for all `a' > a`. On the critical-line space `H_0`: closable `⟺` RH. Closable unconditionally for `α ≥ 1/2`, bounded only for `α > 1/2`. This is a Nyman–Beurling-type statement: the degeneration is multiplication by `1/ζ` in disguise.

**Formulation D. CITED, not re-proved.** Fixed `S`: Connes, Selecta Math. 5 (1999), Theorem 4. For `supp h ⊂ (1,T)` the terms of `p > T` vanish, so `lim_S lim_Λ` exists trivially and equals Weil's geometric terms; that is the correct form of "primes above `T` do not contribute". Uniformity in `S` is the global formula, equivalent to RH for Hecke L-functions (ibid. §VIII, Theorem 7, stated in positive characteristic; in characteristic 0 the definition of `Q_Λ` needs the prolate/Sonin construction). The `S`-local Fourier phase is `2 Im log E_K(1/2 − it)`, which has no limit as `S` grows (Lemma P).

## 5. Numerics

`φ(x) = g(log x)`, `g(u) = exp(1 − 1/(1−v²))`, `v = (u − 0.35)/0.30`, support `(1.051, 1.916)`; 400 zeros (height ≤ 679.7); primes to `10^7`.

| K | Z_K(φ), 400 zeros | Weil side Σ μ(n)W(φ^(n)) | \|E_K(ρ_1)\| |
|---|---|---|---|
| 1 | 0.05032764 | 0.05032789 | 1 |
| 2 | 0.02710206 | 0.02710247 | 1.678 |
| 5 | 0.00691087 | 0.00691132 | 3.587 |
| 13 | 0.03949927 | 0.03949972 | 5.848 |
| 10³ | 0.664595 | – | 16.36 |
| 10⁴ | 0.786041 | – | 43.80 |
| 10⁵ | −5.537432 | – | 76.43 |
| 10⁶ | −1.783740 | – | 2.396 |
| 3·10⁶ | 94.386035 | – | 563.3 |
| 10⁷ | −65.153117 | – | 3.6·10⁻⁵ |

Range of `Z_K` per decade (every 200th prime): `[10³,10⁴]`: −1.00 to 1.96; `[10⁴,10⁵]`: −7.87 to 9.57; `[10⁵,10⁶]`: −325 to 306; `[10⁶,10⁷]`: −9.2·10⁵ to 8.6·10⁵. The strategy needs the constant `Z_0 = 0.0503`. The Weil side agrees with the zero side to `5·10⁻⁷` for `K ≤ 13`.

Conjectural constant: `Re[log E_K(ρ) − E_1(−(1−ρ)log K) − log log K]` at `K = 10³,…,10⁷` is 0.774, 0.802, 0.794, 0.835, 0.798 for `ρ_1` (predicted `Re(γ − log ζ'(ρ_1)) = 0.809`); 0.449 predicted, 0.45–0.49 observed for `ρ_2`; 0.254 predicted, 0.17–0.26 observed for `ρ_5`.

## 6. Strip versus line (Deliverable 4)

- The collapse holds on the line too: `|1 − p^{-1/2−it}| ≥ 1 − p^{-1/2}`.
- Only in the strip (`b = 0`): interior point evaluations, the untwisted quotients of Theorem 2(i), closed range of `1 − U_{1/p}` (bounded below by `1 − p^{-a}`).
- The strip gives the family `T_a`, true for `a ≥ 1/2`; but the spectral side is a step function of `a`, jumping exactly at `a = |Re ρ − 1/2|`, so nothing continues below `1/2`.
- Nothing helps: the bound `p^{a−1/2} < 1` that keeps the twisted Euler zeros outside the thin strip is the same bound that makes each step invertible.

## 7. Conclusion (Deliverable 5)

**Theorem.** Let `0 < a < 1/2`, `b = 0`; assume H0 and (W).
1. (PROVED) `V_K = V` for all `K`; all per-prime quotient traces vanish identically.
2. (PROVED) `T_a ⟺ ζ(s) ≠ 0` on `Re s ≥ 1/2 + a`; and `ζ(s) ≠ 0` on `Re s > 1/2 + a ⟺` the degeneration operator `E_∞` is closable on `L²([1,∞), x^{2a}dx/x)`.
3. (PROVED) At operator level, vanishing of the piece at every large prime is false, and the coefficients of the remainder `Z_K(φ)` have no limit.
4. For all `a > 0` together, item 2 is RH.

The strategy therefore needs a statement that is empty, false, or equivalent to what it is meant to prove. No reduction strictly easier than RH results.

## 8. Not settled

- Divergence of the full sum `Z_K(φ)`: numerical and conditional only.
- Formulation D is cited from memory; I did not re-prove Connes' theorems.
- H0 is assumed (the draft's strip version is unproved per the earlier review). `b > 0` and general `F, χ` were not treated; for `χ ≠ 1` there is no pole, and "false unconditionally" in Theorems 4(ii), 5(3) should become "equivalent to a zero-free half-plane" (Conrad).
- The draft's Paley–Wiener levels were matched to (C) by their defining properties, not line by line.
- Prior note: its Lemma 1 is correct. Its claim that `1 − U_p` has non-closed range holds on the 0-line (the draft's Prop. 11.2.0.1) but not in a strip `a > 0`, where the range is closed. Its claim that one-sided cut-off ranges are dense is correct and sharpens to invertibility for `α > 0`.
