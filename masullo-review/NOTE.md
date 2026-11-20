# Notes on A. M. Masullo, "The Music of the Primes" (draft released 2026-11-20)

Source: `https://math216.wordpress.com/wp-content/uploads/2026/11/the-music-of-the-primes.pdf`
(940 pages, SHA-256 `e039d3f6cf0a4b14f03c7edb85097752dd65c0a2fe543c76fe992be234f97bf5`).

**Status of these notes.** Written 2026-11-20 by an AI model (Claude) in one working session. They are a
reader's report, not a refereed verdict. Sections 2–4 were worked by hand in the simplest case (the field of
rationals, trivial character). Section 5 summarises three line-by-line chapter reviews done by automated
reviewers; their full reports are in `chapter-reviews/`. Where a claim was re-derived independently it is
marked **checked**; otherwise it is marked **reported**. Nothing here bears on whether GRH is true.

## 1. Summary

1. The draft is released knowingly unfinished. Its acknowledgements say "the math is complete, and only filling
   in some writing remains". The parts that are not written are exactly the ones that carry the deduction of
   GRH: the section assembling the pieces of the kernel (12.3, empty), the statement of the final theorem
   (13.3.1.2, blank), and sections 13.1–13.2 (headings only).
2. The main theorem (12.5.1.1) is a trace formula that, combined with Weil's explicit formula, is equivalent to
   GRH. Its proof is six sentences. Each of the three results it cites fails to deliver what is used
   (section 5.3).
3. The step meant to do the work is: split a "geometric kernel" into one piece per prime outside a finite set
   S, show each piece has zero diagonal mass, and compute what is left S-locally. In every reading of the
   draft's definitions that could be constructed, this step is either vacuous or contradicts the main theorem
   (sections 3–4).
4. Several stated intermediate results are false as written, with explicit counterexamples (section 5).
   Some are repairable; the repairs do not restore the step in item 3.
5. What holds up: the foundational chapters were not examined; within chapters 10–12 the spectral statement on
   the critical line, the per-prime Poisson-summation trace on the 0-line, the Lebesgue-differentiation results
   on diagonals of nuclear kernels, and the algebra of the Connes-style S-local computation are correct.

Assessment: as it stands the draft does not contain a proof of GRH, and the obstruction in section 3 suggests
the gap is structural, not expository. A specialist should confirm the identification in section 4.

## 2. The setting, in the simplest case

Take the rationals and the trivial character, so that the relevant functions live on the positive reals, with
`u = log x`. Convolution by a test function φ becomes multiplication by its Mellin transform:

$$
A(\varphi)\ \longleftrightarrow\ \text{multiplication by } M\varphi(s), \qquad
M\varphi(s) = \int_0^\infty \varphi(x)\,x^{s}\,\frac{dx}{x}.
$$

Theta-functions twisted by the square root of the norm have Mellin transforms that are multiples of the
zeta function shifted to the critical line:

$$
V \;=\; \overline{\{\zeta(s+\tfrac12)\,G(s)\}} \;\subset\; W_I, \qquad I = [-a,a],\ \ |\mathrm{Re}\,s|\le a .
$$

The spectral side is the trace of the compression of `A(φ)` to the orthogonal complement of `V`:

$$
\mathrm{Tr}\big(P_V^{\perp} A(\varphi) P_V^{\perp}\big) \;=\; \sum_{\rho:\ |\mathrm{Re}\,\rho-\frac12|<a} N(\rho)\,M\varphi(\rho-\tfrac12).
$$

Since the kernel `φ(x/y)` of `A(φ)` vanishes on the diagonal when `φ(1) = 0`, the draft's "trace formula" at the
end of chapter 10 is the tautology

$$
\int k_{\mathrm{geom}}(x,x)\,d\mu(x) \;=\; -\sum_{\rho\in\text{strip}} N(\rho)\,M\varphi(\rho-\tfrac12),
\qquad k_{\mathrm{geom}} = \text{kernel of } P_V A(\varphi).
$$

All arithmetic content is in evaluating the left side independently (chapters 11–12).

## 3. Structural obstruction (checked)

Removing the Euler factor at a prime `p` acts on untwisted theta-functions as `1 − U_p`, where `U_p` is scaling
by `p`, and on twisted ones as `1 − p^{-1/2} U_p`. On the Mellin side the two multipliers are

$$
1 - p^{-s} \quad\text{(untwisted)}, \qquad 1 - p^{-(s+1/2)} \quad\text{(twisted)} .
$$

**Lemma 1.** For `a < 1/2` the twisted multiplier is bounded with bounded inverse on the strip, because

$$
\big|p^{-(s+1/2)}\big| \le p^{-(1/2-a)} < 1 \qquad (|\mathrm{Re}\,s|\le a).
$$

`V` is closed and scaling-invariant, so `(1 − p^{-1/2}U_p)V = V`. The filtration of `V` obtained by removing
Euler factors is therefore constant: all its quotients are zero.

**Consequence.** The per-prime quotients on which the draft computes traces are non-trivial only for the
untwisted multiplier, whose zeros lie on the imaginary line, where the L-function has none. The zeros of the
L-function are visible only after the twist, where each Euler-factor step is invertible. The two are related
by multiplication by the square root of the norm, which is unbounded on `W_I`. Additivity of a trace along a
filtration needs the subspaces to be closed in the Hilbert space where the trace is taken; here their closures
all coincide. The draft's "Paley–Wiener levels" are dense, non-closed subspaces with finer topologies; traces
computed there are not Hilbert-space traces in `W_I`.

The author's letter to Sarnak (section 1.8 of the draft) states the idea as removing Euler factors "one step
at a time" to avoid the non-convergence of Euler products in the critical strip. Lemma 1 says that in the
space where the zeros are counted, each single step already loses nothing, so there is nothing to add up.

## 4. The per-prime vanishing contradicts the main theorem (checked, with one identification)

The draft defines the piece at a prime `p` outside `S` by multiplying the lifted kernel by the indicator of
ideles that are not units at `p` (formula (11.3.1.4)), acting on theta-functions represented by Schwartz
functions of the standard form (unramified outside `S`). For such a representative, restricting to non-units
at `p` is the same as scaling by `p`. So as an operator on theta-functions the first piece is

$$
P_V\,A(\varphi)\,\big(p^{-1/2}U_p\big) \;=\; P_V\,A(\varphi_p), \qquad \varphi_p(x) = p^{-1/2}\,\varphi(x/p),
$$

which is the full geometric operator for a shifted test function. Proposition 12.2.2.2 defines diagonal mass
as the plain integral of the smoothed kernel over the diagonal of the quotient, so mass is determined by the
kernel on the quotient. Applying the tautology of section 2 and then the draft's main theorem to the shifted
function:

$$
\text{mass}\big(\text{piece at } p\big) \;=\; -\sum_{\rho\in\text{strip}} N(\rho)\,M\varphi_p(\rho-\tfrac12) \;=\; -\,W(\varphi_p),
$$

where `W` is Weil's geometric functional. Theorem 11.3.2.1 says the left side is zero whenever `p` exceeds the
support of `φ`. But `W(φ_p)` contains the terms of every prime power in the shifted support.

**Example.** Let `φ` be a bump supported in `(1.24, 1.56)` and `p = 5`. The shifted function is supported in
`(6.2, 7.8)`, which contains the prime 7 and no other prime power. Numerically (script in `numerics/`):

| Quantity | Value |
|---|---|
| Sum over the first 400 zeta zeros (height up to 680) | −0.983325 |
| Weil geometric side | −0.983301 |
| Prime 7 term | −1.945910 |
| Pole terms | +1.103738 |
| Archimedean term | −0.141128 |

So the piece at 5 has mass about 0.98 under this reading, not 0. Theorems 11.3.2.1 and 12.5.1.1 cannot both
hold.

**What the draft computes instead.** The trace of `A(φ)` on the quotient of two consecutive filtration steps
in the untwisted 0-line space, which is correct:

$$
\mathrm{Tr}\big(A(\varphi)\,\big|\,W_k/W_{k+1}\big) \;=\; \sum_{m\in\mathbb Z} M\varphi\!\Big(\frac{2\pi i m}{\log p}\Big) \;=\; \log p \sum_{n\in\mathbb Z}\varphi(p^n).
$$

This is not the mass of the piece of the kernel, which is a regularized trace over the whole `k`-th step.

**The other reading.** With the indentation of Proposition 12.2.2.2 taken to be the indicator of a fundamental
domain inside the all-units stratum, the "skewed diagonal" sum has only the identity term; every per-prime
piece is zero identically, the remainder is the whole global kernel, and nothing has been reduced. The
chapter 12 reviewer found the same for Proposition 12.2.2.4, the only result in range that could justify
summing the pieces: its integrand is identically zero for every `k`.

**Identification to confirm.** The argument assumes the piece of the kernel is the operator above. The
statement of Theorem 11.3.2.1 could not be given a definite meaning as printed (section 5.2), so this is an
argument against the readings that could be constructed, not against a precise statement.

## 5. Findings by chapter

Full reports: `chapter-reviews/`. "False" means a counterexample is given there.

### 5.1 Chapter 10 and section 9.3 (spectral side) — reported

- The spectral statement for the critical line (interval `{0}`) is true; the reviewer re-proved it by a
  different route.
- The draft's proof of it (Theorem 10.3.1.1) uses a uniform bound on the biorthogonal system that is false:
  the dual vectors blow up where zeros cluster, and Selberg's theorem gives clustering. Claim (1) of that
  theorem would imply an open lower bound on gaps between zeros.
- The strip case (Theorems 10.2.2.1, 10.3.2.1, 10.4.3.5, 10.4.3.6) has no proof. Its foundations are false as
  stated: Lemma 9.3.2.4 (zero-counting; counterexample `exp(-z^4) sin(pi z^2)`) and Theorem 9.3.2.6.
- Lemma 10.4.2.5 asserts in effect that a normalized Markushevich basis is a Schauder basis (false; the
  trigonometric system in L¹ of the circle).
- Definition 10.4.3.7 (the geometric kernel for a strip) does not define its kernel, and it is ambiguous
  whether the operator is `A P_spec` or `P_spec A`. Chapters 11–12 compute with it.
- The multiplicity cap is stated as `min{N, floor((s-1)/2)+1}`; the correct value is `min{N, ceil((s-1)/2)}`.
  They differ at odd integer `s`, and the introduction has a third version.

### 5.2 Chapter 11 (per-prime machinery)

- **Proposition 11.2.0.1(2) is false (checked).** `φ(u) ↦ φ(u) − φ(u + log p)` is injective but not bounded
  below on the weighted space, so its range is not closed; only the closure of the range is the intersection
  of the kernels of the evaluation functionals. Test functions `ψ(u/n)` give

$$
\frac{\|P_p\varphi_n\|}{\|\varphi_n\|} \;\lesssim\; \frac1n \;\to\; 0 .
$$

- **Theorem 11.1.2.1 is vacuous or false (checked).** With the one-sided cutoff (norm above 1/Λ), the closure
  of the cut-off range of any finite product of per-prime operators is the whole cut-off space: a functional
  supported on a half-line and annihilating the range must be periodic with support bounded below, hence
  zero. So part (3), "global degenerates to S-local", is true only because both sides are everything, and the
  strictness claim in part (2) is false.
- **Theorem 11.3.2.1 is not well defined and not proved (reported, consistent with section 4).** The
  localizing function (11.3.2.2) is identically zero as printed; the stated right side differs from the
  formula the proof ends on by a factor of the square root of the prime power; the proof multiplies two
  indicators whose product is zero; none of its three limits has an estimate.
- Theorems 11.2.1.2 and 11.2.1.4 identify the wrong limit: the strong limit gives the trace of
  `M_ρ A P_geom`, which differs from the claimed operator by a term the draft says is non-zero (reported).
- Proposition 11.1.1.2(2) is false as stated; a termwise majorant repairs it (reported).
- Correct: the per-prime trace (Theorem 11.2.2.1) after replacing ranges by closures; density of
  theta-functions on the 0-line for the rationals; part (1) of 11.1.2.1.

### 5.3 Chapters 12–14 (assembly and deduction) — reported

- Section 12.3 is empty. Theorem 12.4.1.1 (S-local trace) is a sketch by the author's own footnotes; it is
  Connes' computation for a kernel on the S-adeles that is never identified with the remainder of the global
  kernel, contains no pole terms, and its local terms depend on the order of two cutoff limits.
- Proof of Theorem 12.5.1.1, step by step: the decomposition is cited from an overview paragraph and defines
  neither the remainder nor a mass; the per-prime vanishing is Theorem 11.3.2.1; the S-local evaluation is
  12.4.1.1, which concerns a different operator. The interchange of the sum over primes with the diagonal
  integral and with the cutoff limit is not addressed anywhere.
- The proof never uses the choices the text calls necessary (`a = 1/2`, Sobolev degree `2[F:Q]`, vanishing of
  the test function at central points). Run as written on the critical line with the hypotheses its cited
  results allow, it gives a bound on the multiplicity of every zero that is false: a Dedekind zeta function
  of an A₄-extension has zeros of multiplicity at least 3, and the Hecke L-function of a CM elliptic curve
  of rank at least 3 has a central zero of order at least 3 over a field of degree 2.
- Theorem 13.3.1.1 depends on an arbitrary choice of section of the norm; for a non-canonical choice it is
  false for the same CM examples.
- Correct: Theorems 12.1.1.2 and 12.1.1.3 (diagonals of nuclear kernels), Propositions 12.2.2.2 and 12.2.2.4
  as formal statements (though they carry no information), the algebra of the S-local computation, and the
  deduction "13.3.1.1 plus Weil implies GRH plus a multiplicity bound".

## 6. What was not examined

- Chapters 2–9 (apart from section 9.3) and the appendices, about 700 pages.
- Whether a different definition of the pieces, not present in this draft, could avoid section 4. Lemma 1
  constrains any such definition: it cannot be a filtration of the twisted theta-space in the thin-strip
  Hilbert space.
- The automated reviewers' counterexamples in section 5.1 and the items marked "reported".

## 7. Files

- `chapter-reviews/chapter-10-and-9.3.md`, `chapter-11.md`, `chapters-12-14.md`: unedited reviewer reports.
- `numerics/explicit.py`: the explicit-formula check of section 4 (needs `mpmath`; `python3 explicit.py 400`).
