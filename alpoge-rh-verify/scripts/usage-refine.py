# Refined count of source declarations that are in the dependency closure, matching private declarations by
# (module, name), and a breakdown of the files that contribute nothing.
# Usage: python3 -I usage-refine.py <dir with full-out/node-files.tsv, src-index.tsv, src-lines.tsv>
import sys, os, collections, statistics
D = sys.argv[1]
used_pairs = set(); used_names = set(); files_with_nodes = collections.Counter()
for l in open(os.path.join(D, 'full-out/node-files.tsv'), encoding='utf-8', errors='replace'):
    n, k, dag, indeg, f = l.rstrip('\n').split('\t')
    if f != 'None': files_with_nodes[f] += 1
    if n.startswith('_private.'):
        j = n.find('.0.')
        if j > 0: used_pairs.add((n[9:j].replace('.', '/') + '.lean', n[j + 3:]))
    else: used_names.add(n)
tot = hit = hitp = 0; per_kind = collections.Counter(); per_kind_hit = collections.Counter()
file_decl = collections.Counter(); file_hit = collections.Counter()
for l in open(os.path.join(D, 'src-index.tsv'), encoding='utf-8', errors='replace'):
    a = l.rstrip('\n').split('\t')
    if len(a) != 4: continue
    n, k, f, ln = a; tot += 1; per_kind[k] += 1; file_decl[f] += 1
    if n in used_names: hit += 1; per_kind_hit[k] += 1; file_hit[f] += 1
    elif any((f, '.'.join(n.split('.')[i:])) in used_pairs for i in range(0, min(6, n.count('.') + 1))):
        hitp += 1; per_kind_hit[k] += 1; file_hit[f] += 1
print('source declarations', tot, 'in closure by public name', hit, 'by private (module,name)', hitp, 'total', hit + hitp, f'{100 * (hit + hitp) / tot:.1f}%')
for k in per_kind: print(' ', k, per_kind_hit[k], '/', per_kind[k], f'{100 * per_kind_hit[k] / per_kind[k]:.1f}%')
lines = {}
for l in open(os.path.join(D, 'src-lines.tsv')):
    f, n = l.rstrip('\n').split('\t'); lines[f] = int(n)
usedf = set(files_with_nodes) | set(f for f in file_hit if file_hit[f] > 0)
un = [f for f in lines if f not in usedf]
print('files', len(lines), 'used', len(usedf), 'unused', len(un))
print('unused files with no indexed declaration at all:', sum(1 for f in un if file_decl[f] == 0), ' lines', sum(lines[f] for f in un if file_decl[f] == 0))
print('unused files with >=1 indexed declaration:', sum(1 for f in un if file_decl[f] > 0), ' lines', sum(lines[f] for f in un if file_decl[f] > 0), ' declarations', sum(file_decl[f] for f in un))
print('unused lines total', sum(lines[f] for f in un), 'of', sum(lines.values()))
print('declarations not in closure that sit in used files:', sum(file_decl[f] - file_hit[f] for f in usedf))
sz = sorted(lines[f] for f in un); print('unused file sizes: median', statistics.median(sz), 'max', sz[-1])
