import Statements
import Development.AutomorphicArithmetic.CharacterBoxes.ClaimStrip
#print RiemannHypothesis
#print RiemannZetaZerosOnLine
#print DirichletLNonvanishingRightOfHalf
#print DirichletLZerosOnLine
#print PrimitiveDirichletLZerosOnLine
example : RiemannZetaZerosOnLine ↔ RiemannHypothesis := Iff.rfl
example : Claim.HalfPlane ↔ DirichletLNonvanishingRightOfHalf := Iff.rfl
example : Claim.Strip ↔ DirichletLZerosOnLine := Iff.rfl
#print axioms Claim.strip
#print axioms Claim.zeta
#print axioms Claim.zeta_iff
