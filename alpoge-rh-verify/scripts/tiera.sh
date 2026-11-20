#!/bin/bash
. ~/.elan/env; cd /work/ext/lean
for m in Statements Development/AutomorphicArithmetic/CharacterBoxes/ClaimStrip Development/AutomorphicArithmetic/CharacterBoxes/HalfPlane Formalism/GammaFactorNonvanishing/RhOfRight; do ls -la .lake/build/lib/lean/$m.olean 2>&1 | cut -c1-200; done
echo "=== lake env lean TierA.lean"; /usr/bin/time -f "TierA wall=%es rss=%MKB exit=%x" lake env lean /work/scripts/TierA.lean
echo "=== lake env lean TierA2.lean"; /usr/bin/time -f "TierA2 wall=%es rss=%MKB exit=%x" lake env lean /work/scripts/TierA2.lean
