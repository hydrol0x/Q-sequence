# Analyse the declaration dependency graph produced by depgraph.
# Usage: python3 -I analyze.py <graphdir> <depdir> <outdir>
import sys, os, re, collections
import numpy as np
G, D, O = sys.argv[1:4]; os.makedirs(O, exist_ok=True)
rep = open(os.path.join(O, 'report.txt'), 'w')
def P(*a):
    s = ' '.join(str(x) for x in a); print(s); rep.write(s + '\n'); rep.flush()
ip = np.fromfile(os.path.join(G, 'indptr.bin'), dtype=np.uint64).astype(np.int64)
ix = np.fromfile(os.path.join(G, 'indices.bin'), dtype=np.uint32)
kind = []; dag = []; names = []
for l in open(os.path.join(G, 'nodes.tsv'), encoding='utf-8', errors='replace'):
    r = l.rstrip('\n').split('\t'); kind.append(r[1]); dag.append(int(r[2])); names.append(r[3].split('|'))
N = len(kind); dag = np.array(dag, dtype=np.int64)
byname = {}
for i, ns in enumerate(names):
    for n in ns: byname[n] = i
P('== graph ==')
P('declaration nodes', N, ' constant names', len(byname), ' edges', len(ix))
kc = collections.Counter(kind); P('nodes by kind (t=theorem d=def o=opaque A=axiom q=quot I=inductive block):', dict(kc))
P('axioms in the export:', sorted(n for i in range(N) if kind[i] == 'A' for n in names[i]))
# topological property
src_of = np.repeat(np.arange(N, dtype=np.int64), np.diff(ip))
P('edges pointing to a later declaration (0 means file order is a topological order):', int((ix.astype(np.int64) >= src_of).sum()))
# Mathlib / core classification
mod_of = {}
mp = os.path.join(D, 'mathlib-modules.tsv')
if os.path.exists(mp):
    for l in open(mp, encoding='utf-8', errors='replace'):
        a = l.rstrip('\n').split('\t')
        if len(a) == 2: mod_of[a[0]] = a[1]
else:
    for l in open(os.path.join(D, 'mathlib-names.txt'), encoding='utf-8', errors='replace'): mod_of[l.rstrip('\n')] = '?'
is_lib = np.zeros(N, dtype=bool); lib_mod = [None] * N
for i, ns in enumerate(names):
    for n in ns:
        if n in mod_of: is_lib[i] = True; lib_mod[i] = mod_of[n]; break
P('nodes that are constants of `import Mathlib` (Mathlib, Batteries, Aesop, core, ...):', int(is_lib.sum()), ' project nodes:', int((~is_lib).sum()))
P('project nodes by kind:', dict(collections.Counter(k for k, b in zip(kind, is_lib) if not b)))
P('sum of expression-DAG sizes: library', int(dag[is_lib].sum()), ' project', int(dag[~is_lib].sum()))
# reachability from targets
targets = ['riemannHypothesis', 'riemannZeta_eq_zero_re', 'LFunction_ne_zero_of_half_lt_re', 'LFunction_eq_zero_re', 'LFunction_eq_zero_re_of_isPrimitive']
def closure(roots):
    seen = np.zeros(N, dtype=bool); st = list(roots)
    for r in roots: seen[r] = True
    while st:
        u = st.pop()
        for v in ix[ip[u]:ip[u + 1]]:
            if not seen[v]: seen[v] = True; st.append(int(v))
    return seen
P('\n== closure of the targets ==')
tids = [byname[t] for t in targets if t in byname]
P('targets found:', [t for t in targets if t in byname], ' missing:', [t for t in targets if t not in byname])
if tids:
    allc = closure(tids); P('nodes reachable from the five targets:', int(allc.sum()), 'of', N, ' (project:', int((allc & ~is_lib).sum()), ' library:', int((allc & is_lib).sum()), ')')
    notr = [names[i][-1] for i in range(N) if not allc[i]]; P('nodes not reachable from the targets:', len(notr), notr[:40])
    for t in targets:
        if t in byname:
            c = closure([byname[t]]); P(f'  {t}: closure {int(c.sum())} nodes, project {int((c & ~is_lib).sum())}; direct deps (project):', [names[j][-1] for j in ix[ip[byname[t]]:ip[byname[t] + 1]] if not is_lib[j]])
# depth (longest chain), in file order
depth = np.zeros(N, dtype=np.int32); pdepth = np.zeros(N, dtype=np.int32)
for i in range(N):
    d = ix[ip[i]:ip[i + 1]]
    if len(d):
        depth[i] = depth[d].max() + 1
        pdepth[i] = pdepth[d].max() + (0 if is_lib[i] else 1)
    else: pdepth[i] = 0 if is_lib[i] else 1
P('longest dependency chain: all nodes', int(depth.max()), ' counting project nodes only', int(pdepth.max()))
if tids:
    for t in targets:
        if t in byname: P(f'  {t}: chain length {int(depth[byname[t]])}, project-only {int(pdepth[byname[t]])}')
    # BFS distance from riemannHypothesis
    r = byname.get('riemannHypothesis', tids[0]); dist = np.full(N, -1, dtype=np.int32); dist[r] = 0; fr = [r]; lvl = 0; hist = []
    while fr:
        nx = []
        for u in fr:
            for v in ix[ip[u]:ip[u + 1]]:
                if dist[v] < 0: dist[v] = lvl + 1; nx.append(int(v))
        lvl += 1; fr = nx; hist.append((lvl, len(nx), sum(1 for v in nx if not is_lib[v])))
    P('shortest-path distance from riemannHypothesis (level, nodes, project nodes):', hist[:60])
# in-degree
indeg = np.bincount(ix, minlength=N)
order = np.argsort(-indeg)
P('\n== most referenced project declarations (direct references) ==')
c = 0
for i in order:
    if not is_lib[i]:
        P(f'  {int(indeg[i]):8d}  {names[i][-1]}'); c += 1
        if c >= 40: break
P('\n== largest project declarations by expression-DAG size ==')
c = 0
for i in np.argsort(-dag):
    if not is_lib[i]:
        P(f'  {int(dag[i]):10d}  {kind[i]}  {names[i][-1]}'); c += 1
        if c >= 30: break
# library usage by module area
P('\n== library constants in the closure, by module area ==')
def area(m, k):
    if m is None or m == '?': return '?'
    return '.'.join(m.split('.')[:k])
for k in (1, 2):
    cnt = collections.Counter(area(lib_mod[i], k) for i in range(N) if is_lib[i])
    P(f' depth {k}:', ', '.join(f'{a} {n}' for a, n in cnt.most_common(60)))
cnt3 = collections.Counter(area(lib_mod[i], 3) for i in range(N) if is_lib[i] and lib_mod[i] and lib_mod[i].startswith('Mathlib.'))
P(' Mathlib depth 3 (top 80):', ', '.join(f'{a} {n}' for a, n in cnt3.most_common(80)))
libmods_used = set(lib_mod[i] for i in range(N) if is_lib[i]); allmods = set(mod_of.values())
P(' library modules with at least one constant in the closure:', len(libmods_used), 'of', len(allmods), ' (Mathlib.* only:', sum(1 for m in libmods_used if m and m.startswith('Mathlib.')), 'of', sum(1 for m in allmods if m.startswith('Mathlib.')), ')')
with open(os.path.join(O, 'library-modules-used.tsv'), 'w') as f:
    cm = collections.Counter(lib_mod[i] for i in range(N) if is_lib[i])
    for m, n in sorted(cm.items(), key=lambda x: -x[1]): f.write(f'{m}\t{n}\n')
# attribution of project nodes to source files
P('\n== attribution of project declarations to source files ==')
lines_of = {}
for l in open(os.path.join(D, 'src-lines.tsv'), encoding='utf-8'):
    a = l.rstrip('\n').split('\t'); lines_of[a[0]] = int(a[1])
sidx = collections.defaultdict(list); decls_in_file = collections.Counter(); nsrc = 0
for l in open(os.path.join(D, 'src-index.tsv'), encoding='utf-8', errors='replace'):
    a = l.rstrip('\n').split('\t')
    if len(a) != 4: continue
    sidx[a[0]].append(a[2]); decls_in_file[a[2]] += 1; nsrc += 1
P('source files', len(lines_of), ' source lines', sum(lines_of.values()), ' declarations indexed in source', nsrc, ' distinct names', len(sidx))
file_of = [None] * N; how = collections.Counter()
def attribute(n):
    if n.startswith('_private.'):
        j = n.find('.0.')
        if j > 0:
            f = n[9:j].replace('.', '/') + '.lean'
            if f in lines_of: return f, 'private-module'
            return None, 'private-unknown-module'
    if n in sidx:
        fs = sidx[n]; return (fs[0], 'exact') if len(set(fs)) == 1 else (fs[0], 'exact-ambiguous')
    parts = n.split('.')
    for k in range(len(parts) - 1, 0, -1):
        p = '.'.join(parts[:k])
        if p in sidx:
            fs = sidx[p]; return (fs[0], 'prefix') if len(set(fs)) == 1 else (fs[0], 'prefix-ambiguous')
    return None, 'none'
unattr = []
for i in range(N):
    if is_lib[i]: continue
    best = None; bh = 'none'
    for n in reversed(names[i]):
        f, h = attribute(n)
        if f is not None: best, bh = f, h; break
        bh = h
    file_of[i] = best; how[bh] += 1
    if best is None: unattr.append(names[i][-1])
P('attribution method counts:', dict(how))
P('unattributed project nodes:', len(unattr), ' examples:', unattr[:60])
uc = collections.Counter('.'.join(n.split('.')[:2]) for n in unattr); P('unattributed by leading name components:', uc.most_common(40))
used_names = set(n for i in range(N) if not is_lib[i] for n in names[i])
src_used = sum(1 for n in sidx if n in used_names)
P('source-indexed names present in the export (exact name match):', src_used, 'of', len(sidx), f'({100.0 * src_used / max(1, len(sidx)):.1f}%)')
used_nodes_in_file = collections.Counter(f for f in file_of if f); used_src_in_file = collections.Counter()
for n, fs in sidx.items():
    if n in used_names:
        for f in set(fs): used_src_in_file[f] += 1
used_files = set(used_nodes_in_file) | set(used_src_in_file)
TL = sum(lines_of.values())
P('source files with at least one declaration in the closure:', len(used_files), 'of', len(lines_of), f'({100.0 * len(used_files) / max(1, len(lines_of)):.1f}%)', ' lines in those files:', sum(lines_of[f] for f in used_files), 'of', TL, f'({100.0 * sum(lines_of[f] for f in used_files) / max(1, TL):.1f}%)')
with open(os.path.join(O, 'file-usage.tsv'), 'w') as f:
    f.write('file\tlines\tdecls_indexed\tdecls_indexed_in_closure\texport_nodes_attributed\n')
    for p in sorted(lines_of): f.write(f'{p}\t{lines_of[p]}\t{decls_in_file[p]}\t{used_src_in_file[p]}\t{used_nodes_in_file[p]}\n')
for depth_k in (1, 2, 3):
    agg = collections.defaultdict(lambda: [0, 0, 0, 0, 0, 0])  # files, used files, lines, used lines, decls, used decls
    for p, ln in lines_of.items():
        parts = p.split('/'); key = '/'.join(parts[:depth_k]) if len(parts) > depth_k else '/'.join(parts[:-1]) or '(root)'
        a = agg[key]; a[0] += 1; a[2] += ln; a[4] += decls_in_file[p]; a[5] += used_src_in_file[p]
        if p in used_files: a[1] += 1; a[3] += ln
    rows = sorted(agg.items(), key=lambda x: -x[1][2])
    with open(os.path.join(O, f'dir-usage-depth{depth_k}.tsv'), 'w') as f:
        f.write('dir\tfiles\tfiles_used\tlines\tlines_in_used_files\tdecls\tdecls_in_closure\n')
        for k, a in rows: f.write(k + '\t' + '\t'.join(map(str, a)) + '\n')
    P(f'\n-- by directory, depth {depth_k} (dir: files used/total, lines in used files/total, declarations in closure/indexed) --')
    for k, a in rows[:70 if depth_k > 1 else 100]:
        P(f'  {k}: files {a[1]}/{a[0]} ({100.0 * a[1] / max(1, a[0]):.0f}%), lines {a[3]}/{a[2]} ({100.0 * a[3] / max(1, a[2]):.0f}%), decls {a[5]}/{a[4]} ({100.0 * a[5] / max(1, a[4]):.0f}%)')
    if depth_k == 3:
        P('\n-- depth-3 directories with the most lines in files that have NO declaration in the closure --')
        for k, a in sorted(agg.items(), key=lambda x: -(x[1][2] - x[1][3]))[:50]:
            P(f'  {k}: unused lines {a[2] - a[3]} of {a[2]}, unused files {a[0] - a[1]} of {a[0]}')
        P('\n-- depth-3 directories entirely outside the closure (no file used), by lines --')
        for k, a in sorted(((k, a) for k, a in agg.items() if a[1] == 0), key=lambda x: -x[1][2])[:50]:
            P(f'  {k}: {a[0]} files, {a[2]} lines')
# named items
P('\n== named topics: project constants in the closure vs names indexed in source (case-insensitive substring) ==')
topics = ['Published', 'GeneralHyp', 'OpenLiteratureStatements', '_of_literature', 'ThetaLift', 'Theta', 'ChainInt', 'core_gm', 'Principalization', 'Nadel', 'Kawamata', 'Toroidal', 'Prismatic', 'Dieudonne', 'Messing', 'recT', 'galoisLocalGlobal', 'VWin', 'Stepanov', 'WeilBound', 'Hironaka', 'Resolution', 'Caraiani', 'Langlands', 'Shimura', 'Deligne', 'Fontaine', 'Hodge', 'Perfectoid', 'Etale', 'Crystalline', 'Jacquet', 'Howe', 'Rallis', 'SiegelWeil', 'Arthur', 'TraceFormula', 'Unitary', 'Eisenstein', 'Whittaker', 'Mirabolic', 'HarishChandra', 'AbelianVariet', 'Galois', 'Frobenius', 'Purity', 'Ramanujan', 'Cohomology', 'Scheme', 'Stack', 'Adic', 'Automorphic', 'Cusp', 'Hecke', 'Satake', 'BaseChange', 'Endoscop']
un_l = [(n, n.lower()) for n in used_names]; sn_l = [n.lower() for n in sidx]
for t in topics:
    tl = t.lower(); a = sum(1 for _, n in un_l if tl in n); b = sum(1 for n in sn_l if tl in n)
    P(f'  {t}: in closure {a}, in source index {b}')
pub_src = sorted(n for n in sidx if n.startswith('GlobalTheory.Published.')); pub_used = [n for n in pub_src if n in used_names]
P('\nGlobalTheory.Published.* names in source:', len(pub_src), ' in closure:', len(pub_used))
with open(os.path.join(O, 'published-used.txt'), 'w') as f: f.write('\n'.join(pub_used) + '\n')
with open(os.path.join(O, 'published-unused.txt'), 'w') as f: f.write('\n'.join(n for n in pub_src if n not in used_names) + '\n')
for n in ['GlobalTheory.Fc.S0.GeneralHyps', 'GlobalTheory.Fc.S0.GeneralHypU', 'GlobalTheory.Fc.S0.GeneralHypV', 'UpperTheory.LiteratureTheorems.OpenLiteratureStatements', 'UpperTheory.Zero.LLC.recTExists', 'UpperTheory.Zero.LLC.RecTExists', 'UpperTheory.Gal.Int.galoisLocalGlobalStrong_recParameter', 'UpperTheory.One.M.Row', 'UpperTheory.EveryCharacter']:
    if n in byname:
        i = byname[n]; P(f'  {n}: IN closure, kind {kind[i]}, dag {int(dag[i])}, referenced directly by {int(indeg[i])}, direct deps {int(ip[i + 1] - ip[i])}, file {file_of[i]}')
    else: P(f'  {n}: NOT in closure')
# top of the proof
if tids:
    P('\n== top of the dependency graph under riemannHypothesis (project nodes; name, closure size) ==')
    r = byname.get('riemannHypothesis', tids[0]); seenp = set()
    def show(u, ind, maxd):
        ch = [int(v) for v in ix[ip[u]:ip[u + 1]] if not is_lib[v]]
        for v in ch[:25]:
            tag = '' if v not in seenp else ' (shown above)'
            P('  ' * ind + f'{names[v][-1]}  [{kind[v]}, deps {int(ip[v + 1] - ip[v])}, file {file_of[v]}]' + tag)
            if v not in seenp and ind < maxd: seenp.add(v); show(v, ind + 1, maxd)
        if len(ch) > 25: P('  ' * ind + f'... and {len(ch) - 25} more')
    show(r, 1, 5)
np.save(os.path.join(O, 'is_lib.npy'), is_lib)
with open(os.path.join(O, 'node-files.tsv'), 'w') as f:
    for i in range(N):
        if not is_lib[i]: f.write(f'{names[i][-1]}\t{kind[i]}\t{int(dag[i])}\t{int(indeg[i])}\t{file_of[i]}\n')
P('\ndone')
