/-
# First machine-checked asymptotic constraints (under Problem A)

Under `ProblemA`, the canonical value function `Qval` obeys the recurrence
(`Qval_rec`), positivity, and `Qval n ≤ n`.  From these alone we prove the
kernel of the endpoint exclusion in the conditional-limit theorem
(REPORT.md §5, case c = 1):

* `not_eventually_ge_three_quarters` — it is impossible that
  `Q(m)/m ≥ 3/4` for all sufficiently large `m`.

(The one-step argument works for any threshold `c > 2/3`: if `Q ≥ c·m`
eventually, both lookups eventually sit below `(1−c)·n + O(1)`, so
`Q(n) ≤ 2(1−c)n + O(1) < c·n`, a contradiction.  We fix `c = 3/4` for a
clean integer statement; `3/4` is also the sharp constant of
`no_uniform_bound_below_3_4`.)
-/
import QSequence.Certificates

namespace QSequence

/-- Under Problem A the canonical values are positive. -/
theorem Qval_pos (h : ProblemA) {n : Nat} (h1 : 1 ≤ n) : 1 ≤ Qval h n := by
  obtain ⟨a, ha, hlen⟩ := h n
  rw [Qval_eq_valAt h h1 ha (by omega)]
  exact history_pos ha n h1 (by omega)

/-- Under Problem A the canonical values obey the uniform bound. -/
theorem Qval_le_self (h : ProblemA) {n : Nat} (h1 : 1 ≤ n) : Qval h n ≤ n := by
  obtain ⟨a, ha, hlen⟩ := h n
  rw [Qval_eq_valAt h h1 ha (by omega)]
  exact (problemA_iff_uniformBound.mp h) a ha n h1 (by omega)

/-- Under Problem A the canonical value function satisfies the Q-recurrence. -/
theorem Qval_rec (h : ProblemA) {n : Nat} (h3 : 3 ≤ n) :
    Qval h n = Qval h (n - Qval h (n-1)) + Qval h (n - Qval h (n-2)) := by
  obtain ⟨a, ha, hlen⟩ := h n
  have hr := (ruleAt_of_ge_three h3).mp (ha n (by omega) (by omega))
  obtain ⟨h1', h2', heq⟩ := hr
  have hp1 : 1 ≤ valAt a (n-1) := history_pos ha (n-1) (by omega) (by omega)
  have hp2 : 1 ≤ valAt a (n-2) := history_pos ha (n-2) (by omega) (by omega)
  rw [Qval_eq_valAt h (n := n - 1) (by omega) ha (by omega),
      Qval_eq_valAt h (n := n - 2) (by omega) ha (by omega),
      Qval_eq_valAt h (n := n) (by omega) ha (by omega),
      Qval_eq_valAt h (n := n - valAt a (n - 1)) (by omega) ha (by omega),
      Qval_eq_valAt h (n := n - valAt a (n - 2)) (by omega) ha (by omega)]
  exact heq

/-- **`Q(n)/n ≥ 3/4` cannot hold eventually** (machine-checked kernel of the
`c = 1` exclusion in the conditional-limit theorem).  If `4·Q(m) ≥ 3·m` for
all `m ≥ M`, then at `n = M + 12` both lookups sit at
`≤ (n + O(1))/4`, forcing `Q(n) ≤ (2n + O(1))/4 < 3n/4` — contradiction. -/
theorem not_eventually_ge_three_quarters (h : ProblemA) :
    ¬ ∃ M : Nat, ∀ m : Nat, M ≤ m → 3 * m ≤ 4 * Qval h m := by
  rintro ⟨M, hM⟩
  have hrec := Qval_rec h (n := M + 12) (by omega)
  rw [show M + 12 - 1 = M + 11 from by omega,
      show M + 12 - 2 = M + 10 from by omega] at hrec
  have hb1 : 3 * (M + 11) ≤ 4 * Qval h (M + 11) := hM _ (by omega)
  have hb2 : 3 * (M + 10) ≤ 4 * Qval h (M + 10) := hM _ (by omega)
  have hbn : 3 * (M + 12) ≤ 4 * Qval h (M + 12) := hM _ (by omega)
  have hle1 : Qval h (M + 11) ≤ M + 11 := Qval_le_self h (by omega)
  have hle2 : Qval h (M + 10) ≤ M + 10 := Qval_le_self h (by omega)
  have hlea : Qval h (M + 12 - Qval h (M + 11)) ≤ M + 12 - Qval h (M + 11) :=
    Qval_le_self h (by omega)
  have hleb : Qval h (M + 12 - Qval h (M + 10)) ≤ M + 12 - Qval h (M + 10) :=
    Qval_le_self h (by omega)
  omega

end QSequence
