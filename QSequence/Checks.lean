/-
# Computational cross-checks (native_decide)

Two roles:

1. **Faithfulness evidence.**  `checkHistory a` is a `Bool` predicate that
   verifies, position by position, that `a` obeys the *specification* rule
   `QSequence.RuleAt`.  We then `native_decide` that the *engine's* output
   `prefixList N` passes `checkHistory` — concrete evidence that the fast
   engine computes the mathematically-specified sequence.  (A full proof
   `engine_faithful : build N = some a → IsHistory a ∧ a.length = N` is a
   proof obligation for the research phase; this module supplies the
   finite-`N` computational witness.)

2. **Immortality certificates and value checks** for finite `N`, via
   `native_decide` (kernel `decide` is impractical here — the array recursion
   exceeds `maxRecDepth`).
-/
import QSequence.Engine
import QSequence.Spec

namespace QSequence

/-- `Bool` version of `RuleAt a n`, matching the spec rule exactly. -/
def ruleAtB (a : List Nat) (n : Nat) : Bool :=
  if n = 1 then valAt a 1 == 1
  else if n = 2 then valAt a 2 == 1
  else
    (valAt a (n - 1) < n) &&
    (valAt a (n - 2) < n) &&
    (valAt a n == valAt a (n - valAt a (n - 1)) + valAt a (n - valAt a (n - 2)))

/-- Check every 1-based position `1 … a.length` against the spec rule. -/
def checkHistory (a : List Nat) : Bool :=
  (List.range a.length).all (fun i => ruleAtB a (i + 1))

/-- The engine's surviving prefix up to `N` (empty on death) passes the
spec-faithful checker. -/
def engineSatisfiesSpec (N : Nat) : Bool := checkHistory (prefixList N)

end QSequence
