# Dominator-tree report. Usage: python3 -I dom.py prep|report <graphdir> <outdir>
import sys, os, collections, subprocess
import numpy as np
mode, G, O = sys.argv[1:4]
kind = []; dag = []; names = []
for l in open(os.path.join(G, 'nodes.tsv'), encoding='utf-8', errors='replace'):
    r = l.rstrip('\n').split('\t'); kind.append(r[1]); dag.append(int(r[2])); names.append(r[3].split('|')[-1])
N = len(kind); byname = {n: i for i, n in enumerate(names)}
is_lib = np.load(os.path.join(O, 'is_lib.npy'))
targets = ['riemannHypothesis', 'riemannZeta_eq_zero_re', 'LFunction_ne_zero_of_half_lt_re', 'LFunction_eq_zero_re', 'LFunction_eq_zero_re_of_isPrimitive']
if mode == 'prep':
    open(os.path.join(O, 'targets.ids'), 'w').write('\n'.join(str(byname[t]) for t in targets) + '\n'); sys.exit(0)
file_of = {}
for l in open(os.path.join(O, 'node-files.tsv'), encoding='utf-8', errors='replace'):
    a = l.rstrip('\n').split('\t'); file_of[a[0]] = a[4]
idom = np.fromfile(os.path.join(O, 'idom.bin'), dtype=np.int32)
sub_all = np.ones(N + 1, dtype=np.int64); sub_pj = np.zeros(N + 1, dtype=np.int64); sub_pj[:N] = (~is_lib).astype(np.int64); sub_all[N] = 0
sub_dag = np.zeros(N + 1, dtype=np.int64); sub_dag[:N] = np.array(dag, dtype=np.int64) * (~is_lib)
il = idom.tolist(); sa = sub_all.tolist(); sp = sub_pj.tolist(); sd = sub_dag.tolist()
kids = collections.defaultdict(list); ddepth = [0] * (N + 1)
for v in range(N):
    d = il[v]
    if d < 0: sa[v] = 0; sp[v] = 0; sd[v] = 0; continue
    sa[d] += sa[v]; sp[d] += sp[v]; sd[d] += sd[v]; kids[d].append(v)
for v in range(N - 1, -1, -1):
    if il[v] >= 0: ddepth[v] = ddepth[il[v]] + 1
rep = open(os.path.join(O, 'dom-report.txt'), 'w')
def P(*a):
    s = ' '.join(str(x) for x in a); print(s); rep.write(s + '\n'); rep.flush()
P('== dominator tree of the dependency graph (root = the five theorems of Main.lean) ==')
P('A declaration D "dominates" E when every dependency path from the five theorems to E passes through D.')
P('"owns" below = number of project declarations dominated (used only through that declaration), itself included.')
P('reachable nodes', sa[N], ' project', sp[N], ' max dominator depth', max(ddepth))
hist = collections.Counter(ddepth[v] for v in range(N) if il[v] >= 0 and not is_lib[v]); P('project nodes by dominator depth (first 30):', sorted(hist.items())[:30])
def desc(v): return f'{names[v]}  [{kind[v]}; owns {sp[v]} project decls, {sd[v]} expr nodes; file {file_of.get(names[v])}]'
# main chain: follow the heaviest child while it owns > 50% of parent
P('\n-- heaviest path from the root (each line: the child owning the most) --')
v = N; lvl = 0
while kids.get(v):
    c = max(kids[v], key=lambda x: sp[x])
    if sp[c] < 200: break
    P(f'  depth {lvl + 1}: {desc(c)}  ({100.0 * sp[c] / max(1, sp[N]):.1f}% of all project decls; parent has {len(kids[v])} children)')
    v = c; lvl += 1
    if lvl > 60: break
P('\n-- tree, children owning at least 4000 project declarations (depth <= 12) --')
def show(v, ind):
    ch = sorted(kids.get(v, []), key=lambda x: -sp[x]); big = [c for c in ch if sp[c] >= 4000]
    small = len(ch) - len(big); rest = sum(sp[c] for c in ch if sp[c] < 4000)
    for c in big:
        P('  ' * ind + desc(c))
        if ind < 12: show(c, ind + 1)
    if ch and ind <= 12: P('  ' * ind + f'(+ {small} smaller children owning {rest} project decls in total)')
sys.setrecursionlimit(10000); show(N, 1)
P('\n-- the 150 declarations owning the most, with dominator depth --')
order = sorted((v for v in range(N) if il[v] >= 0 and not is_lib[v]), key=lambda x: -sp[x])
for v in order[:150]: P(f'  d{ddepth[v]:3d}  {desc(v)}')
P('\n-- owned size of every *_of_literature theorem and other named items --')
q = [v for v in range(N) if not is_lib[v] and (names[v].endswith('_of_literature') or names[v].endswith('_of_literature_of_vWin'))]
named = ['UpperTheory.FinalTheorems.everyCharacter', 'UpperTheory.FinalTheorems.everyCharacter_of_row', 'UpperTheory.LiteratureTheorems.every_character_of_literature_of_vWin', 'UpperTheory.Zero.LLC.recTExists', 'UpperTheory.Gal.Int.galoisLocalGlobalStrong_recParameter', 'UpperTheory.Gal.Int.galoisRepresentations_of_thetaLift', 'UpperTheory.One.vwin_of_row', 'Formalism.VW.rh_of_every', 'Formalism.VW.rh_of_right', 'UpperTheory.TP.K.tLiftK', 'rhOfAll', 'allChi', 'claimAll', 'critAll']
q2 = [byname[n] for n in named if n in byname] + order[:400] + q
seen = set(); ql = [x for x in q2 if not (x in seen or seen.add(x))]
open(os.path.join(O, 'closure.ids'), 'w').write('\n'.join(map(str, ql)) + '\n')
subprocess.run(['/home/judge/dep/domtree', 'closure', G, os.path.join(O, 'is_lib.npy'), os.path.join(O, 'closure.ids'), os.path.join(O, 'closure.tsv')], check=True)
clo = {}
for l in open(os.path.join(O, 'closure.tsv')):
    a = l.split(); clo[int(a[0])] = (int(a[1]), int(a[2]))
P('(closure = project declarations reachable from it; owns = those reachable only through it)')
for n in named:
    if n in byname:
        v = byname[n]; P(f'  {n}: closure {clo[v][1]} ({100.0 * clo[v][1] / sp[N]:.1f}%), owns {sp[v]}, dominator depth {ddepth[v]}, idom {names[il[v]] if il[v] < N else "ROOT"}')
P('\n-- *_of_literature theorems: closure, owns, idom --')
for v in sorted(q, key=lambda x: -clo[x][1]):
    P(f'  {names[v]}: closure {clo[v][1]}, owns {sp[v]}, idom {names[il[v]] if il[v] < N else "ROOT"}')
P('\n-- top 400 owners: closure vs owns --')
with open(os.path.join(O, 'owners.tsv'), 'w') as f:
    f.write('name\tkind\tdomdepth\towns_project_decls\towns_expr_nodes\tclosure_project_decls\tfile\tidom\n')
    for v in order[:400]: f.write(f'{names[v]}\t{kind[v]}\t{ddepth[v]}\t{sp[v]}\t{sd[v]}\t{clo[v][1]}\t{file_of.get(names[v])}\t{names[il[v]] if il[v] < N else "ROOT"}\n')
# by-directory ownership: for each depth-2 directory, how many of its attributed decls are owned by which of the top blocks: skipped
P('done')
