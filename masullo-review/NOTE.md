# Notes on A. M. Masullo, "The Music of the Primes" (draft released 2026-11-20)

Source: `https://math216.wordpress.com/wp-content/uploads/2026/11/the-music-of-the-primes.pdf`
(940 pages, SHA-256 `e039d3f6cf0a4b14f03c7edb85097752dd65c0a2fe543c76fe992be234f97bf5`; unchanged when
re-downloaded at 20:18 UTC on 2026-11-20).

**Status of these notes.** Written 2026-11-20 by an AI model (Claude) in one working session. They are a
reader's report, not a refereed verdict. Eight line-by-line reviews of parts of the draft were done by
automated reviewers (Claude subagents); their unedited reports are in `chapter-reviews/`. One of them was
briefed to refute an earlier version of this note and found real errors in it; this version incorporates
those corrections (section 7 lists what changed). Claims re-derived by the author of the note are marked
**checked**; claims taken from a reviewer's report are marked **reported**. Nothing here bears on whether GRH
is true. A specialist should confirm anything before relying on it.

## 1. Summary

1. The draft is released knowingly unfinished. Its acknowledgements say "the math is complete, and only
   filling in some writing remains". The parts not written are the ones that carry the deduction of GRH:
   the section assembling the pieces of the kernel (12.3, empty), the statement of the final theorem
   (13.3.1.2, blank), and sections 13.1–13.2 (headings only).
2. The main theorem (12.5.1.1) is a trace formula whose spectral side counts zeros in a strip around the
   critical line. Its statement never fixes the strip. For a strip of half-width below 1/2 it is, together
   with Weil's explicit formula, equivalent to GRH; for half-width at least 1/2 it is Weil's formula. Its
   proof is six sentences, and each of the three results it cites fails to deliver what is used
   (section 5.3).
3. The step meant to do the work is: split a "geometric kernel" into one piece per prime outside a finite
   set S, show each piece has zero diagonal mass, and compute what is left S-locally. Three readings of that
   step could be constructed from the text (section 4). Read literally it is vacuous. Read at the level of
   operators on the full space, the per-prime vanishing is false. Read on the draft's one-sided
   "Paley–Wiener levels", the per-prime statements are true and the whole difficulty moves to an interchange
   of the sum over primes with a cutoff limit, which is equivalent to GRH and is false if done naively.
4. Many stated intermediate results are false as written, with explicit counterexamples (section 5). Most are
   repairable. The repairs do not supply the step in item 3.
5. The foundations are in better shape than the later chapters. Tate theory, the identification of the
   theta-function space with multiples of the completed L-function, the single-prime bases, and the
   normalisation of the explicit formula hold up, in the fine (Fréchet) topology. Every review of the
   foundations independently reports the same absence: nothing in a Hilbert norm, nothing for a growing set
   of primes, nothing uniform in the prime.

Assessment: as it stands the draft does not contain a proof of GRH. The best reading of its strategy reduces
GRH to a statement of the same difficulty.

## 2. The setting, in the simplest case

Take the rationals and the trivial character, so that the relevant functions live on the positive reals.
Convolution by a test function φ becomes multiplication by its Mellin transform:

$$
A(\varphi)\ \longleftrightarrow\ \text{multiplication by } M\varphi(s), \qquad
M\varphi(s) = \int_0^\infty \varphi(x)\,x^{s}\,\frac{dx}{x}.
$$

Theta-functions twisted by the square root of the norm have Mellin transforms that are multiples of the
zeta function shifted to the critical line:

$$
V \;=\; \overline{\{\zeta(s+\tfrac12)\,G(s)\}} \;\subset\; W_I, \qquad I = [-a,a],\ \ |\mathrm{Re}\,s|\le a .
$$

The spectral side is the trace of `A(φ)` on the quotient by `V`:

$$
\sum_{\rho:\ |\mathrm{Re}\,\rho-\frac12|<a} N(\rho)\,M\varphi(\rho-\tfrac12).
$$

Since the kernel `φ(x/y)` of `A(φ)` vanishes on the diagonal when `φ(1) = 0`, the "trace formula" at the end
of chapter 10 is the tautology

$$
\int k_{\mathrm{geom}}(x,x)\,d\mu(x) \;=\; -\sum_{\rho\in\text{strip}} N(\rho)\,M\varphi(\rho-\tfrac12),
$$

where the geometric kernel is that of `A(φ)` composed with the projector onto `V`. All arithmetic content is
in evaluating the left side independently (chapters 11–12).

## 3. Two facts about removing one Euler factor (checked)

Removing the Euler factor at `p` sends a Schwartz function `f` to `f(x) − f(x/p)` at the `p`-adic place. On a
twisted theta-function `h` this is `h(x) − p^{-1/2} h(px)`, with Mellin multiplier

$$
1 - p^{-(s+1/2)} .
$$

**Lemma 1 (full space).** On `W_I` with `a < 1/2` this multiplier is bounded with bounded inverse, because

$$
\big|p^{-(s+1/2)}\big| \le p^{-(1/2-a)} < 1 \qquad (|\mathrm{Re}\,s|\le a).
$$

So for any closed subspace invariant under scaling in both directions, in particular `V`, the Euler step maps
the subspace onto itself. The filtration (11.3.1.3) of the full theta-space is constant.

**Lemma 2 (one-sided subspaces).** The draft's Paley–Wiener levels (Definition 11.2.1.1) are closed subspaces
of functions supported in norm at least `1/λ`. Such functions have Mellin transforms analytic in a left
half-plane, where evaluation on the line `Re s = −1/2` is continuous. There

$$
p^{s}\big(1 - p^{-(s+1/2)}\big) = p^{s} - p^{-1/2}
$$

is bounded and vanishes at the points `−1/2 + 2πim/log p`. So the Euler step maps level `λ` into level `pλ`
with closed range of infinite codimension, and convolution by a test function supported above norm 1 has
trace on the quotient

$$
\sum_{m\in\mathbb Z} M\varphi\!\Big(-\tfrac12 + \frac{2\pi i m}{\log p}\Big) \;=\; \log p \sum_{n\ge 1} \varphi(p^n)\,p^{-n/2} .
$$

Lemma 1 does not apply because the inverse of the Euler step destroys one-sided support. This is Weil's local
term at `p`, and it vanishes when `p` exceeds the support of `φ`.

The draft proves neither lemma in this form. Chapter 11 proves only the untwisted statement on the line
`Re s = 0`, and the twisted value is asserted in the last lines of the proof of Theorem 11.3.2.1.

## 4. Three readings of the per-prime step

**Literal reading: vacuous (checked).** Proposition 12.2.2.2 defines diagonal mass through a lifted kernel
multiplied by a localizing factor. Unwinding it, the "mass" of a chopped piece is a weighted integral of the
diagonal of the original kernel, with a weight that depends on an arbitrary choice. With the choice used in
Proposition 12.2.2.4 every per-prime piece is zero identically and the remainder is the whole global kernel.
The localizing function printed in (11.3.2.2) is identically zero, and the proof of Theorem 11.3.2.1
multiplies two indicator functions whose product is zero.

**Reading A, operators on the full space: per-prime vanishing is false (checked).** For theta-functions of
Schwartz functions unramified outside `S`, the first piece acts as

$$
-\,A(\psi)\,P_V, \qquad \psi(x) = p^{-1/2}\,\varphi(px),
$$

the full geometric operator for a shifted test function, supported below norm 1. Its mass is the spectral sum
for `ψ`. Theorem 11.3.2.1 is stated for every half-width, and for half-width above 1/2 all zeros are counted,
so by Weil's unconditional formula the mass is Weil's geometric functional of `ψ`, which is not zero. For
`φ` a bump on `(1.24, 1.56)` in Weil's normalisation and `p = 5` (script `numerics/corrected.py`):

| Quantity | Value |
|---|---|
| Sum over the first 150 zeta zeros | +0.674132 |
| Weil geometric side | +0.674001 |
| Pole terms | +0.884192 |
| Prime-power term (4 = 2²) | −0.000610 |
| Archimedean term | −0.209581 |

The non-vanishing comes from the pole and Archimedean terms. For thin strips the same conclusion follows
without Weil: vanishing for all test functions and all primes would force every coefficient of a Dirichlet
series over the zeros in the strip to vanish, contradicting the existence of zeros on the critical line
(reported).

**Reading B, Paley–Wiener levels: per-prime true, assembly equivalent to GRH (partly checked).** Fix a level
and a two-sided cutoff `Λ`. The Euler-step subspaces form a decreasing chain with zero intersection, and the
cut-off trace decomposes exactly into blocks, one per prime outside `S` (reported). Each block's trace tends
to the value in Lemma 2 as the cutoff is removed (reported, sketch level). What the main theorem needs is the
interchange

$$
\lim_{\Lambda\to\infty}\ \sum_{p\notin S} \mathrm{Tr}_\Lambda(\text{block}_p) \;\overset{?}{=}\; \sum_{p\notin S}\ \lim_{\Lambda\to\infty} \mathrm{Tr}_\Lambda(\text{block}_p) .
$$

The left side is minus the spectral sum and does not depend on `S`. The right side does depend on `S`: it is
zero once `S` contains the primes up to the support of `φ`, and for smaller `S` it is the corresponding part
of Weil's prime sum. So the interchange is false as it stands (checked). The reviewer's explanation is that
at fixed cutoff the mass sits on primes of size about `Λ²`, each of which contributes zero in the limit
(reported). The correct statement must account
for the defect, and identifying that defect with Connes' S-local trace plus pole terms is the main theorem
itself. Removing the factors one at a time does not help: every finite step is exact and leaves a global
object, and only the limit is S-local.

There is also a mismatch that does not involve GRH. The global scheme uses two-sided cutoffs and removes the
Paley–Wiener truncation first; done S-locally, that order gives zero. Theorem 12.4.1.1 is Connes' computation
with a one-sided cutoff and a joint limit, which gives the non-zero local terms. A footnote in the draft
concedes the cutoffs do not match (reported).

## 5. Findings by chapter

Full reports: `chapter-reviews/`. "False" means a counterexample is given there.

### 5.1 Chapters 2–4 (theta-functions, zeta integrals, bases) — reported

- Tate theory and the decay estimates are standard and check out for the rationals. Two formulas in
  chapter 3 have wrong constants; minor. A key step of "Weil's Identity" carries the author's footnote
  "Why do such identities hold? Must say more".
- Chapter 4's single-prime basis is correct: the quotient by the multiples of one Euler factor is smooth
  functions on a circle, with the exponential system as an absolute basis.
- There is no basis statement for two different primes in any topology. Theorem 4.6.1.5 assumes commensurable
  logarithms (several places over one rational prime). In the fine topology the two-prime case would need
  Baker's theorem, which is not cited. In Hardy-type Hilbert norms raw evaluations cannot be a Schauder basis,
  because the zero sets of two Euler factors come arbitrarily close.
- Corollary 4.5.3.1 has a circular proof (the statement is true). Lemma 4.3.3.7 is false and appears unused.
- Nothing survives completion in a Hilbert norm, and nothing is uniform in the prime.

### 5.2 Chapters 5, 6 and 8 (structure theorems) — reported

- Correct in the fine topology, and re-derived by the reviewer for the rationals: the theta-space is exactly
  the multiples of the completed zeta function inside entire functions Schwartz on strips, and is closed;
  every isotypic theta-function comes from a Schwartz function unramified outside `S`; the S-local-to-global
  map is an isomorphism when the S-class group is trivial.
- Several written proofs are wrong where the statement is true: Structure Theorem I uses a false step and an
  inapplicable completeness citation, and promises a later proof that does not appear; Structure Theorem II
  has a map going the wrong way. Author notes such as "WORK 1: adjust this Theorem" sit on these results.
- Lemma 5.3.1.1 is false on ramified characters; harmless for what is used later.
- Chapter 8 is motivational. Theorem 8.1.0.1 is false for the trivial character, section 8.4 is heuristic by
  its own wording, section 8.5 is an empty heading, and nothing later cites the chapter.

### 5.3 Chapter 7 (S-local per-prime foundation) — reported

- The single-prime statements are true in the model case but nearly tautological: the per-prime quotient does
  not depend on the zeta function or on the other primes in `S`.
- Every result is in the fine topology. Chapter 11 asserts that its Sobolev quotient "is the completion of"
  the chapter 7 quotient; chapter 7 does not support that.
- Theorem 7.4.2.1's trace sums over all powers of the prime including the zeroth and has no square-root
  weight; it matches Weil's local term only after the twist and for test functions supported above norm 1.
  Its proof cites a proposition that does not exist and a formula from chapter 11.
- Proposition 7.3.3.2's proof stops at "It remains to show that the sub-squares … are cartesian".
  Definition 7.3.3.3 divides by a subspace not contained in the numerator.
- The explanation of why the method fails over function fields (commensurable logarithms) is sound.

### 5.4 Sections 9.1–9.2 and Appendix B (analytic foundations) — reported

- The Hardy–Sobolev facts used later are correct for compact intervals: interior evaluations of all orders
  are continuous, boundary evaluations of order `m` are continuous exactly when `m < (s−1)/2`.
- Five proofs in section 9.2.2 are placeholders ("Return here"). The spaces are not well defined for
  unbounded intervals.
- The multiplicity cap is printed as `min{N, floor((s-1)/2)+1}` throughout chapters 9–11; the correct count
  is `ceil((s-1)/2)`. They differ at odd integer `s` (checked). The introduction has a third version.
- The idelic explicit formula (Theorem B.4.4.7) has correct normalisations; the reviewer checked it term by
  term against the classical formula for the rationals. The draft does not prove it: it cites Weil, and the
  author's note says the link to the draft's own classical version is still to be explained.
- That classical version (Theorem B.4.2.2) is wrong as printed at the Archimedean places.
- The formula appears with three mutually inconsistent normalisations: in B.4.4.7, in the main theorem
  12.5.1.1 (no volume factor), and in 13.3.1.1 (local constants dropped). Only the first is right.
- The residue theorem B.3.2.1 is wrong for multiple poles, which matters where it is applied to quotients by
  an L-function.

### 5.5 Section 9.3 and chapter 10 (spectral side)

- The spectral statement on the critical line is true; the reviewer re-proved it by a different route
  (reported).
- **The draft's proof of it (Theorem 10.3.1.1) uses a false uniform bound (checked).** It asserts a constant
  bounding the product of the norms of each evaluation functional and its biorthogonal vector. A biorthogonal
  vector must be 1 at its zero and 0 at every other zero, so a neighbouring zero at distance `d` forces its
  norm to be at least a negative power of `d`. Gaps between critical-line zeros of zeta tend to zero along a
  sequence, so no such constant exists.
- The strip case (Theorems 10.2.2.1, 10.3.2.1, 10.4.3.5, 10.4.3.6) has no proof (reported).
- **Lemma 9.3.2.4 is false as stated (checked).** `exp(-z^4) sin(pi z^2)` is entire and Schwartz on every
  vertical strip and has about `2T` zeros in a box of height 1 at height `T`, against the claimed
  `O(log T)`. The proof uses an upper bound where Jensen's formula needs a lower bound.
- Lemma 10.4.2.5 asserts in effect that a normalized Markushevich basis is a Schauder basis (false)
  (reported).
- Definition 10.4.3.7 does not define its kernel and is ambiguous between `A P_spec` and `P_spec A`
  (reported).

### 5.6 Chapter 11 (per-prime machinery)

- **Proposition 11.2.0.1(2) is false (checked).** `φ(u) ↦ φ(u) − φ(u + log p)` is injective but not bounded
  below on the weighted line space, so its range is not closed; only the closure of the range is the
  intersection of the kernels of the evaluation functionals. Three reviewers found this independently.
- **Theorem 11.1.2.1 is vacuous or false (checked).** With the one-sided cutoff, the closure of the cut-off
  range of any finite product of per-prime operators is the whole cut-off space, so part (3) is true only
  because both sides are everything, and the strictness claim in part (2) is false.
- **Theorem 11.3.2.1 is not well defined and not proved (reported; consistent with section 4).** Its stated
  right side differs from the formula its proof ends on by the square-root weights; none of its three limits
  has an estimate.
- Theorems 11.2.1.2 and 11.2.1.4 identify the wrong limit (reported); repairable, since the discrepancy is an
  off-diagonal block whose trace tends to zero.
- Correct: the per-prime trace on the 0-line (Theorem 11.2.2.1) after replacing ranges by closures.

### 5.7 Chapters 12–14 (assembly and deduction) — reported

- Section 12.3 is empty. Theorem 12.4.1.1 is a sketch by the author's own footnotes; it concerns a kernel on
  the S-adeles never identified with the remainder of the global kernel, and contains no pole terms.
- The proof of Theorem 12.5.1.1 cites the decomposition from an overview paragraph, the per-prime vanishing
  from Theorem 11.3.2.1, and the S-local value from 12.4.1.1. The interchange of the sum over primes with the
  diagonal integral and the cutoff limit is not addressed anywhere.
- The proof never uses the conditions the text calls necessary. Run on the critical line with the hypotheses
  its cited results allow, it bounds the multiplicity of every zero in a way that is false for the Dedekind
  zeta function of an A₄-extension and for the Hecke L-function of a rank-3 CM elliptic curve.
- Theorem 13.3.1.1 depends on an arbitrary choice of section of the norm and is false for a non-canonical
  choice.
- Correct: Theorems 12.1.1.2 and 12.1.1.3 (diagonals of nuclear kernels), the algebra of the S-local
  computation, and the deduction "13.3.1.1 plus Weil implies GRH plus a multiplicity bound".

## 6. What was not examined

- Appendices A, C, D and E, about 350 pages, and the smaller lemmas of chapters 2–3.
- Number fields other than the rationals, and ramified characters, except where a reviewer says so.
- Items marked "reported" have not been independently re-derived.

## 7. Corrections to the first version of this note

An independent reviewer was asked to refute the first version (`chapter-reviews/audit-of-the-note.md`).
These points were wrong and have been fixed:

- **Direction of the shift.** The piece at `p` corresponds to the test function `φ(px)`, not `φ(x/p)`. The
  first numerical example was computed for the wrong function. It is kept as
  `numerics/explicit-wrong-shift.py`; the corrected one is `numerics/corrected.py`.
- **Where the non-vanishing comes from.** With the correct shift it comes from the pole and Archimedean terms,
  not from a prime in the shifted support.
- **Paley–Wiener levels.** The first version called them dense, non-closed subspaces. They are closed
  subspaces of one-sided-supported functions, and Lemma 2 shows the per-prime quotients on them are
  non-trivial. The claim that "there is nothing to add up" was wrong.
- **"Vacuous or contradictory."** There is a third reading (B), under which the per-prime statements are true
  and the gap is an interchange of limits.

## 8. Files

- `chapter-reviews/`: eight unedited reviewer reports.
- `numerics/corrected.py`: explicit-formula check for section 4 (needs `mpmath`; `python3 corrected.py 150`).
- `numerics/explicit-wrong-shift.py`: the superseded check from the first version.
