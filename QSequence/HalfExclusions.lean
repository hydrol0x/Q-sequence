/-
# Sharp one-sided exclusions at 1/2 (under Problem A)

This module strengthens the endpoint exclusions of the conditional-limit
theorem (REPORT.md §5) to their sharp thresholds, in both directions:

* `not_eventually_le_of_lt_half` — for every rational `p/q < 1/2`, it is
  impossible that `Q(m) ≤ (p/q)·m` for all large `m`.
  (Doubling argument: if all values from `M` on sit below `(p/q)·m` with
  `p/q < 1/2`, both lookups of `m` land in `[(1−p/q)·m, m−1]`; a strong
  induction doubles the value floor `2^j` per level while the level threshold
  grows only by the factor `q/(q−p) < 2` — so the floor overtakes the assumed
  linear ceiling.)

* `not_eventually_ge_of_gt_half` — for every rational `p/q > 1/2`, it is
  impossible that `Q(m) ≥ (p/q)·m` for all large `m`.
  (Iterated envelope refinement: from `Q ≥ (p/q)·m` eventually, each upper
  envelope `q^k·Q(n) ≤ r^k·n + D` improves to one with `r^{k+1} = r·r^k`,
  `r = 2(q−p) < q`; the envelopes contract geometrically below `p/q`,
  contradicting the assumed linear floor.)

Consequences (`frequently_lt_of_gt_half`, `frequently_gt_of_lt_half`): under
Problem A the ratio `Q(n)/n` comes arbitrarily close to (or crosses) `1/2`
from both sides infinitely often — in limit language,
`liminf Q(n)/n ≤ 1/2 ≤ limsup Q(n)/n`.  These supersede
`not_eventually_ge_three_quarters` (`Asymptotics.lean`, threshold ¾) and
machine-check *both* endpoint exclusions of Theorem C at the sharp constant.
`TheoremC.lean` builds on them to machine-check the full conditional-limit
lemma.

Everything is elementary `Nat` arithmetic over `Qval`: no reals, no
`native_decide`; the axioms are the standard three (`#print axioms`).
-/
import QSequence.Asymptotics

namespace QSequence

/-- Bernoulli-type helper: `q^j · (q + j) ≤ q · (q+1)^j`  (integer form of
`(1 + 1/q)^j ≥ 1 + j/q`, giving the divergence `((q+1)/q)^j → ∞`). -/
theorem bernoulli_aux (q : Nat) : ∀ j : Nat, q ^ j * (q + j) ≤ q * (q + 1) ^ j := by
  intro j
  induction j with
  | zero => simp
  | succ j ih =>
    rw [Nat.pow_succ, Nat.pow_succ]
    -- goal: q^j * q * (q + (j+1)) ≤ q * ((q+1)^j * (q+1))
    have e1 : q ^ j * q * (q + (j + 1)) = q ^ j * (q + j) * q + q ^ j * q := by
      have e : q + (j + 1) = (q + j) + 1 := by omega
      rw [e, Nat.mul_add, Nat.mul_one, Nat.mul_right_comm]
    have e2 : q * ((q + 1) ^ j * (q + 1)) = q * (q + 1) ^ j * q + q * (q + 1) ^ j := by
      rw [← Nat.mul_assoc, Nat.mul_add, Nat.mul_one]
    rw [e1, e2]
    have h1 : q ^ j * (q + j) * q ≤ q * (q + 1) ^ j * q :=
      Nat.mul_le_mul_right q ih
    have h2 : q ^ j * q ≤ q * (q + 1) ^ j := by
      calc q ^ j * q ≤ q ^ j * (q + j) := Nat.mul_le_mul_left _ (by omega)
        _ ≤ q * (q + 1) ^ j := ih
    omega

/-- **Lower exclusion, sharp.**  Under Problem A, for any rational
`p/q < 1/2` it is impossible that `Q(m) ≤ (p/q)·m` for all sufficiently
large `m`.  (In particular the ratio `Q(n)/n` cannot tend to any limit
below `1/2`, and `limsup Q(n)/n ≥ 1/2`.) -/
theorem not_eventually_le_of_lt_half (h : ProblemA) {p q : Nat} (hpq : 2 * p < q) :
    ¬ ∃ M : Nat, ∀ m : Nat, M ≤ m → q * Qval h m ≤ p * m := by
  rintro ⟨M, hM⟩
  have hq : 0 < q := by omega
  have hEq : q - p ≤ q := by omega
  -- 2(q−p) ≥ q+1: doubling beats the per-level threshold growth q/(q−p)
  have h2E : q + 1 ≤ 2 * (q - p) := by omega
  obtain ⟨C, hC⟩ : ∃ C, C = M + 5 := ⟨_, rfl⟩
  -- Key doubling claim: value ≥ 2^j wherever the level-j threshold is met.
  have key : ∀ j m, q ^ j * C ≤ (q - p) ^ j * m → 2 ^ j ≤ Qval h m := by
    intro j
    induction j with
    | zero =>
      intro m hm
      simp only [Nat.pow_zero, Nat.one_mul] at hm ⊢
      exact Qval_pos h (by omega)
    | succ j ih =>
      intro m hm
      -- m meets its own threshold: m ≥ C, so all lookups are in the hM-range
      have hmC : C ≤ m := by
        have hle : (q - p) ^ (j+1) ≤ q ^ (j+1) := Nat.pow_le_pow_left hEq (j+1)
        have h1 : q ^ (j+1) * C ≤ q ^ (j+1) * m :=
          Nat.le_trans hm (Nat.mul_le_mul_right m hle)
        exact Nat.le_of_mul_le_mul_left h1 (Nat.pow_pos hq)
      have hm3 : 3 ≤ m := by omega
      obtain ⟨x, hx⟩ : ∃ x, x = Qval h (m - 1) := ⟨_, rfl⟩
      obtain ⟨y, hy⟩ : ∃ y, y = Qval h (m - 2) := ⟨_, rfl⟩
      have hx_le : x ≤ m - 1 := hx ▸ Qval_le_self h (by omega)
      have hy_le : y ≤ m - 2 := hy ▸ Qval_le_self h (by omega)
      have hxM : q * x ≤ p * (m - 1) := hx ▸ hM (m - 1) (by omega)
      have hyM : q * y ≤ p * (m - 2) := hy ▸ hM (m - 2) (by omega)
      obtain ⟨a, ha⟩ : ∃ a, a = m - x := ⟨_, rfl⟩
      obtain ⟨b, hb⟩ : ∃ b, b = m - y := ⟨_, rfl⟩
      -- q·a ≥ (q−p)·m and q·b ≥ (q−p)·m: the lookups stay in the upper window
      have hax : a + x = m := by omega
      have hby : b + y = m := by omega
      have hqa : q * a + q * x = q * m := by rw [← Nat.mul_add, hax]
      have hqb : q * b + q * y = q * m := by rw [← Nat.mul_add, hby]
      have hlink : (q - p) * m + p * m = q * m := by
        rw [← Nat.add_mul]; congr 1; omega
      have hpm1 : p * (m - 1) ≤ p * m := Nat.mul_le_mul_left p (by omega)
      have hpm2 : p * (m - 2) ≤ p * m := Nat.mul_le_mul_left p (by omega)
      have hqa2 : (q - p) * m ≤ q * a := by omega
      have hqb2 : (q - p) * m ≤ q * b := by omega
      -- promote to the level-j threshold at a and b
      have hstep : ∀ z : Nat, (q - p) * m ≤ q * z → q ^ j * C ≤ (q - p) ^ j * z := by
        intro z hz
        have h1 : (q - p) ^ j * ((q - p) * m) ≤ (q - p) ^ j * (q * z) :=
          Nat.mul_le_mul_left _ hz
        have e1 : (q - p) ^ j * ((q - p) * m) = (q - p) ^ (j+1) * m := by
          rw [Nat.pow_succ, Nat.mul_assoc]
        have e2 : (q - p) ^ j * (q * z) = q * ((q - p) ^ j * z) :=
          Nat.mul_left_comm ((q - p) ^ j) q z
        have h2 : q * (q ^ j * C) ≤ q * ((q - p) ^ j * z) := by
          rw [← e2]
          rw [e1] at h1
          have e3 : q * (q ^ j * C) = q ^ (j+1) * C := by
            rw [Nat.pow_succ, Nat.mul_comm (q ^ j) q, Nat.mul_assoc]
          rw [e3]
          exact Nat.le_trans hm h1
        exact Nat.le_of_mul_le_mul_left h2 hq
      have hia : 2 ^ j ≤ Qval h a := ih a (hstep a hqa2)
      have hib : 2 ^ j ≤ Qval h b := ih b (hstep b hqb2)
      -- assemble via the recurrence at m
      have hrec := Qval_rec h hm3
      rw [← hx, ← hy, ← ha, ← hb] at hrec
      have hpow : 2 ^ (j+1) = 2 ^ j + 2 ^ j := by rw [Nat.pow_succ]; omega
      omega
  -- Choose the level j and a witness m just above the level-j threshold.
  obtain ⟨j, hj⟩ : ∃ j, j = p * (C + 1) + 1 := ⟨_, rfl⟩
  obtain ⟨D, hD⟩ : ∃ D, D = q ^ j * C := ⟨_, rfl⟩
  obtain ⟨E, hE⟩ : ∃ E, E = (q - p) ^ j := ⟨_, rfl⟩
  have hEpos : 0 < E := hE ▸ Nat.pow_pos (by omega)
  obtain ⟨m, hm⟩ : ∃ m, m = D / E + 1 := ⟨_, rfl⟩
  have hdm : E * (D / E) + D % E = D := Nat.div_add_mod D E
  have hmod : D % E < E := Nat.mod_lt D hEpos
  have hEm : E * m = E * (D / E) + E := by rw [hm, Nat.mul_add, Nat.mul_one]
  -- (i) m meets the level-j threshold, so its value is at least 2^j
  have hthr : q ^ j * C ≤ E * m := by omega
  have hval : 2 ^ j ≤ Qval h m := key j m (hE ▸ hthr)
  -- (ii) m ≥ M, so the assumed eventual bound applies at m
  have hmC : C ≤ m := by
    have hle : E ≤ q ^ j := hE ▸ Nat.pow_le_pow_left hEq j
    have h1 : E * C ≤ E * m :=
      Nat.le_trans (Nat.mul_le_mul_right C hle) hthr
    exact Nat.le_of_mul_le_mul_left h1 hEpos
  have hMm : q * Qval h m ≤ p * m := hM m (by omega)
  -- (iii) arithmetic contradiction: q·(2^j·E) ≤ p·D + p·E, yet 2^j·E ≥ (q+1)^j
  have hq2 : q * (2 ^ j * E) ≤ p * D + p * E := by
    have h2 : q * 2 ^ j ≤ p * m := by
      have h1 : q * 2 ^ j ≤ q * Qval h m := Nat.mul_le_mul_left q hval
      omega
    have h3 : E * (q * 2 ^ j) ≤ E * (p * m) := Nat.mul_le_mul_left E h2
    have e4 : E * (p * m) = p * (E * m) := Nat.mul_left_comm E p m
    have h6 : p * (E * (D / E)) ≤ p * D := Nat.mul_le_mul_left p (by omega)
    have e5 : p * (E * m) = p * (E * (D / E)) + p * E := by rw [hEm, Nat.mul_add]
    have e7 : E * (q * 2 ^ j) = q * (2 ^ j * E) := by
      rw [Nat.mul_left_comm E q (2 ^ j), Nat.mul_comm E (2 ^ j)]
    omega
  have hpow2 : (2 * (q - p)) ^ j = 2 ^ j * E := by rw [hE, Nat.mul_pow]
  have hq1 : (q + 1) ^ j ≤ (2 * (q - p)) ^ j := Nat.pow_le_pow_left h2E j
  have hEleq : E ≤ q ^ j := hE ▸ Nat.pow_le_pow_left hEq j
  -- combine into: q·(q+1)^j ≤ q^j·(p·(C+1))
  have hcomb : q * (q + 1) ^ j ≤ q ^ j * (p * (C + 1)) := by
    have h1 : q * (q + 1) ^ j ≤ q * (2 ^ j * E) := by
      have h0 := Nat.mul_le_mul_left q hq1
      rw [hpow2] at h0; exact h0
    have h3 : p * E ≤ p * q ^ j := Nat.mul_le_mul_left p hEleq
    have hpD : p * D = p * (q ^ j * C) := by rw [hD]
    have e1 : q ^ j * (p * (C + 1)) = p * (q ^ j * C) + p * q ^ j := by
      rw [Nat.mul_left_comm (q ^ j) p (C + 1), Nat.mul_add (q ^ j) C 1,
          Nat.mul_one, Nat.mul_add]
    omega
  -- Bernoulli forces q + j ≤ p·(C+1), contradicting j = p·(C+1) + 1
  have hbern := bernoulli_aux q j
  have hqj : 0 < q ^ j := Nat.pow_pos hq
  have hlast : q + j ≤ p * (C + 1) :=
    Nat.le_of_mul_le_mul_left (by omega : q ^ j * (q + j) ≤ q ^ j * (p * (C + 1))) hqj
  omega

/-- **Upper exclusion, sharp.**  Under Problem A, for any rational
`p/q > 1/2` it is impossible that `Q(m) ≥ (p/q)·m` for all sufficiently
large `m`.  (In particular the ratio `Q(n)/n` cannot tend to any limit above
`1/2`, and `liminf Q(n)/n ≤ 1/2`.)  Supersedes
`not_eventually_ge_three_quarters` (threshold ¾ → sharp ½). -/
theorem not_eventually_ge_of_gt_half (h : ProblemA) {p q : Nat} (hpq : q < 2 * p) :
    ¬ ∃ M : Nat, ∀ m : Nat, M ≤ m → p * m ≤ q * Qval h m := by
  rintro ⟨M, hM⟩
  rcases Nat.lt_or_ge q p with hqp | hple
  · -- q < p is immediately absurd: p·m ≤ q·Q(m) ≤ q·m < p·m
    have h1 := hM (M + 1) (by omega)
    have h2 : Qval h (M + 1) ≤ M + 1 := Qval_le_self h (by omega)
    have h3 : q * Qval h (M + 1) ≤ q * (M + 1) := Nat.mul_le_mul_left q h2
    have h4 : q * (M + 1) < p * (M + 1) := (Nat.mul_lt_mul_right (by omega)).mpr hqp
    omega
  -- main case: q/2 < p ≤ q, so r := 2(q−p) < q
  have hq : 0 < q := by omega
  have hp : 0 < p := by omega
  have hrq : 2 * (q - p) < q := by omega
  -- one refinement step: an eventual envelope q^k·Q ≤ r^k·n + D improves to k+1
  have step : ∀ k N D,
      (∀ n, N ≤ n → q ^ k * Qval h n ≤ (2 * (q - p)) ^ k * n + D) →
      (2 * (q - p)) ^ k < q ^ k →
      ∃ N' D', (∀ n, N' ≤ n →
          q ^ (k+1) * Qval h n ≤ (2 * (q - p)) ^ (k+1) * n + D') ∧
        (2 * (q - p)) ^ (k+1) < q ^ (k+1) := by
    intro k N D hU hgap
    refine ⟨M + N + D + q ^ k * (N + 2) + 5,
            (2 * (q - p)) ^ k * p + (2 * (q - p)) ^ k * (p * 2) + q * D + q * D,
            ?_, ?_⟩
    · intro n hn
      have hn3 : M + 3 ≤ n := by omega
      have hnN : N + 2 ≤ n := by omega
      have hnD : D + q ^ k * (N + 2) ≤ n := by omega
      -- the two lookups
      obtain ⟨x, hx⟩ : ∃ x, x = Qval h (n - 1) := ⟨_, rfl⟩
      obtain ⟨y, hy⟩ : ∃ y, y = Qval h (n - 2) := ⟨_, rfl⟩
      have hx_le : x ≤ n - 1 := hx ▸ Qval_le_self h (by omega)
      have hy_le : y ≤ n - 2 := hy ▸ Qval_le_self h (by omega)
      obtain ⟨a, ha⟩ : ∃ a, a = n - x := ⟨_, rfl⟩
      obtain ⟨b, hb⟩ : ∃ b, b = n - y := ⟨_, rfl⟩
      have hax : a + x = n := by omega
      have hby : b + y = n := by omega
      -- upper bounds on q·a, q·b from the assumed linear floor at n−1, n−2
      have hMx : p * (n - 1) ≤ q * x := hx ▸ hM (n - 1) (by omega)
      have hMy : p * (n - 2) ≤ q * y := hy ▸ hM (n - 2) (by omega)
      have hqa : q * a + q * x = q * n := by rw [← Nat.mul_add, hax]
      have hqb : q * b + q * y = q * n := by rw [← Nat.mul_add, hby]
      have hlink : (q - p) * n + p * n = q * n := by
        rw [← Nat.add_mul]; congr 1; omega
      have hpn1 : p * n ≤ p * (n - 1) + p := by
        have h' : p * n ≤ p * ((n - 1) + 1) := Nat.mul_le_mul_left p (by omega)
        rw [Nat.mul_add, Nat.mul_one] at h'; exact h'
      have hpn2 : p * n ≤ p * (n - 2) + p * 2 := by
        have h' : p * n ≤ p * ((n - 2) + 2) := Nat.mul_le_mul_left p (by omega)
        rw [Nat.mul_add] at h'; exact h'
      have hqa_ub : q * a ≤ (q - p) * n + p := by omega
      have hqb_ub : q * b ≤ (q - p) * n + p * 2 := by omega
      -- lower bounds: a, b ≥ N + 2, so the level-k envelope applies at a and b
      have hgap_n : (2 * (q - p)) ^ k * n + n ≤ q ^ k * n := by
        have h' := Nat.mul_le_mul_right n (show (2 * (q - p)) ^ k + 1 ≤ q ^ k from hgap)
        rw [Nat.add_mul, Nat.one_mul] at h'; exact h'
      have hUx : q ^ k * x ≤ (2 * (q - p)) ^ k * n + D := by
        have h1 : q ^ k * x ≤ (2 * (q - p)) ^ k * (n - 1) + D := hx ▸ hU (n - 1) (by omega)
        have h2 : (2 * (q - p)) ^ k * (n - 1) ≤ (2 * (q - p)) ^ k * n :=
          Nat.mul_le_mul_left _ (by omega)
        omega
      have hUy : q ^ k * y ≤ (2 * (q - p)) ^ k * n + D := by
        have h1 : q ^ k * y ≤ (2 * (q - p)) ^ k * (n - 2) + D := hy ▸ hU (n - 2) (by omega)
        have h2 : (2 * (q - p)) ^ k * (n - 2) ≤ (2 * (q - p)) ^ k * n :=
          Nat.mul_le_mul_left _ (by omega)
        omega
      have hqka : q ^ k * a + q ^ k * x = q ^ k * n := by rw [← Nat.mul_add, hax]
      have hqkb : q ^ k * b + q ^ k * y = q ^ k * n := by rw [← Nat.mul_add, hby]
      have haN : N ≤ a := by
        have h1 : q ^ k * (N + 2) ≤ q ^ k * a := by omega
        have := Nat.le_of_mul_le_mul_left h1 (Nat.pow_pos hq)
        omega
      have hbN : N ≤ b := by
        have h1 : q ^ k * (N + 2) ≤ q ^ k * b := by omega
        have := Nat.le_of_mul_le_mul_left h1 (Nat.pow_pos hq)
        omega
      -- level-k envelope at a and b
      have hUa : q ^ k * Qval h a ≤ (2 * (q - p)) ^ k * a + D := hU a haN
      have hUb : q ^ k * Qval h b ≤ (2 * (q - p)) ^ k * b + D := hU b hbN
      -- the recurrence at n
      have hrec := Qval_rec h (show 3 ≤ n by omega)
      rw [← hx, ← hy, ← ha, ← hb] at hrec
      -- assemble the level-(k+1) envelope
      have hrecq : q ^ k * Qval h n = q ^ k * Qval h a + q ^ k * Qval h b := by
        rw [hrec, Nat.mul_add]
      have epow : q ^ (k+1) * Qval h n = q * (q ^ k * Qval h n) := by
        rw [Nat.pow_succ, Nat.mul_comm (q ^ k) q, Nat.mul_assoc]
      have hUa' : q * (q ^ k * Qval h a) ≤ q * ((2 * (q - p)) ^ k * a) + q * D := by
        have h' := Nat.mul_le_mul_left q hUa
        rw [Nat.mul_add] at h'; exact h'
      have hUb' : q * (q ^ k * Qval h b) ≤ q * ((2 * (q - p)) ^ k * b) + q * D := by
        have h' := Nat.mul_le_mul_left q hUb
        rw [Nat.mul_add] at h'; exact h'
      have hmulq : q * (q ^ k * Qval h n)
          = q * (q ^ k * Qval h a) + q * (q ^ k * Qval h b) := by
        rw [hrecq, Nat.mul_add]
      have e_a : q * ((2 * (q - p)) ^ k * a) = (2 * (q - p)) ^ k * (q * a) :=
        Nat.mul_left_comm q ((2 * (q - p)) ^ k) a
      have e_b : q * ((2 * (q - p)) ^ k * b) = (2 * (q - p)) ^ k * (q * b) :=
        Nat.mul_left_comm q ((2 * (q - p)) ^ k) b
      have hra : (2 * (q - p)) ^ k * (q * a)
          ≤ (2 * (q - p)) ^ k * ((q - p) * n) + (2 * (q - p)) ^ k * p := by
        have h' := Nat.mul_le_mul_left ((2 * (q - p)) ^ k) hqa_ub
        rw [Nat.mul_add] at h'; exact h'
      have hrb : (2 * (q - p)) ^ k * (q * b)
          ≤ (2 * (q - p)) ^ k * ((q - p) * n) + (2 * (q - p)) ^ k * (p * 2) := by
        have h' := Nat.mul_le_mul_left ((2 * (q - p)) ^ k) hqb_ub
        rw [Nat.mul_add] at h'; exact h'
      have rlinkn : (2 * (q - p)) * n = (q - p) * n + (q - p) * n := by
        rw [Nat.mul_assoc, Nat.two_mul]
      have rn : (2 * (q - p)) ^ (k+1) * n
          = (2 * (q - p)) ^ k * ((q - p) * n) + (2 * (q - p)) ^ k * ((q - p) * n) := by
        rw [Nat.pow_succ, Nat.mul_assoc, rlinkn, Nat.mul_add]
      omega
    · -- gap preservation: r^{k+1} < q^{k+1}
      have h1 : (2 * (q - p)) ^ (k+1) ≤ (2 * (q - p)) ^ k * q := by
        rw [Nat.pow_succ]
        exact Nat.mul_le_mul_left _ (by omega)
      have h2 : (2 * (q - p)) ^ k * q < q ^ k * q :=
        (Nat.mul_lt_mul_right hq).mpr hgap
      have e : q ^ k * q = q ^ (k+1) := (Nat.pow_succ q k).symm
      omega
  -- iterate the refinement: an envelope exists at every level k+1
  have Uk : ∀ k, ∃ N D,
      (∀ n, N ≤ n → q ^ (k+1) * Qval h n ≤ (2 * (q - p)) ^ (k+1) * n + D) ∧
      (2 * (q - p)) ^ (k+1) < q ^ (k+1) := by
    intro k
    induction k with
    | zero =>
      -- level 1 from the one-step argument (this is the ¾-type step, at ½+)
      simp only [Nat.zero_add]
      refine ⟨M + 3, 3 * p, ?_, ?_⟩
      · intro n hn
        obtain ⟨x, hx⟩ : ∃ x, x = Qval h (n - 1) := ⟨_, rfl⟩
        obtain ⟨y, hy⟩ : ∃ y, y = Qval h (n - 2) := ⟨_, rfl⟩
        have hx_le : x ≤ n - 1 := hx ▸ Qval_le_self h (by omega)
        have hy_le : y ≤ n - 2 := hy ▸ Qval_le_self h (by omega)
        obtain ⟨a, ha⟩ : ∃ a, a = n - x := ⟨_, rfl⟩
        obtain ⟨b, hb⟩ : ∃ b, b = n - y := ⟨_, rfl⟩
        have hax : a + x = n := by omega
        have hby : b + y = n := by omega
        have hMx : p * (n - 1) ≤ q * x := hx ▸ hM (n - 1) (by omega)
        have hMy : p * (n - 2) ≤ q * y := hy ▸ hM (n - 2) (by omega)
        have hqa : q * a + q * x = q * n := by rw [← Nat.mul_add, hax]
        have hqb : q * b + q * y = q * n := by rw [← Nat.mul_add, hby]
        have hlink : (q - p) * n + p * n = q * n := by
          rw [← Nat.add_mul]; congr 1; omega
        have hpn1 : p * n ≤ p * (n - 1) + p := by
          have h' : p * n ≤ p * ((n - 1) + 1) := Nat.mul_le_mul_left p (by omega)
          rw [Nat.mul_add, Nat.mul_one] at h'; exact h'
        have hpn2 : p * n ≤ p * (n - 2) + p * 2 := by
          have h' : p * n ≤ p * ((n - 2) + 2) := Nat.mul_le_mul_left p (by omega)
          rw [Nat.mul_add] at h'; exact h'
        have hQa : Qval h a ≤ a := Qval_le_self h (by omega)
        have hQb : Qval h b ≤ b := Qval_le_self h (by omega)
        have hrec := Qval_rec h (show 3 ≤ n by omega)
        rw [← hx, ← hy, ← ha, ← hb] at hrec
        have hmul : q * Qval h n = q * Qval h a + q * Qval h b := by
          rw [hrec, Nat.mul_add]
        have hqva : q * Qval h a ≤ q * a := Nat.mul_le_mul_left q hQa
        have hqvb : q * Qval h b ≤ q * b := Nat.mul_le_mul_left q hQb
        have rlinkn : (2 * (q - p)) * n = (q - p) * n + (q - p) * n := by
          rw [Nat.mul_assoc, Nat.two_mul]
        have e1 : q ^ 1 * Qval h n = q * Qval h n := by rw [Nat.pow_one]
        have e2 : (2 * (q - p)) ^ 1 * n = (2 * (q - p)) * n := by rw [Nat.pow_one]
        omega
      · have e1 : (2 * (q - p)) ^ 1 = 2 * (q - p) := Nat.pow_one _
        have e2 : q ^ 1 = q := Nat.pow_one q
        omega
    | succ k ih =>
      obtain ⟨N, D, hU, hgap⟩ := ih
      exact step (k+1) N D hU hgap
  -- choose the level K = q·r + 1 at which the envelope drops below the floor
  obtain ⟨K, hK⟩ : ∃ K, K = q * (2 * (q - p)) + 1 := ⟨_, rfl⟩
  have hKpos : 1 ≤ K := by omega
  -- p·q^K > q·r^K at that level
  have hgt : q * (2 * (q - p)) ^ K < p * q ^ K := by
    rcases Nat.eq_zero_or_pos (q - p) with hr0 | hrpos
    · -- r = 0 (p = q): the level-K envelope is a constant, the floor is linear
      have e : (2 * (q - p)) ^ K = 0 := by
        rw [hr0, Nat.mul_zero]
        exact Nat.zero_pow (by omega)
      rw [e, Nat.mul_zero]
      exact Nat.mul_pos hp (Nat.pow_pos hq)
    · -- r ≥ 1: Bernoulli at base r beats the ratio q·r/p in K steps
      have hb := bernoulli_aux (2 * (q - p)) K
      have hq1 : (2 * (q - p)) + 1 ≤ q := by omega
      have h1 : (2 * (q - p)) * ((2 * (q - p)) + 1) ^ K ≤ (2 * (q - p)) * q ^ K :=
        Nat.mul_le_mul_left _ (Nat.pow_le_pow_left hq1 K)
      have h2 : (2 * (q - p)) ^ K * ((2 * (q - p)) + K) ≤ (2 * (q - p)) * q ^ K :=
        Nat.le_trans hb h1
      have h3 : p * ((2 * (q - p)) ^ K * ((2 * (q - p)) + K))
          ≤ p * ((2 * (q - p)) * q ^ K) := Nat.mul_le_mul_left p h2
      have e4 : p * ((2 * (q - p)) ^ K * ((2 * (q - p)) + K))
          = (2 * (q - p)) ^ K * (p * ((2 * (q - p)) + K)) :=
        Nat.mul_left_comm p ((2 * (q - p)) ^ K) _
      have e5 : p * ((2 * (q - p)) * q ^ K) = (2 * (q - p)) * (p * q ^ K) :=
        Nat.mul_left_comm p (2 * (q - p)) _
      have h6 : q * (2 * (q - p)) + 1 ≤ p * ((2 * (q - p)) + K) := by
        have h' : 1 * ((2 * (q - p)) + K) ≤ p * ((2 * (q - p)) + K) :=
          Nat.mul_le_mul_right _ hp
        rw [Nat.one_mul] at h'
        omega
      have h7 : (2 * (q - p)) ^ K * (q * (2 * (q - p)) + 1)
          ≤ (2 * (q - p)) ^ K * (p * ((2 * (q - p)) + K)) :=
        Nat.mul_le_mul_left _ h6
      have e8 : (2 * (q - p)) ^ K * (q * (2 * (q - p)) + 1)
          = q * ((2 * (q - p)) * (2 * (q - p)) ^ K) + (2 * (q - p)) ^ K := by
        rw [Nat.mul_add, Nat.mul_one, Nat.mul_left_comm ((2 * (q - p)) ^ K) q _,
            Nat.mul_comm ((2 * (q - p)) ^ K) (2 * (q - p))]
      have hrKpos : 0 < (2 * (q - p)) ^ K := Nat.pow_pos (by omega)
      have h9 : q * ((2 * (q - p)) * (2 * (q - p)) ^ K)
          < (2 * (q - p)) * (p * q ^ K) := by omega
      have e10 : q * ((2 * (q - p)) * (2 * (q - p)) ^ K)
          = (2 * (q - p)) * (q * (2 * (q - p)) ^ K) :=
        Nat.mul_left_comm q (2 * (q - p)) _
      rw [e10] at h9
      exact Nat.lt_of_mul_lt_mul_left h9
  -- the level-K envelope plus the floor bound every large n — contradiction
  obtain ⟨N, D, hU, -⟩ := Uk (K - 1)
  have hKe : K - 1 + 1 = K := by omega
  rw [hKe] at hU
  obtain ⟨n, hn⟩ : ∃ n, n = N + M + q * D + 1 := ⟨_, rfl⟩
  have hMn : p * n ≤ q * Qval h n := hM n (by omega)
  have hUn : q ^ K * Qval h n ≤ (2 * (q - p)) ^ K * n + D := hU n (by omega)
  have h1 : q ^ K * (p * n) ≤ q ^ K * (q * Qval h n) := Nat.mul_le_mul_left _ hMn
  have e2 : q ^ K * (q * Qval h n) = q * (q ^ K * Qval h n) :=
    Nat.mul_left_comm (q ^ K) q _
  have h3 : q * (q ^ K * Qval h n)
      ≤ q * ((2 * (q - p)) ^ K * n) + q * D := by
    have h' := Nat.mul_le_mul_left q hUn
    rw [Nat.mul_add] at h'; exact h'
  have e4 : q ^ K * (p * n) = (p * q ^ K) * n := by
    rw [Nat.mul_left_comm (q ^ K) p n, ← Nat.mul_assoc]
  have e5 : q * ((2 * (q - p)) ^ K * n) = (q * (2 * (q - p)) ^ K) * n :=
    (Nat.mul_assoc q _ n).symm
  have h6 : (q * (2 * (q - p)) ^ K + 1) * n ≤ (p * q ^ K) * n :=
    Nat.mul_le_mul_right n hgt
  have e7 : (q * (2 * (q - p)) ^ K + 1) * n = (q * (2 * (q - p)) ^ K) * n + n := by
    rw [Nat.add_mul, Nat.one_mul]
  omega

/-- Under Problem A, for every rational `p/q > 1/2` there are infinitely many
`m` with `Q(m)/m < p/q`:  **`liminf Q(n)/n ≤ 1/2`**. -/
theorem frequently_lt_of_gt_half (h : ProblemA) {p q : Nat} (hpq : q < 2 * p)
    (M : Nat) : ∃ m : Nat, M ≤ m ∧ q * Qval h m < p * m := by
  refine Classical.byContradiction fun hc => ?_
  refine not_eventually_ge_of_gt_half h hpq ⟨M, fun m hm => ?_⟩
  rcases Nat.lt_or_ge (q * Qval h m) (p * m) with hlt | hge
  · exact absurd ⟨m, hm, hlt⟩ hc
  · exact hge

/-- Under Problem A, for every rational `p/q < 1/2` there are infinitely many
`m` with `Q(m)/m > p/q`:  **`limsup Q(n)/n ≥ 1/2`**. -/
theorem frequently_gt_of_lt_half (h : ProblemA) {p q : Nat} (hpq : 2 * p < q)
    (M : Nat) : ∃ m : Nat, M ≤ m ∧ p * m < q * Qval h m := by
  refine Classical.byContradiction fun hc => ?_
  refine not_eventually_le_of_lt_half h hpq ⟨M, fun m hm => ?_⟩
  rcases Nat.lt_or_ge (p * m) (q * Qval h m) with hlt | hge
  · exact absurd ⟨m, hm, hlt⟩ hc
  · exact hge

end QSequence
