/-
# Faithful mathematical specification of the Hofstadter Q-sequence
# and the exact statements of Problems A and B.

This module gives a specification of `Q` that is *manifestly faithful* to the
definition, independent of the computation engine in `QSequence.Engine`.
It then states Problem A (immortality) and Problem B (asymptotics) as named
propositions, so that a resolution is a term of the form
`theorem problemA : ProblemA := …` with **no** hidden axioms or `sorry`.

The definition (1-indexed):

    Q(1) = 1,  Q(2) = 1,
    Q(n) = Q(n - Q(n-1)) + Q(n - Q(n-2))   for n ≥ 3.

`Q(n)` is defined iff both lookup indices `n - Q(n-1)` and `n - Q(n-2)` lie in
`[1, n-1]`.  The sequence **dies at n** iff `Q(n-1) ≥ n` or `Q(n-2) ≥ n`.

## Design

We represent a computed prefix `Q(1), …, Q(m)` as a `List Nat` `a` with 0-based
backing, `a[i] = Q(i+1)`.  `valAt a n` reads `Q(n)` (returning the sentinel `0`
when `n` is out of range — legitimate values are positive, so `0` never
collides with a real value).

`IsHistory a` says that `a` is a genuine prefix of the Q-sequence: every
1-based position `n ∈ [1, a.length]` obeys the base cases / recurrence with
**in-range** lookups.  This is the honest carrier of "Q is defined on
`[1, a.length]` and takes these values."
-/

namespace QSequence

/-- `valAt a n = Q(n)` read from history `a` (0-based backing `a[i] = Q(i+1)`),
with sentinel `0` when `n` is out of `[1, a.length]`. -/
def valAt (a : List Nat) (n : Nat) : Nat := (a[n - 1]?).getD 0

/-- The local rule at 1-based position `n` for a candidate history `a`.
Base cases fix `Q(1) = Q(2) = 1`.  For `n ≥ 3` the two lookup indices must be
in `[1, n-1]` (equivalently `Q(n-1) < n` and `Q(n-2) < n`, since all values are
positive) and `Q(n)` must equal the sum of the looked-up values. -/
def RuleAt (a : List Nat) (n : Nat) : Prop :=
  if n = 1 then valAt a 1 = 1
  else if n = 2 then valAt a 2 = 1
  else
    valAt a (n - 1) < n ∧            -- lookup index n - Q(n-1) ≥ 1
    valAt a (n - 2) < n ∧            -- lookup index n - Q(n-2) ≥ 1
    valAt a n = valAt a (n - valAt a (n - 1)) + valAt a (n - valAt a (n - 2))

/-- `a` is a genuine prefix of the Q-sequence of length `a.length`. -/
def IsHistory (a : List Nat) : Prop :=
  ∀ n, 1 ≤ n → n ≤ a.length → RuleAt a n

/-- **Determinism obligation.**  Any two histories agree on their common
prefix.  (Provable by strong induction; a foundational lemma for defining the
canonical value function.  Stated here as a target proposition.) -/
def Deterministic : Prop :=
  ∀ a b : List Nat, IsHistory a → IsHistory b →
    ∀ n, 1 ≤ n → n ≤ a.length → n ≤ b.length → valAt a n = valAt b n

/-- **Problem A (immortality).**  For every `N` there is a history of length
`N`; equivalently the sequence never dies. -/
def ProblemA : Prop := ∀ N : Nat, ∃ a : List Nat, IsHistory a ∧ a.length = N

/-- The canonical value `Q(n)`, defined from *some* history that reaches `n`.
Under `ProblemA` and `Deterministic` this is well-defined and equals every
history's value at `n`.  Concretely we read it off any history of length `n`
(existence supplied by `ProblemA`), via classical choice.  This `def` is only
used to *state* Problem B; the statement `ProblemB` below is what must be
proved. -/
noncomputable def Qval (h : ProblemA) (n : Nat) : Nat :=
  valAt (Classical.choose (h n)) n

/-- **Problem B (asymptotics), integer ε–N form.**  `Q(n)/n → 1/2`.

For every accuracy `k ≥ 1` there is a threshold `N₀` beyond which
`|2·Q(n) − n| · k < n`, i.e. `|Q(n)/n − 1/2| < 1/(2k)`.  Using
`Int.natAbs (2·Q(n) − n)` avoids real numbers while capturing the limit
exactly.  This is stated *contingent on Problem A* (it needs the canonical
value function). -/
def ProblemB (h : ProblemA) : Prop :=
  ∀ k : Nat, 1 ≤ k → ∃ N₀ : Nat, ∀ n : Nat, N₀ ≤ n →
    (Int.natAbs (2 * (Qval h n : Int) - (n : Int))) * k < n

/-- **Problem B, conditional (Golomb) form** — the acceptable A-free statement.
"If `Q` is immortal, then `Q(n)/n → 1/2`", i.e. `ProblemA → ProblemB`.  This is
the exact conditional the task permits when A is not yet resolved; it must be
proved *without assuming the limit exists*. -/
def ProblemB_conditional : Prop := ∀ h : ProblemA, ProblemB h

end QSequence
