/-
# Verified finite computations (native_decide)

These theorems are checked by compiled native code (`native_decide`).  They are
reproducible exact-integer computations: `lake build` re-runs them.

NOTE ON TRUST: `native_decide` adds the compiler + `Lean.ofReduceBool` to the
trusted base (visible via `#print axioms`).  These are finite certificates, not
a proof of Problem A — the death index, if any, exceeds 3×10¹⁰, far beyond any
finite check.  They serve to (a) pin faithfulness of the engine to the spec on
a large window and (b) provide reproducible data for the research phase.
-/
import QSequence.Checks

namespace QSequence

/-- The engine's output obeys the *faithful specification rule* (`RuleAt`) at
every position up to 100000.  Evidence that `Engine` computes the sequence
specified in `Spec`. -/
theorem engine_faithful_100k : engineSatisfiesSpec 100000 = true := by native_decide

/-- Immortality certificate: the sequence is defined for all `n ≤ 10⁶`. -/
theorem alive_1e6 : aliveUpTo 1000000 = true := by native_decide

/-- A005185 prefix check: `Q(1..15) = [1,1,2,3,3,4,5,5,6,6,6,8,8,8,10]`. -/
theorem prefix15 :
    prefixList 15 = [1,1,2,3,3,4,5,5,6,6,6,8,8,8,10] := by native_decide

/-- Non-monotonicity witness: `Q(15) = 10 > 9 = Q(16)` (a genuine dip),
so `Q` is not monotone. -/
theorem nonmono : Qeng 20 16 < Qeng 20 15 := by native_decide

end QSequence
