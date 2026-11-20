import Mathlib
open Lean in
run_cmd do
  let env ← getEnv
  let h ← IO.FS.Handle.mk "/home/judge/dep/mathlib-names.txt" .write
  let mut n : Nat := 0
  for (c, _) in env.constants.toList do
    h.putStrLn (c.toString (escape := false))
    n := n + 1
  logInfo m!"wrote {n} constant names"
