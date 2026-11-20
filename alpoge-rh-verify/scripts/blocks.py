# Local follow-up on the dependency graph: (1) which source directories serve which block of the argument,
# (2) how the "Published" literature statements are stated and discharged.
# Usage: python3 -I blocks.py <dir with full/, full-out/, stmt/> <outdir>
import sys, os, collections
import numpy as np
D, O = sys.argv[1:3]
names = []; kind = []; dag = []
for l in open(os.path.join(D, 'full/nodes.tsv'), encoding='utf-8', errors='replace'):
    r = l.rstrip('\n').split('\t'); kind.append(r[1]); dag.append(int(r[2])); names.append(r[3].split('|')[-1])
N = len(names); byname = {n: i for i, n in enumerate(names)}
allnames = {}
for i, l in enumerate(open(os.path.join(D, 'full/nodes.tsv'), encoding='utf-8', errors='replace')):
    for n in l.rstrip('\n').split('\t')[3].split('|'): allnames[n] = i
is_lib = np.load(os.path.join(D, 'full-out/is_lib.npy')); idom = np.fromfile(os.path.join(D, 'full-out/idom.bin'), dtype=np.int32).tolist()
file_of = [None] * N
for l in open(os.path.join(D, 'full-out/node-files.tsv'), encoding='utf-8', errors='replace'):
    a = l.rstrip('\n').split('\t')
    if a[4] != 'None': file_of[byname[a[0]]] = a[4]
out = open(os.path.join(O, 'blocks-report.txt'), 'w')
def P(*a):
    s = ' '.join(str(x) for x in a); print(s); out.write(s + '\n')
cuts = [('A1 theta/Siegel-Weil core', 'UpperTheory.Lit.every_character_of_theta_integrals_local_matching'),
        ('A2 volume/height estimates', 'SelfIntersectionVolumeEstimates.topCovolSlim2_use_alt_alt'),
        ('A  rest of every_character_of_literature_of_vWin', 'UpperTheory.LiteratureTheorems.every_character_of_literature_of_vWin'),
        ('B  vwin_of_row (automorphy window)', 'UpperTheory.One.vwin_of_row'),
        ('C  rest of everyCharacter_of_row', 'UpperTheory.FinalTheorems.everyCharacter_of_row'),
        ('D  Galois representations (galoisLocalGlobalStrong_recParameter)', 'UpperTheory.Gal.Int.galoisLocalGlobalStrong_recParameter'),
        ('E  shared: directly under everyCharacter', 'UpperTheory.FinalTheorems.everyCharacter')]
cut_id = {byname[n]: lab for lab, n in cuts}
block = [None] * (N + 1); block[N] = 'top'
for v in range(N - 1, -1, -1):
    if idom[v] < 0: continue
    block[v] = cut_id.get(v) or block[idom[v]]
    if block[v] == 'top' and v in cut_id: block[v] = cut_id[v]
cnt = collections.Counter(block[v] for v in range(N) if not is_lib[v]); tot = sum(cnt.values())
P('== blocks of the dominator tree (project declarations owned) ==')
for lab, n in cuts: P(f'  {lab}: {cnt[lab]} ({100.0 * cnt[lab] / tot:.1f}%)')
P('  top (the five theorems and their glue):', cnt['top'])
tab = collections.defaultdict(collections.Counter)
for v in range(N):
    if is_lib[v] or file_of[v] is None: continue
    parts = file_of[v].split('/'); key = '/'.join(parts[:2]) if len(parts) > 2 else parts[0]
    tab[key][block[v]] += 1
labs = [l for l, _ in cuts]; short = ['A1', 'A2', 'A', 'B', 'C', 'D', 'E']
P('\n== where each source directory\'s closure declarations sit (percent of the directory\'s declarations per block) ==')
P('directory\tdecls\t' + '\t'.join(short))
with open(os.path.join(O, 'dir-by-block.tsv'), 'w') as f:
    f.write('directory\tdecls_in_closure\t' + '\t'.join(labs) + '\n')
    for k, c in sorted(tab.items(), key=lambda x: -sum(x[1].values())):
        t = sum(c.values()); f.write(k + f'\t{t}\t' + '\t'.join(str(c[l]) for l in labs) + '\n')
        if t >= 3000: P(f'{k}\t{t}\t' + '\t'.join(f'{100.0 * c[l] / t:.0f}' for l in labs))
# statement graph
ip = np.fromfile(os.path.join(D, 'stmt/indptr.bin'), dtype=np.uint64).astype(np.int64); ix = np.fromfile(os.path.join(D, 'stmt/indices.bin'), dtype=np.uint32)
def closure(r):
    seen = np.zeros(N, dtype=bool); seen[r] = True; st = [r]
    while st:
        u = st.pop(); nb = ix[ip[u]:ip[u + 1]]; new = nb[~seen[nb]]
        if len(new): seen[new] = True; st.extend(new.tolist())
    return seen
pub = sorted(set(i for n, i in allnames.items() if n.startswith('GlobalTheory.Published.') and n.count('.') == 2))
P('\n== literature statements (constants GlobalTheory.Published.X in the closure) ==')
P('top-level GlobalTheory.Published.* constants in the closure:', len(pub), ' by kind:', dict(collections.Counter(kind[i] for i in pub)))
lit = byname['UpperTheory.LiteratureTheorems.OpenLiteratureStatements']
provers = collections.defaultdict(list)
pubset = set(pub)
for v in range(N):
    if kind[v] != 't' or is_lib[v]: continue
    d = ix[ip[v]:ip[v + 1]]
    if len(d) <= 2:
        ds = set(int(x) for x in d); p = ds & pubset
        if len(p) == 1 and ds - p <= {lit}: provers[next(iter(p))].append(v)
P('Published constants that are the entire statement of some theorem in the closure (possibly with the OpenLiteratureStatements argument):', len(provers))
P('  of these, proved by a theorem that takes OpenLiteratureStatements as hypothesis only:', sum(1 for p, vs in provers.items() if all(lit in set(int(x) for x in ix[ip[v]:ip[v + 1]]) for v in vs)))
rows = []
for p in pub:
    c = closure(p); pj = int((c & ~is_lib).sum()) - 1; lb = int((c & is_lib).sum())
    rows.append((pj, lb, names[p], kind[p], len(provers.get(p, []))))
rows.sort()
with open(os.path.join(O, 'published-statements.tsv'), 'w') as f:
    f.write('statement\tkind\tproject_decls_in_statement\tlibrary_decls_in_statement\ttheorems_stating_exactly_this\n')
    for pj, lb, n, k, np_ in rows: f.write(f'{n}\t{k}\t{pj}\t{lb}\t{np_}\n')
h = collections.Counter('0' if r[0] == 0 else '1-9' if r[0] < 10 else '10-99' if r[0] < 100 else '100-999' if r[0] < 1000 else '1000+' for r in rows)
P('number of project declarations that a Published statement depends on (its own definitional content):', dict(h))
P('Published statements written purely in Mathlib/core terms (no project definition involved):', sum(1 for r in rows if r[0] == 0))
for r in rows:
    if r[0] == 0: P(f'   {r[2]}  [{r[3]}; library decls {r[1]}; theorems stating exactly this: {r[4]}]')
P('largest statements by project definitions involved:')
for r in rows[-15:]: P(f'   {r[2]}: {r[0]} project decls')
for n in ['UpperTheory.EveryCharacter', 'UpperTheory.LiteratureTheorems.OpenLiteratureStatements', 'UpperTheory.One.M.Row', 'UpperTheory.Zero.LLC.RecTExists']:
    c = closure(byname[n]); P(f'{n}: statement involves {int((c & ~is_lib).sum())} project declarations, {int((c & is_lib).sum())} library declarations')
