import Statements
import Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip
import Formalism.GammaFactorNonvanishing.RhOfRight
open Lean in
#eval show MetaM Unit from do
  let env ← getEnv
  for n in [``RiemannHypothesis, ``riemannZeta, ``DirichletCharacter.LFunction, ``RiemannZetaZerosOnLine, ``Claim.HalfPlane, ``Claim.Strip, ``Claim.Zeta, ``UpperTheory.EveryCharacter] do
    let m := (env.getModuleIdxFor? n).map (env.header.moduleNames[·.toNat]!)
    logInfo m!"{n} is declared in module {m}"
  -- every declaration contributed by the three repo modules, with its axioms
  for modName in [`Statements, `Development.AutomorphicArithmetic.CharacterBoxes.HalfPlane, `Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip, `Formalism.GammaFactorNonvanishing.RhOfRight] do
    let some idx := env.getModuleIdx? modName | logInfo m!"module {modName} not found"; continue
    let names := env.header.moduleData[idx.toNat]!.constNames.filter fun n => !n.isInternal
    logInfo m!"module {modName}: {names.size} non-internal constants: {names}"
#print axioms Formalism.VW.rh_of_right
#check @Formalism.VW.rh_of_right
#check @Claim.strip
#check @Claim.zeta
#check @Claim.zeta_iff
#print UpperTheory.EveryCharacter
#print Claim.HalfPlane
#print Claim.Strip
#print Claim.Zeta
