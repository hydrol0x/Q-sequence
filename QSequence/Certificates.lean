/-
# Spec-level certificates and exact reductions

The faithfulness theorems of `QSequence.Faithful` upgrade `native_decide`
computations from statements about the *engine* to statements about the
*specified* sequence.  This module records:

* `problemA_iff_engine` — Problem A ⟺ the engine never reports death;
  together with `problemA_iff_uniformBound` this pins the three equivalent
  forms  A ⟺ `∀ N, aliveUpTo N` ⟺ `UniformBound`.
* `history_1e7`, `history_upto_1e7` — spec-level immortality through 10⁷
  (`native_decide`; adds the compiler to the trusted base, see `Verify.lean`).
* `Q_1e6`, `Q_1e7`, `Qval_1e7` — the value of *every* sufficiently long
  history at 10⁶ and 10⁷ (cross-validated against three independent
  implementations, see `data/` and REPORT.md).
* `Q_4`, `nonmono_spec` — spec-level `Q(4) = 3` and `Q(16) < Q(15)`.
* `no_uniform_bound_below_3_4` — no bound `Q(n) ≤ c·n` with `c < 3/4` can
  hold for all histories (witness `Q(4) = 3`), so the target zone for a
  linear-bound resolution of Problem A is exactly `c ∈ [3/4, 1)`.
-/
import QSequence.Faithful

namespace QSequence

/-! ## Problem A: the three equivalent forms -/

/-- **Problem A ⟺ the engine never dies.**  (With `problemA_iff_uniformBound`:
`ProblemA ↔ (∀ N, aliveUpTo N = true) ↔ UniformBound`.) -/
theorem problemA_iff_engine : ProblemA ↔ ∀ N : Nat, aliveUpTo N = true := by
  constructor
  · intro hA N
    exact (aliveUpTo_iff_history N).mpr (hA N)
  · intro h N
    exact (aliveUpTo_iff_history N).mp (h N)

/-! ## Finite immortality certificates, spec level -/

/-- Machine-checked: the engine survives through 10⁷. -/
theorem aliveUpTo_1e7 : aliveUpTo 10000000 = true := by native_decide

/-- **Spec-level immortality certificate**: a genuine history (faithful
specification sense) of length 10⁷ exists. -/
theorem history_1e7 : ∃ a : List Nat, IsHistory a ∧ a.length = 10000000 :=
  (aliveUpTo_iff_history 10000000).mp aliveUpTo_1e7

/-- … hence of every length ≤ 10⁷: the specified sequence does not die at or
before 10⁷. -/
theorem history_upto_1e7 :
    ∀ N, N ≤ 10000000 → ∃ a : List Nat, IsHistory a ∧ a.length = N := by
  intro N hN
  obtain ⟨a, ha, hlen⟩ := history_1e7
  refine ⟨a.take N, isHistory_take ha (by omega), ?_⟩
  rw [List.length_take]
  omega

/-! ## Value certificates, spec level -/

theorem Qeng_1e6 : Qeng 1000000 1000000 = 512066 := by native_decide

theorem Qeng_1e7 : Qeng 10000000 10000000 = 5124632 := by native_decide

/-- `Q(10⁶) = 512066` for every history that reaches 10⁶. -/
theorem Q_1e6 (a : List Nat) (ha : IsHistory a) (hlen : 1000000 ≤ a.length) :
    valAt a 1000000 = 512066 := by
  have h := Qeng_eq_valAt (N := 1000000) (i := 1000000) (by omega) (by omega) ha hlen
  rw [← h]
  exact Qeng_1e6

/-- `Q(10⁷) = 5124632` for every history that reaches 10⁷. -/
theorem Q_1e7 (a : List Nat) (ha : IsHistory a) (hlen : 10000000 ≤ a.length) :
    valAt a 10000000 = 5124632 := by
  have h := Qeng_eq_valAt (N := 10000000) (i := 10000000) (by omega) (by omega) ha hlen
  rw [← h]
  exact Qeng_1e7

/-- The canonical value function under Problem A agrees. -/
theorem Qval_1e7 (h : ProblemA) : Qval h 10000000 = 5124632 := by
  obtain ⟨a, ha, hlen⟩ := history_1e7
  rw [Qval_eq_valAt h (by omega) ha (by omega)]
  exact Q_1e7 a ha (by omega)

/-! ## Small exact values and their consequences -/

theorem Qeng_4 : Qeng 4 4 = 3 := by native_decide

/-- Spec-level `Q(4) = 3`. -/
theorem Q_4 (a : List Nat) (ha : IsHistory a) (hlen : 4 ≤ a.length) :
    valAt a 4 = 3 := by
  have h := Qeng_eq_valAt (N := 4) (i := 4) (by omega) (by omega) ha hlen
  rw [← h]
  exact Qeng_4

theorem Qeng_15 : Qeng 16 15 = 10 := by native_decide
theorem Qeng_16 : Qeng 16 16 = 9 := by native_decide

/-- Spec-level non-monotonicity: `Q(16) = 9 < 10 = Q(15)` on every history
reaching 16.  (Blocks any "slow/monotone sequence" proof strategy at the
root: Q is provably not monotone.) -/
theorem nonmono_spec (a : List Nat) (ha : IsHistory a) (hlen : 16 ≤ a.length) :
    valAt a 16 < valAt a 15 := by
  have h15 := Qeng_eq_valAt (N := 16) (i := 15) (by omega) (by omega) ha hlen
  have h16 := Qeng_eq_valAt (N := 16) (i := 16) (by omega) (by omega) ha hlen
  rw [← h15, ← h16, Qeng_15, Qeng_16]
  omega

/-- **No uniform linear bound below ¾.**  For any rational `c = c_num/c_den`
with `c < 3/4`, the bound `Q(n) ≤ c·n` fails on every history reaching 4
(witness `Q(4) = 3`).  Hence the "prove `Q(n) ≤ c·n` with `c < 1`" route to
Problem A must operate in the window `c ∈ [3/4, 1)`. -/
theorem no_uniform_bound_below_3_4 (c_num c_den : Nat)
    (hc : 4 * c_num < 3 * c_den) :
    ¬(∀ a : List Nat, IsHistory a → ∀ n, 1 ≤ n → n ≤ a.length →
        c_den * valAt a n ≤ c_num * n) := by
  intro hbound
  obtain ⟨a, ha, hlen⟩ := history_upto_1e7 4 (by omega)
  have h4 := Q_4 a ha (by omega)
  have := hbound a ha 4 (by omega) (by omega)
  rw [h4] at this
  omega

end QSequence
