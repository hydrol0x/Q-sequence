/-
# Engine ⟷ specification: full faithfulness, every `N`

This module discharges the obligation left open by the scaffold: the fast
engine (`QSequence.Engine`) computes *exactly* the mathematically specified
sequence (`QSequence.Spec`), for every `N` — not merely on a `native_decide`d
finite window.  Both directions are proved:

* `build_sound`     — if the engine returns a history, it *is* a history
                      (spec sense) of exactly the requested length;
* `build_isSome_of_history` — if a spec-history of length ≥ N exists, the
                      engine cannot die before N;
* `aliveUpTo_iff_history` — hence `aliveUpTo N = true ↔ ∃ a, IsHistory a ∧
                      a.length = N`: an engine run *is* a spec-level
                      certificate, and an engine death would be a spec-level
                      death;
* `Qeng_eq_valAt`   — the engine's values agree with every history
                      (via `deterministic`).

Consequently `native_decide` on `aliveUpTo`/`Qeng` yields statements about
the *specified* Q-sequence with no faithfulness gap (the only added trust is
the `native_decide` mechanism itself, as documented in `Verify.lean`).
-/
import QSequence.Engine
import QSequence.Basic

namespace QSequence

/-- Bridge: `!`-indexing on an array = `valAt` of its list at 1-based `n`. -/
theorem getBang_eq_valAt (a : Array Nat) (n : Nat) :
    a[n - 1]! = valAt a.toList n := by
  unfold valAt
  rw [Array.getElem?_toList, getElem!_def]
  cases a[n - 1]? <;> rfl

/-- **Engine step soundness.**  A successful `step` extends a spec-history to
a spec-history. -/
theorem step_sound {a : Array Nat} (ha : IsHistory a.toList) {v : Nat}
    (hs : step a = some v) : IsHistory (a.toList ++ [v]) := by
  simp only [step] at hs
  split at hs
  · -- next index is 1: the empty history, next value 1
    next h1 =>
    obtain rfl : (1 : Nat) = v := Option.some.inj hs
    have hnil : a.toList = [] :=
      List.eq_nil_of_length_eq_zero (by rw [Array.length_toList]; omega)
    rw [hnil]
    exact isHistory_one
  · next h1 =>
    split at hs
    · -- next index is 2: history [1], next value 1
      next h2 =>
      obtain rfl : (1 : Nat) = v := Option.some.inj hs
      have hlen1 : a.toList.length = 1 := by rw [Array.length_toList]; omega
      obtain ⟨x, hx⟩ := List.length_eq_one_iff.mp hlen1
      have hx1 : x = 1 := by
        have hr := ha 1 (by omega) (by omega)
        unfold RuleAt at hr
        simp at hr
        rw [hx] at hr
        simpa [valAt] using hr
      rw [hx, hx1]
      exact isHistory_two
    · next h2 =>
      split at hs
      · -- death guard fired: contradicts `step a = some v`
        exact absurd hs (by simp)
      · -- main branch: a.size ≥ 2, death guard false
        next hguard =>
        rw [not_or] at hguard
        obtain ⟨g1, g2⟩ := hguard
        have hsz : 2 ≤ a.size := by omega
        -- bridge the `!`-reads to `valAt` on the list
        rw [show a.size - 2 = a.size - 1 - 1 from by omega] at g2 hs
        rw [getBang_eq_valAt a a.size] at g1 hs
        rw [getBang_eq_valAt a (a.size - 1)] at g2 hs
        rw [getBang_eq_valAt a (a.size + 1 - valAt a.toList a.size)] at hs
        rw [getBang_eq_valAt a (a.size + 1 - valAt a.toList (a.size - 1))] at hs
        -- move to the list world
        rw [← Array.length_toList (xs := a)] at g1 g2 hs hsz
        obtain rfl := Option.some.inj hs
        have hd1 : valAt a.toList a.toList.length ≤ a.toList.length := by omega
        have hd2 : valAt a.toList (a.toList.length - 1) ≤ a.toList.length := by omega
        have hext := isHistory_extend ha hsz hd1 hd2
        unfold nextVal at hext
        exact hext

/-- **Engine step completeness.**  If some longer spec-history exists, `step`
cannot report death. -/
theorem step_isSome_of_longer {a : Array Nat} (ha : IsHistory a.toList)
    {l : List Nat} (hl : IsHistory l) (hlt : a.size < l.length) :
    (step a).isSome := by
  simp only [step]
  split
  next h1 => simp
  next h1 =>
    split
    next h2 => simp
    next h2 =>
      split
      · -- death guard: contradicts the rule of `l` at position a.size + 1
        next hguard =>
        exfalso
        have hsz : 2 ≤ a.size := by omega
        rw [show a.size - 2 = a.size - 1 - 1 from by omega,
            getBang_eq_valAt a a.size, getBang_eq_valAt a (a.size - 1)] at hguard
        have e1 : valAt a.toList a.size = valAt l a.size :=
          deterministic _ l ha hl a.size (by omega)
            (by rw [Array.length_toList]; exact Nat.le_refl _) (by omega)
        have e2 : valAt a.toList (a.size - 1) = valAt l (a.size - 1) :=
          deterministic _ l ha hl (a.size - 1) (by omega)
            (by rw [Array.length_toList]; omega) (by omega)
        rw [e1, e2] at hguard
        have hr := (ruleAt_of_ge_three (by omega)).mp (hl (a.size + 1) (by omega) (by omega))
        obtain ⟨hb1, hb2, -⟩ := hr
        rw [show a.size + 1 - 1 = a.size from by omega] at hb1
        rw [show a.size + 1 - 2 = a.size - 1 from by omega] at hb2
        rcases hguard with g | g <;> omega
      · simp

/-- **Engine soundness**, `buildAux` level. -/
theorem buildAux_sound : ∀ (fuel target : Nat) (a out : Array Nat),
    IsHistory a.toList → buildAux fuel target a = some out →
    IsHistory out.toList ∧ a.size ≤ out.size ∧
      min target (a.size + fuel) ≤ out.size ∧ out.size ≤ max a.size target := by
  intro fuel
  induction fuel with
  | zero =>
    intro t a out ha hb
    simp only [buildAux] at hb
    obtain rfl := Option.some.inj hb
    exact ⟨ha, Nat.le_refl _, by omega, by omega⟩
  | succ fuel ih =>
    intro t a out ha hb
    simp only [buildAux] at hb
    split at hb
    · -- a.size ≥ target: done
      next hge =>
      obtain rfl := Option.some.inj hb
      exact ⟨ha, Nat.le_refl _, by omega, by omega⟩
    · -- take a step
      next hlt =>
      split at hb
      · exact absurd hb (by simp)
      · next v hstep =>
        have hpush : IsHistory (a.push v).toList := by
          rw [Array.toList_push]
          exact step_sound ha hstep
        obtain ⟨h1, h2, h3, h4⟩ := ih t (a.push v) out hpush hb
        rw [Array.size_push] at h2 h3 h4
        exact ⟨h1, by omega, by omega, by omega⟩

/-- **Engine completeness**, `buildAux` level: with enough fuel, and a
spec-history reaching the target, the engine cannot fail. -/
theorem buildAux_isSome_of_history : ∀ (fuel target : Nat) (a : Array Nat),
    IsHistory a.toList → ∀ {l : List Nat}, IsHistory l → target ≤ l.length →
    target ≤ a.size + fuel → (buildAux fuel target a).isSome := by
  intro fuel
  induction fuel with
  | zero =>
    intro t a _ l _ _ _
    simp [buildAux]
  | succ fuel ih =>
    intro t a ha l hl htl hfuel
    simp only [buildAux]
    split
    · simp
    · next hlt =>
      have hsome : (step a).isSome :=
        step_isSome_of_longer ha hl (by omega)
      obtain ⟨v, hv⟩ := Option.isSome_iff_exists.mp hsome
      rw [hv]
      have hpush : IsHistory (a.push v).toList := by
        rw [Array.toList_push]
        exact step_sound ha hv
      exact ih t (a.push v) hpush hl htl (by rw [Array.size_push]; omega)

/-- **Engine soundness, top level**: a successful `build N` returns a genuine
spec-history of length exactly `N`. -/
theorem build_sound {N : Nat} {out : Array Nat} (hb : build N = some out) :
    IsHistory out.toList ∧ out.toList.length = N := by
  have h0 : IsHistory (#[] : Array Nat).toList := by
    rw [Array.toList_empty]; exact isHistory_nil
  obtain ⟨h1, h2, h3, h4⟩ := buildAux_sound N N #[] out h0 hb
  have hsz0 : (#[] : Array Nat).size = 0 := rfl
  rw [hsz0] at h3 h4
  refine ⟨h1, ?_⟩
  rw [Array.length_toList]
  omega

/-- **Engine completeness, top level**: if a spec-history of length ≥ N
exists, `build N` succeeds. -/
theorem build_isSome_of_history {l : List Nat} (hl : IsHistory l) {N : Nat}
    (hN : N ≤ l.length) : (build N).isSome := by
  have h0 : IsHistory (#[] : Array Nat).toList := by
    rw [Array.toList_empty]; exact isHistory_nil
  have hsz0 : (#[] : Array Nat).size = 0 := rfl
  exact buildAux_isSome_of_history N N #[] h0 hl hN (by rw [hsz0]; omega)

/-- **The equivalence**: the engine's survival flag at `N` is *exactly*
spec-level existence of a history of length `N`.  A `native_decide` of the
left side is therefore a certificate for the specified sequence itself. -/
theorem aliveUpTo_iff_history (N : Nat) :
    aliveUpTo N = true ↔ ∃ a : List Nat, IsHistory a ∧ a.length = N := by
  constructor
  · intro h
    unfold aliveUpTo at h
    obtain ⟨out, hout⟩ := Option.isSome_iff_exists.mp h
    obtain ⟨hh, hlen⟩ := build_sound hout
    exact ⟨out.toList, hh, hlen⟩
  · intro ⟨l, hl, hlen⟩
    unfold aliveUpTo
    exact build_isSome_of_history hl (by omega)

/-- **Engine value faithfulness**: `Qeng N i` equals the value of *every*
spec-history that reaches `N`. -/
theorem Qeng_eq_valAt {N i : Nat} (h1 : 1 ≤ i) (hi : i ≤ N)
    {l : List Nat} (hl : IsHistory l) (hN : N ≤ l.length) :
    Qeng N i = valAt l i := by
  have hs := build_isSome_of_history hl hN
  obtain ⟨out, hout⟩ := Option.isSome_iff_exists.mp hs
  obtain ⟨hh, hlen⟩ := build_sound hout
  have hsz : out.size = N := by
    rw [← Array.length_toList (xs := out)]; exact hlen
  unfold Qeng
  rw [hout]
  show (if 1 ≤ i ∧ i ≤ out.size then out[i - 1]! else 0) = valAt l i
  rw [if_pos ⟨h1, by omega⟩, getBang_eq_valAt]
  exact deterministic _ l hh hl i h1 (by rw [Array.length_toList]; omega) (by omega)

end QSequence
