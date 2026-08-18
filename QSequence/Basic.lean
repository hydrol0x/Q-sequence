/-
# Foundational lemmas about Q-sequence histories

Everything here is proved with no `sorry` and no axioms beyond the standard
three (`propext`, `Classical.choice`, `Quot.sound`).  Main results:

* `history_pos` — every history value is ≥ 1, so lookup indices are automatically
  `≤ n − 1`; together with the explicit `< n` requirement in `RuleAt` this pins
  the boundary bookkeeping *exactly*: the death case is `n − Q(n−1) = 0`
  (i.e. `Q(n−1) ≥ n`), never an out-of-range-high lookup.
* `history_ge_two` — values at positions ≥ 3 are ≥ 2.
* `deterministic` — any two histories agree on their common prefix: **the**
  Q-sequence is unique (the `Deterministic` obligation of `Spec`).
* `isHistory_take` — prefixes of histories are histories (downward closure;
  equivalently: once dead, dead forever, in contrapositive form).
* `isHistory_extend` — a history of length `m ≥ 2` extends (uniquely, by
  `deterministic`) to length `m+1` as soon as the death condition fails at
  `m+1`; the new value is the forced one, `nextVal`.
* `problemA_iff_uniformBound` — **Problem A ⟺ every history value obeys
  `Q(n) ≤ n`** (`UniformBound`).  This is the exact strength of the missing
  lemma: any proof of the uniform linear bound resolves immortality, and
  conversely.  (Note `Q(4) = 3 = ¾·4`, so no bound better than `¾·n` can hold
  from the start; `UniformBound` is the weakest usable form.)
* `Qval_eq_valAt` — the canonical value function from `Spec` agrees with every
  history, making the statement of Problem B history-independent.
* `deviation_identity` — the **exact** identity for `e(n) = 2Q(n) − n`:
  `e(n) = e(n − Q(n−1)) + e(n − Q(n−2)) + (n − Q(n−1) − Q(n−2))`,
  equivalently `e(n) = e(a) + e(b) − (e(n−1) + e(n−2) − 3)/2`.  The two lookup
  terms live at scale ≈ n/2 and *reinforce* deviations; the local term
  *damps* them with coefficient ½.  The linearized one-generation gain is
  exactly 2·(1) − 2·(½) ↦ doubling of envelope per halving of scale — the
  precise sense in which the recursion is *critical* (neither contracting nor
  expanding), which is why naive envelope inductions cannot close.  See
  REPORT.md.
-/
import QSequence.Spec

namespace QSequence

/-! ## `valAt` plumbing -/

theorem valAt_append_left {a : List Nat} (b : List Nat) {n : Nat}
    (h1 : 1 ≤ n) (h2 : n ≤ a.length) : valAt (a ++ b) n = valAt a n := by
  unfold valAt
  rw [List.getElem?_append_left (by omega)]

theorem valAt_append_last (a : List Nat) (v : Nat) :
    valAt (a ++ [v]) (a.length + 1) = v := by
  unfold valAt
  rw [Nat.add_sub_cancel, List.getElem?_concat_length]
  rfl

theorem valAt_take {a : List Nat} {m n : Nat} (h1 : 1 ≤ n) (h2 : n ≤ m) :
    valAt (a.take m) n = valAt a n := by
  unfold valAt
  rw [List.getElem?_take_of_lt (by omega)]

/-- The recurrence shape of `RuleAt` for positions `≥ 3`. -/
theorem ruleAt_of_ge_three {a : List Nat} {n : Nat} (h3 : 3 ≤ n) :
    RuleAt a n ↔
      valAt a (n-1) < n ∧ valAt a (n-2) < n ∧
      valAt a n = valAt a (n - valAt a (n-1)) + valAt a (n - valAt a (n-2)) := by
  unfold RuleAt
  rw [if_neg (by omega), if_neg (by omega)]

/-! ## Positivity -/

/-- Every value of a history is positive.  Hence every lookup index
`n − Q(n−1)` is at most `n − 1`: the *only* way to leave `[1, n−1]` is
downward, i.e. death is exactly `Q(n−1) ≥ n` or `Q(n−2) ≥ n`. -/
theorem history_pos {a : List Nat} (ha : IsHistory a) :
    ∀ n, 1 ≤ n → n ≤ a.length → 1 ≤ valAt a n := by
  intro n
  induction n using Nat.strongRecOn with
  | ind n ih =>
    intro h1 hlen
    have hr := ha n h1 hlen
    by_cases e1 : n = 1
    · subst e1; unfold RuleAt at hr; simp at hr; omega
    · by_cases e2 : n = 2
      · subst e2; unfold RuleAt at hr; simp at hr; omega
      · rw [ruleAt_of_ge_three (by omega)] at hr
        obtain ⟨hv1, hv2, heq⟩ := hr
        have hp1 : 1 ≤ valAt a (n-1) := ih (n-1) (by omega) (by omega) (by omega)
        have hx : 1 ≤ valAt a (n - valAt a (n-1)) := ih _ (by omega) (by omega) (by omega)
        omega

/-- Values at positions `≥ 3` are at least 2 (each is a sum of two positive
looked-up values). -/
theorem history_ge_two {a : List Nat} (ha : IsHistory a) {n : Nat}
    (h3 : 3 ≤ n) (hlen : n ≤ a.length) : 2 ≤ valAt a n := by
  have hr := (ruleAt_of_ge_three h3).mp (ha n (by omega) hlen)
  obtain ⟨hv1, hv2, heq⟩ := hr
  have hp1 : 1 ≤ valAt a (n-1) := history_pos ha (n-1) (by omega) (by omega)
  have hp2 : 1 ≤ valAt a (n-2) := history_pos ha (n-2) (by omega) (by omega)
  have hx : 1 ≤ valAt a (n - valAt a (n-1)) := history_pos ha _ (by omega) (by omega)
  have hy : 1 ≤ valAt a (n - valAt a (n-2)) := history_pos ha _ (by omega) (by omega)
  omega

/-! ## Determinism -/

/-- Any two histories agree on their common prefix: there is exactly one
Q-sequence.  (Resolves the `Deterministic` obligation stated in `Spec`.) -/
theorem deterministic : Deterministic := by
  intro a b ha hb n
  induction n using Nat.strongRecOn with
  | ind n ih =>
    intro h1 hna hnb
    by_cases e1 : n = 1
    · subst e1
      have hra := ha 1 (by omega) (by omega)
      have hrb := hb 1 (by omega) (by omega)
      unfold RuleAt at hra hrb; simp at hra hrb
      rw [hra, hrb]
    · by_cases e2 : n = 2
      · subst e2
        have hra := ha 2 (by omega) (by omega)
        have hrb := hb 2 (by omega) (by omega)
        unfold RuleAt at hra hrb; simp at hra hrb
        rw [hra, hrb]
      · have hra := (ruleAt_of_ge_three (by omega)).mp (ha n h1 hna)
        have hrb := (ruleAt_of_ge_three (by omega)).mp (hb n h1 hnb)
        obtain ⟨ha1, ha2, haeq⟩ := hra
        obtain ⟨hb1, hb2, hbeq⟩ := hrb
        have hp1 : 1 ≤ valAt a (n-1) := history_pos ha (n-1) (by omega) (by omega)
        have hp2 : 1 ≤ valAt a (n-2) := history_pos ha (n-2) (by omega) (by omega)
        have e_1 : valAt a (n-1) = valAt b (n-1) :=
          ih (n-1) (by omega) (by omega) (by omega) (by omega)
        have e_2 : valAt a (n-2) = valAt b (n-2) :=
          ih (n-2) (by omega) (by omega) (by omega) (by omega)
        have ej1 : valAt a (n - valAt a (n-1)) = valAt b (n - valAt a (n-1)) :=
          ih _ (by omega) (by omega) (by omega) (by omega)
        have ej2 : valAt a (n - valAt a (n-2)) = valAt b (n - valAt a (n-2)) :=
          ih _ (by omega) (by omega) (by omega) (by omega)
        rw [haeq, hbeq, ← e_1, ← e_2, ej1, ej2]

/-! ## Prefixes of histories -/

/-- A prefix of a history is a history (the rule at `k` only reads positions
`≤ k`).  Contrapositive: if the sequence dies at `n`, no history of any length
`≥ n` exists — dead forever. -/
theorem isHistory_take {a : List Nat} (ha : IsHistory a) {m : Nat} (hm : m ≤ a.length) :
    IsHistory (a.take m) := by
  intro k hk1 hk2
  rw [List.length_take] at hk2
  have hkm : k ≤ m := by omega
  have hka : k ≤ a.length := by omega
  have hr := ha k hk1 hka
  by_cases e1 : k = 1
  · subst e1
    unfold RuleAt at hr ⊢
    simp at hr ⊢
    rw [valAt_take (by omega) (by omega)]
    exact hr
  · by_cases e2 : k = 2
    · subst e2
      unfold RuleAt at hr ⊢
      simp at hr ⊢
      rw [valAt_take (by omega) (by omega)]
      exact hr
    · rw [ruleAt_of_ge_three (by omega)] at hr ⊢
      obtain ⟨h1, h2, heq⟩ := hr
      have hp1 : 1 ≤ valAt a (k-1) := history_pos ha (k-1) (by omega) (by omega)
      have hp2 : 1 ≤ valAt a (k-2) := history_pos ha (k-2) (by omega) (by omega)
      rw [valAt_take (show 1 ≤ k-1 by omega) (show k-1 ≤ m by omega),
          valAt_take (show 1 ≤ k-2 by omega) (show k-2 ≤ m by omega),
          valAt_take hk1 hkm,
          valAt_take (show 1 ≤ k - valAt a (k-1) by omega) (show k - valAt a (k-1) ≤ m by omega),
          valAt_take (show 1 ≤ k - valAt a (k-2) by omega) (show k - valAt a (k-2) ≤ m by omega)]
      exact ⟨h1, h2, heq⟩

/-! ## Extension -/

/-- The forced value of `Q(m+1)` given a history of length `m` (meaningful for
`m ≥ 2`). -/
def nextVal (a : List Nat) : Nat :=
  valAt a (a.length + 1 - valAt a a.length) + valAt a (a.length + 1 - valAt a (a.length - 1))

/-- The rule at an old position survives appending one value on the right. -/
theorem ruleAt_append {a : List Nat} (v : Nat)
    (hpos : ∀ i, 1 ≤ i → i ≤ a.length → 1 ≤ valAt a i)
    {k : Nat} (hk1 : 1 ≤ k) (hk2 : k ≤ a.length) (hr : RuleAt a k) :
    RuleAt (a ++ [v]) k := by
  by_cases e1 : k = 1
  · subst e1
    unfold RuleAt at hr ⊢
    simp at hr ⊢
    rw [valAt_append_left [v] (by omega) (by omega)]
    exact hr
  · by_cases e2 : k = 2
    · subst e2
      unfold RuleAt at hr ⊢
      simp at hr ⊢
      rw [valAt_append_left [v] (by omega) (by omega)]
      exact hr
    · rw [ruleAt_of_ge_three (by omega)] at hr ⊢
      obtain ⟨h1, h2, heq⟩ := hr
      have hp1 : 1 ≤ valAt a (k-1) := hpos (k-1) (by omega) (by omega)
      have hp2 : 1 ≤ valAt a (k-2) := hpos (k-2) (by omega) (by omega)
      rw [valAt_append_left [v] (show 1 ≤ k-1 by omega) (show k-1 ≤ a.length by omega),
          valAt_append_left [v] (show 1 ≤ k-2 by omega) (show k-2 ≤ a.length by omega),
          valAt_append_left [v] hk1 hk2,
          valAt_append_left [v] (show 1 ≤ k - valAt a (k-1) by omega)
            (show k - valAt a (k-1) ≤ a.length by omega),
          valAt_append_left [v] (show 1 ≤ k - valAt a (k-2) by omega)
            (show k - valAt a (k-2) ≤ a.length by omega)]
      exact ⟨h1, h2, heq⟩

/-- **One-step extension.**  If the death condition fails at `m+1`
(`Q(m) ≤ m` and `Q(m−1) ≤ m`), the history of length `m ≥ 2` extends by the
forced value.  Note the exact boundary: the requirement is
`valAt a m < m + 1`, i.e. `n − Q(n−1) ≥ 1` at `n = m+1`; `n − Q(n−1) = 0` is
death, not an edge case. -/
theorem isHistory_extend {a : List Nat} (ha : IsHistory a) (h2 : 2 ≤ a.length)
    (hd1 : valAt a a.length ≤ a.length) (hd2 : valAt a (a.length - 1) ≤ a.length) :
    IsHistory (a ++ [nextVal a]) := by
  intro k hk1 hk2
  rw [List.length_append] at hk2
  simp at hk2
  by_cases hkle : k ≤ a.length
  · exact ruleAt_append (nextVal a) (history_pos ha) hk1 hkle (ha k hk1 hkle)
  · have hk : k = a.length + 1 := by omega
    subst hk
    rw [ruleAt_of_ge_three (by omega)]
    rw [show a.length + 1 - 1 = a.length from by omega,
        show a.length + 1 - 2 = a.length - 1 from by omega,
        valAt_append_left [nextVal a] (show 1 ≤ a.length by omega) (Nat.le_refl _),
        valAt_append_left [nextVal a] (show 1 ≤ a.length - 1 by omega)
          (show a.length - 1 ≤ a.length by omega)]
    refine ⟨by omega, by omega, ?_⟩
    have hp1 : 1 ≤ valAt a a.length := history_pos ha a.length (by omega) (Nat.le_refl _)
    have hp2 : 1 ≤ valAt a (a.length - 1) := history_pos ha _ (by omega) (by omega)
    rw [valAt_append_last,
        valAt_append_left [nextVal a] (show 1 ≤ a.length + 1 - valAt a a.length by omega)
          (show a.length + 1 - valAt a a.length ≤ a.length by omega),
        valAt_append_left [nextVal a]
          (show 1 ≤ a.length + 1 - valAt a (a.length - 1) by omega)
          (show a.length + 1 - valAt a (a.length - 1) ≤ a.length by omega)]
    rfl

/-! ## Base histories -/

theorem isHistory_nil : IsHistory [] := by
  intro n h1 h2
  simp at h2
  omega

theorem isHistory_one : IsHistory [1] := by
  intro n h1 h2
  simp at h2
  have e : n = 1 := by omega
  subst e
  unfold RuleAt
  simp [valAt]

theorem isHistory_two : IsHistory [1, 1] := by
  intro n h1 h2
  simp at h2
  have e : n = 1 ∨ n = 2 := by omega
  cases e with
  | inl e => subst e; unfold RuleAt; simp [valAt]
  | inr e => subst e; unfold RuleAt; simp [valAt]

/-! ## Problem A ⟺ the uniform linear bound -/

/-- **The single remaining gap for Problem A**, in specification form:
every value of every history is at most its index. -/
def UniformBound : Prop :=
  ∀ a : List Nat, IsHistory a → ∀ n, 1 ≤ n → n ≤ a.length → valAt a n ≤ n

/-- **Problem A is *equivalent* to the uniform bound `Q(n) ≤ n`.**
Forward: if histories of every length exist, the rule at `n+1` forces
`Q(n) ≤ n`.  Backward: the bound is exactly what keeps the death condition
from ever firing, so histories extend forever.  Consequently a proof of
`UniformBound` — a statement about *finite* histories only — resolves
Problem A, and nothing weaker does. -/
theorem problemA_iff_uniformBound : ProblemA ↔ UniformBound := by
  constructor
  · intro hA a ha n h1 hn
    by_cases e1 : n = 1
    · subst e1
      have hr := ha 1 (by omega) hn
      unfold RuleAt at hr; simp at hr; omega
    · obtain ⟨b, hb, hlb⟩ := hA (n+1)
      have hdet : valAt a n = valAt b n :=
        deterministic a b ha hb n h1 hn (by omega)
      have hrb := (ruleAt_of_ge_three (by omega)).mp (hb (n+1) (by omega) (by omega))
      obtain ⟨hb1, -, -⟩ := hrb
      rw [show n + 1 - 1 = n from by omega] at hb1
      omega
  · intro hU N
    induction N with
    | zero => exact ⟨[], isHistory_nil, rfl⟩
    | succ N ih =>
      cases N with
      | zero => exact ⟨[1], isHistory_one, rfl⟩
      | succ M =>
        cases M with
        | zero => exact ⟨[1, 1], isHistory_two, rfl⟩
        | succ K =>
          obtain ⟨a, ha, hlen⟩ := ih
          have h2 : 2 ≤ a.length := by omega
          have hd1 : valAt a a.length ≤ a.length := hU a ha a.length (by omega) (by omega)
          have hd2 : valAt a (a.length - 1) ≤ a.length := by
            have := hU a ha (a.length - 1) (by omega) (by omega)
            omega
          refine ⟨a ++ [nextVal a], isHistory_extend ha h2 hd1 hd2, ?_⟩
          simp [List.length_append, hlen]

/-! ## The canonical value function is history-independent -/

theorem Qval_eq_valAt (h : ProblemA) {n : Nat} (h1 : 1 ≤ n)
    {a : List Nat} (ha : IsHistory a) (hn : n ≤ a.length) :
    Qval h n = valAt a n := by
  unfold Qval
  have hc := Classical.choose_spec (h n)
  exact deterministic _ a hc.1 ha n h1 (by rw [hc.2]; exact Nat.le_refl n) hn

/-! ## The exact deviation identity -/

/-- **Exact deviation identity.**  Write `e(m) = 2·Q(m) − m`.  For every
position `3 ≤ n` of a history,

  `e(n) = e(n − Q(n−1)) + e(n − Q(n−2)) + (n − Q(n−1) − Q(n−2))`.

The two lookup terms sit at scale ≈ n/2 and *reinforce* deviations; the last
term equals `−(e(n−1) + e(n−2) − 3)/2` and *damps* them locally with
coefficient ½.  The one-step deviation map is therefore exactly critical
(linearized gain 2·1 − 2·(½) per generation), the precise obstruction to
closing any envelope induction — see REPORT.md, route R2. -/
theorem deviation_identity {a : List Nat} (ha : IsHistory a) {n : Nat}
    (h3 : 3 ≤ n) (hn : n ≤ a.length) :
    2 * (valAt a n : Int) - (n : Int)
      = (2 * (valAt a (n - valAt a (n-1)) : Int) - ((n - valAt a (n-1) : Nat) : Int))
      + (2 * (valAt a (n - valAt a (n-2)) : Int) - ((n - valAt a (n-2) : Nat) : Int))
      + ((n : Int) - (valAt a (n-1) : Int) - (valAt a (n-2) : Int)) := by
  have hr := (ruleAt_of_ge_three h3).mp (ha n (by omega) hn)
  obtain ⟨h1, h2, heq⟩ := hr
  omega

end QSequence
