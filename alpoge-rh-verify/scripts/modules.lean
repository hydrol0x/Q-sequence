import Mathlib
open Lean in
run_cmd do
  let env ← getEnv
  let h ← IO.FS.Handle.mk "/home/judge/dep/mathlib-modules.tsv" .write
  let mods := env.header.moduleNames
  let mut n : Nat := 0
  for (c, _) in env.constants.toList do
    let m := match env.getModuleIdxFor? c with
      | some i => toString mods[i.toNat]!
      | none => "?"
    h.putStrLn s!"{c.toString (escape := false)}\t{m}"
    n := n + 1
  logInfo m!"wrote {n} constants with modules"
