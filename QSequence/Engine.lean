/-
# A fast, exact-integer computation engine for the Hofstadter Q-sequence

This module provides a *computable* model of the Q-sequence suitable for
`native_decide`-backed verification (immortality up to a finite index,
concrete value checks against OEIS A005185, non-monotonicity witnesses, and
numeric tests of candidate invariants).

The sequence (1-indexed):

    Q(1) = 1,  Q(2) = 1,
    Q(n) = Q(n - Q(n-1)) + Q(n - Q(n-2))   for n ≥ 3.

`Q(n)` is defined iff both lookup indices `n - Q(n-1)` and `n - Q(n-2)` lie in
`[1, n-1]`.  Since all values are positive, the upper bound is automatic; the
sequence **dies at n** iff `Q(n-1) ≥ n` or `Q(n-2) ≥ n`.

We store `Q(1), …, Q(m)` in an `Array Nat` with 0-based backing: `a[i]` holds
`Q(i+1)`.  `step` extends a live history by one term or reports death.

The engine is deliberately written with total, decidable operations so that
`decide` / `native_decide` can evaluate it inside the kernel or via compiled
code.  Faithfulness to the mathematical specification in `QSequence.Spec` is
recorded as an explicit obligation there (`engine_matches_spec`), NOT assumed.
-/

namespace QSequence

/-- One step of the Q recursion on a history `a` storing `Q(1..a.size)`
(0-based: `a[i] = Q(i+1)`).  Returns `some (Q(n))` for `n = a.size + 1`,
or `none` if the sequence dies at `n` (a required lookup index is `< 1`).

For `n ≥ 3` we need `Q(n-1) = a[n-2]` and `Q(n-2) = a[n-3]`.  Death occurs iff
`Q(n-1) ≥ n` or `Q(n-2) ≥ n`, i.e. the 1-based lookup index `n - Q(n-1)` or
`n - Q(n-2)` is `0`.  Otherwise the looked-up values are
`Q(n - Q(n-1)) = a[(n - Q(n-1)) - 1]` and similarly for the other term. -/
def step (a : Array Nat) : Option Nat :=
  let n := a.size + 1
  if n = 1 then
    some 1
  else if n = 2 then
    some 1
  else
    -- n ≥ 3; last two stored values are Q(n-1) and Q(n-2)
    let qn1 := a[a.size - 1]!    -- Q(n-1)
    let qn2 := a[a.size - 2]!    -- Q(n-2)
    -- death iff a lookup index falls below 1
    if qn1 ≥ n ∨ qn2 ≥ n then
      none
    else
      let i1 := n - qn1          -- 1-based lookup index, in [1, n-1]
      let i2 := n - qn2          -- 1-based lookup index, in [1, n-1]
      some (a[i1 - 1]! + a[i2 - 1]!)

/-- Build the history array for `Q(1..N)`, or `none` if the sequence dies at
some `n ≤ N`.  `fuel` bounds the number of steps (use `N`). -/
def buildAux : (fuel : Nat) → (target : Nat) → Array Nat → Option (Array Nat)
  | 0,        _,      a => some a
  | fuel + 1, target, a =>
    if a.size ≥ target then some a
    else match step a with
      | none   => none
      | some v => buildAux fuel target (a.push v)

/-- History array `Q(1), …, Q(N)` if the sequence survives to `N`,
else `none` (death at some `n ≤ N`). -/
def build (N : Nat) : Option (Array Nat) := buildAux N N #[]

/-- `aliveUpTo N` : the Q-sequence is defined for all of `1, …, N`. -/
def aliveUpTo (N : Nat) : Bool := (build N).isSome

/-- `Qeng N i` returns `Q(i)` computed by the engine (for `1 ≤ i ≤ N`),
using the history built up to `N`.  Returns `0` on out-of-range / death
(a sentinel; real values are positive, so `0` never collides). -/
def Qeng (N i : Nat) : Nat :=
  match build N with
  | none   => 0
  | some a => if 1 ≤ i ∧ i ≤ a.size then a[i - 1]! else 0

/-- Convenience: the whole surviving prefix as a `List` (empty on death). -/
def prefixList (N : Nat) : List Nat :=
  match build N with
  | none   => []
  | some a => a.toList

end QSequence
