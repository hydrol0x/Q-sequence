#!/bin/bash
. ~/.elan/env; cd /work/ext/lean; export LEAN_NUM_THREADS=1
M=$(cd .lake/build/lib/lean && find Formalism -name '*.olean' | shuf -n 12 --random-source=<(yes) | sed 's/\.olean$//; s#/#.#g' | tr '\n' ' ')
echo "modules: $M"
/usr/bin/time -f "single-module wall=%es rss=%MKB rc=%x" lake env leanchecker -v $(echo $M | cut -d' ' -f1)
/usr/bin/time -f "12-module batch wall=%es rss=%MKB rc=%x" lake env leanchecker -v $M
/usr/bin/time -f "Statements? wall=%es rss=%MKB rc=%x" lake env leanchecker -v Statements
