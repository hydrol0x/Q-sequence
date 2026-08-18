/-
# Large finite certificates (native_decide at 10⁸)

Kept in their own module so routine edits elsewhere do not re-run them.
`lake build` re-verifies them (≈ minutes, ≈ 1 GB RAM).  Trust note as in
`Verify.lean`: these add the compiler (`Lean.ofReduceBool`) to the trusted
base and are finite certificates, not progress on Problem A itself.
-/
import QSequence.Faithful

namespace QSequence

/-- Machine-checked: the engine survives through 10⁸. -/
theorem aliveUpTo_1e8 : aliveUpTo 100000000 = true := by native_decide

/-- **Spec-level immortality certificate at 10⁸**: a genuine history of
length 10⁸ exists; with `isHistory_take`, the specified sequence does not
die at or before 10⁸. -/
theorem history_1e8 : ∃ a : List Nat, IsHistory a ∧ a.length = 100000000 :=
  (aliveUpTo_iff_history 100000000).mp aliveUpTo_1e8

theorem Qeng_1e8 : Qeng 100000000 100000000 = 50166508 := by native_decide

/-- `Q(10⁸) = 50166508` for every history that reaches 10⁸ (cross-validated
against two independent C implementations; see REPORT.md §3). -/
theorem Q_1e8 (a : List Nat) (ha : IsHistory a) (hlen : 100000000 ≤ a.length) :
    valAt a 100000000 = 50166508 := by
  have h := Qeng_eq_valAt (N := 100000000) (i := 100000000) (by omega) (by omega) ha hlen
  rw [← h]
  exact Qeng_1e8

end QSequence
