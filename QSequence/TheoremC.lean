/-
# Theorem C machine-checked: if the ratio converges, its limit is 1/2

`RatioCauchy h` is the honest integer form of "`Q(n)/n` converges": the
sequence of ratios is Cauchy, stated by cross-multiplication with no real
numbers (`|Q(m)/m − Q(n)/n| ≤ 1/k` for all large `m, n`, for every `k`).

The main theorem `problemB_of_ratioCauchy` proves, under Problem A:

    if the ratio sequence is Cauchy, then Q(n)/n → 1/2  (i.e. `ProblemB`).

This is the full conditional-limit theorem (Theorem C of REPORT.md, the
classical Golomb lemma) — machine-checked, including both endpoint
exclusions, which enter through the sharp half-exclusions of
`HalfExclusions.lean`:

* by `frequently_lt_of_gt_half`, some `m₀ ≥ N` has `Q(m₀)/m₀ < 1/2 + 1/(4k)`;
* by `frequently_gt_of_lt_half`, some `m₁ ≥ N` has `Q(m₁)/m₁ > 1/2 − 1/(4k)`;
* the Cauchy estimate transfers these one-point bounds to **every** `n ≥ N`,
  giving `|Q(n)/n − 1/2| < 1/(2k)` — no fixed-point analysis, no case split
  on the limit value, and in particular no assumption on where the limit
  lies.

Together with the converse `ratioCauchy_of_problemB`, this pins Gap B
(REPORT.md §9) exactly: **under Problem A, `ProblemB` is equivalent to the
single statement `RatioCauchy`** — "the ratio sequence is Cauchy."

No `native_decide`; axioms are the standard three.
-/
import QSequence.HalfExclusions

namespace QSequence

/-- "The limit of `Q(n)/n` exists", in integer Cauchy form: for every
accuracy `k` there is a threshold `N` beyond which any two ratios differ by
at most `1/k`:  `|Q(m)·n − Q(n)·m| · k ≤ m·n`. -/
def RatioCauchy (h : ProblemA) : Prop :=
  ∀ k : Nat, 1 ≤ k → ∃ N : Nat, 1 ≤ N ∧ ∀ m n : Nat, N ≤ m → N ≤ n →
    Int.natAbs ((↑(Qval h m * n) : Int) - ↑(Qval h n * m)) * k ≤ m * n

/-- **Theorem C (Golomb's conditional-limit lemma), machine-checked.**
Under Problem A: if the ratio `Q(n)/n` is Cauchy, it converges to `1/2`. -/
theorem problemB_of_ratioCauchy (h : ProblemA) (hC : RatioCauchy h) : ProblemB h := by
  intro k hk
  -- Cauchy estimate at accuracy 4k
  obtain ⟨N, hN1, hNC⟩ := hC (4 * k) (by omega)
  -- a point m₀ ≥ N with ratio below 1/2 + 1/(4k)
  obtain ⟨m₀, hm₀N, hm₀⟩ := frequently_lt_of_gt_half h
    (p := 4 * k + 2) (q := 2 * (4 * k)) (by omega) N
  -- a point m₁ ≥ N with ratio above 1/2 − 1/(4k)
  obtain ⟨m₁, hm₁N, hm₁⟩ := frequently_gt_of_lt_half h
    (p := 4 * k - 2) (q := 2 * (4 * k)) (by omega) N
  refine ⟨N, fun n hn => ?_⟩
  have hn1 : 1 ≤ n := by omega
  have hm₀1 : 1 ≤ m₀ := by omega
  have hm₁1 : 1 ≤ m₁ := by omega
  -- == upper estimate: 8·(k·Q(n)) < 4·(k·n) + 4·n ==
  have hup : 2 * (4 * (k * Qval h n)) < 4 * (k * n) + 4 * n := by
    have hc0 := hNC m₀ n hm₀N hn
    -- Q(n)·m₀ ≤ Q(m₀)·n + |·|
    have hYX : Qval h n * m₀ ≤ Qval h m₀ * n
        + Int.natAbs ((↑(Qval h m₀ * n) : Int) - ↑(Qval h n * m₀)) := by omega
    have h2 := Nat.mul_le_mul_left (4 * k) hYX
    rw [Nat.mul_add] at h2
    have hcomm : (4 * k) * Int.natAbs ((↑(Qval h m₀ * n) : Int) - ↑(Qval h n * m₀))
        = Int.natAbs ((↑(Qval h m₀ * n) : Int) - ↑(Qval h n * m₀)) * (4 * k) :=
      Nat.mul_comm ..
    -- so (4k)·(Q(n)·m₀) ≤ (4k)·(Q(m₀)·n) + m₀·n
    have hU4 : (4 * k) * (Qval h n * m₀) ≤ (4 * k) * (Qval h m₀ * n) + m₀ * n := by
      omega
    -- witness estimate times n
    have hU5 := (Nat.mul_lt_mul_right (show 0 < n by omega)).mpr hm₀
    have eL : ((2 * (4 * k)) * Qval h m₀) * n = 2 * ((4 * k) * (Qval h m₀ * n)) := by
      rw [Nat.mul_assoc 2 (4 * k) (Qval h m₀), Nat.mul_assoc 2 ((4 * k) * Qval h m₀) n,
          Nat.mul_assoc (4 * k) (Qval h m₀) n]
    have eR : ((4 * k + 2) * m₀) * n = (4 * k) * (m₀ * n) + 2 * (m₀ * n) := by
      rw [Nat.mul_assoc (4 * k + 2) m₀ n, Nat.add_mul (4 * k) 2 (m₀ * n)]
    rw [eL, eR] at hU5
    -- combine and cancel m₀ (right factor)
    have hU8 : (2 * ((4 * k) * Qval h n)) * m₀ < ((4 * k) * n + 4 * n) * m₀ := by
      have e1 : (2 * ((4 * k) * Qval h n)) * m₀ = 2 * ((4 * k) * (Qval h n * m₀)) := by
        rw [Nat.mul_assoc 2 ((4 * k) * Qval h n) m₀, Nat.mul_assoc (4 * k) (Qval h n) m₀]
      have e2 : ((4 * k) * n + 4 * n) * m₀
          = (4 * k) * (m₀ * n) + 4 * (m₀ * n) := by
        rw [Nat.add_mul ((4 * k) * n) (4 * n) m₀, Nat.mul_assoc (4 * k) n m₀,
            Nat.mul_comm n m₀, Nat.mul_assoc 4 n m₀, Nat.mul_comm n m₀]
      rw [e1, e2]
      omega
    have hU9 : 2 * ((4 * k) * Qval h n) < (4 * k) * n + 4 * n :=
      Nat.lt_of_mul_lt_mul_right hU8
    rw [Nat.mul_assoc 4 k (Qval h n), Nat.mul_assoc 4 k n] at hU9
    exact hU9
  -- == lower estimate: 4·(k·n) < 8·(k·Q(n)) + 4·n ==
  have hlo : 4 * (k * n) < 2 * (4 * (k * Qval h n)) + 4 * n := by
    have hc1 := hNC m₁ n hm₁N hn
    -- Q(m₁)·n ≤ Q(n)·m₁ + |·|
    have hXY : Qval h m₁ * n ≤ Qval h n * m₁
        + Int.natAbs ((↑(Qval h m₁ * n) : Int) - ↑(Qval h n * m₁)) := by omega
    have h2 := Nat.mul_le_mul_left (4 * k) hXY
    rw [Nat.mul_add] at h2
    have hcomm : (4 * k) * Int.natAbs ((↑(Qval h m₁ * n) : Int) - ↑(Qval h n * m₁))
        = Int.natAbs ((↑(Qval h m₁ * n) : Int) - ↑(Qval h n * m₁)) * (4 * k) :=
      Nat.mul_comm ..
    -- so (4k)·(Q(m₁)·n) ≤ (4k)·(Q(n)·m₁) + m₁·n
    have hL4 : (4 * k) * (Qval h m₁ * n) ≤ (4 * k) * (Qval h n * m₁) + m₁ * n := by
      omega
    -- witness estimate times n
    have hL5 := (Nat.mul_lt_mul_right (show 0 < n by omega)).mpr hm₁
    have eL : ((4 * k - 2) * m₁) * n = (4 * k) * (m₁ * n) - 2 * (m₁ * n) := by
      rw [Nat.mul_assoc (4 * k - 2) m₁ n, Nat.sub_mul (4 * k) 2 (m₁ * n)]
    have eR : ((2 * (4 * k)) * Qval h m₁) * n = 2 * ((4 * k) * (Qval h m₁ * n)) := by
      rw [Nat.mul_assoc 2 (4 * k) (Qval h m₁), Nat.mul_assoc 2 ((4 * k) * Qval h m₁) n,
          Nat.mul_assoc (4 * k) (Qval h m₁) n]
    rw [eL, eR] at hL5
    -- combine and cancel m₁ (right factor)
    have hL8 : ((4 * k) * n) * m₁ < (2 * ((4 * k) * Qval h n) + 4 * n) * m₁ := by
      have e1 : ((4 * k) * n) * m₁ = (4 * k) * (m₁ * n) := by
        rw [Nat.mul_assoc (4 * k) n m₁, Nat.mul_comm n m₁]
      have e2 : (2 * ((4 * k) * Qval h n) + 4 * n) * m₁
          = 2 * ((4 * k) * (Qval h n * m₁)) + 4 * (m₁ * n) := by
        rw [Nat.add_mul (2 * ((4 * k) * Qval h n)) (4 * n) m₁,
            Nat.mul_assoc 2 ((4 * k) * Qval h n) m₁, Nat.mul_assoc (4 * k) (Qval h n) m₁,
            Nat.mul_assoc 4 n m₁, Nat.mul_comm n m₁]
      rw [e1, e2]
      omega
    have hL9 : (4 * k) * n < 2 * ((4 * k) * Qval h n) + 4 * n :=
      Nat.lt_of_mul_lt_mul_right hL8
    rw [Nat.mul_assoc 4 k (Qval h n), Nat.mul_assoc 4 k n] at hL9
    exact hL9
  -- == combine: |2·Q(n) − n| · k < n ==
  have eabs : Int.natAbs (2 * (↑(Qval h n) : Int) - ↑n)
      = (2 * Qval h n - n) + (n - 2 * Qval h n) := by omega
  rw [eabs, Nat.add_mul, Nat.sub_mul (2 * Qval h n) n k, Nat.sub_mul n (2 * Qval h n) k,
      Nat.mul_assoc 2 (Qval h n) k, Nat.mul_comm (Qval h n) k, Nat.mul_comm n k]
  omega

/-- **Converse**: if `Q(n)/n → 1/2` then in particular the ratio sequence is
Cauchy.  (Elementary; makes the equivalence below exact.) -/
theorem ratioCauchy_of_problemB (h : ProblemA) (hB : ProblemB h) : RatioCauchy h := by
  intro k hk
  obtain ⟨N₀, hN₀⟩ := hB (2 * k) (by omega)
  refine ⟨N₀ + 1, by omega, fun m n hm hn => ?_⟩
  have hbm := hN₀ m (by omega)
  have hbn := hN₀ n (by omega)
  have hm1 : 1 ≤ m := by omega
  have hn1 : 1 ≤ n := by omega
  -- the exact identity 2·(Q(m)·n − Q(n)·m) = (2Q(m) − m)·n − (2Q(n) − n)·m
  have eid : 2 * ((↑(Qval h m * n) : Int) - ↑(Qval h n * m))
      = (2 * (Qval h m : Int) - (m : Int)) * ↑n
        - (2 * (Qval h n : Int) - (n : Int)) * ↑m := by
    rw [Int.natCast_mul, Int.natCast_mul,
        Int.sub_mul (2 * (Qval h m : Int)) (m : Int) (n : Int),
        Int.sub_mul (2 * (Qval h n : Int)) (n : Int) (m : Int),
        Int.mul_assoc 2 (Qval h m : Int) (n : Int),
        Int.mul_assoc 2 (Qval h n : Int) (m : Int)]
    have ecomm : ((n : Int)) * (m : Int) = (m : Int) * (n : Int) := Int.mul_comm ..
    omega
  -- take absolute values: 2·|Q(m)·n − Q(n)·m| ≤ |2Q(m) − m|·n + |2Q(n) − n|·m
  have h2D : Int.natAbs (2 * ((↑(Qval h m * n) : Int) - ↑(Qval h n * m)))
      = 2 * Int.natAbs ((↑(Qval h m * n) : Int) - ↑(Qval h n * m)) := by
    rw [Int.natAbs_mul]; rfl
  have habs := congrArg Int.natAbs eid
  have htri : Int.natAbs ((2 * (Qval h m : Int) - (m : Int)) * ↑n
        - (2 * (Qval h n : Int) - (n : Int)) * ↑m)
      ≤ Int.natAbs ((2 * (Qval h m : Int) - (m : Int)) * ↑n)
        + Int.natAbs ((2 * (Qval h n : Int) - (n : Int)) * ↑m) := by omega
  have em : Int.natAbs ((2 * (Qval h m : Int) - (m : Int)) * ↑n)
      = Int.natAbs (2 * (Qval h m : Int) - (m : Int)) * n := by
    rw [Int.natAbs_mul, Int.natAbs_natCast]
  have en : Int.natAbs ((2 * (Qval h n : Int) - (n : Int)) * ↑m)
      = Int.natAbs (2 * (Qval h n : Int) - (n : Int)) * m := by
    rw [Int.natAbs_mul, Int.natAbs_natCast]
  have hkey : 2 * Int.natAbs ((↑(Qval h m * n) : Int) - ↑(Qval h n * m))
      ≤ Int.natAbs (2 * (Qval h m : Int) - (m : Int)) * n
        + Int.natAbs (2 * (Qval h n : Int) - (n : Int)) * m := by omega
  -- scale by k and use the two ProblemB bounds
  have t1 := Nat.mul_le_mul_left k hkey
  rw [Nat.mul_add] at t1
  have e0 : k * (2 * Int.natAbs ((↑(Qval h m * n) : Int) - ↑(Qval h n * m)))
      = 2 * (k * Int.natAbs ((↑(Qval h m * n) : Int) - ↑(Qval h n * m))) :=
    Nat.mul_left_comm ..
  rw [e0] at t1
  -- |2Q(m) − m|·(2k) < m, times n, rearranged
  have hbm' := (Nat.mul_lt_mul_right (show 0 < n by omega)).mpr hbm
  rw [Nat.mul_comm (Int.natAbs (2 * (Qval h m : Int) - (m : Int))) (2 * k),
      Nat.mul_assoc (2 * k) (Int.natAbs (2 * (Qval h m : Int) - (m : Int))) n,
      Nat.mul_assoc 2 k (Int.natAbs (2 * (Qval h m : Int) - (m : Int)) * n)] at hbm'
  -- |2Q(n) − n|·(2k) < n, times m, rearranged
  have hbn' := (Nat.mul_lt_mul_right (show 0 < m by omega)).mpr hbn
  rw [Nat.mul_comm (Int.natAbs (2 * (Qval h n : Int) - (n : Int))) (2 * k),
      Nat.mul_assoc (2 * k) (Int.natAbs (2 * (Qval h n : Int) - (n : Int))) m,
      Nat.mul_assoc 2 k (Int.natAbs (2 * (Qval h n : Int) - (n : Int)) * m)] at hbn'
  -- rearrange the products k·(dm·n), k·(dn·m) to match t1's atoms; conclude
  have exm : k * (Int.natAbs (2 * (Qval h m : Int) - (m : Int)) * n)
      = Int.natAbs (2 * (Qval h m : Int) - (m : Int)) * n * k := by
    rw [Nat.mul_comm]
  have exn : k * (Int.natAbs (2 * (Qval h n : Int) - (n : Int)) * m)
      = Int.natAbs (2 * (Qval h n : Int) - (n : Int)) * m * k := by
    rw [Nat.mul_comm]
  have ecomm2 : n * m = m * n := Nat.mul_comm n m
  have egoal : Int.natAbs ((↑(Qval h m * n) : Int) - ↑(Qval h n * m)) * k
      = k * Int.natAbs ((↑(Qval h m * n) : Int) - ↑(Qval h n * m)) := Nat.mul_comm ..
  omega

/-- **Gap B, pinned exactly**: under Problem A, the asymptotic problem is
*equivalent* to the single statement "the ratio sequence `Q(n)/n` is Cauchy."
The hard content of Problem B is existence of the limit and nothing else. -/
theorem problemB_iff_ratioCauchy (h : ProblemA) : ProblemB h ↔ RatioCauchy h :=
  ⟨ratioCauchy_of_problemB h, problemB_of_ratioCauchy h⟩

end QSequence
