import os, re, sys, collections
src = sys.argv[1]
mods = {}
imp_re = re.compile(r'^\s*(?:public\s+|meta\s+|private\s+)*import\s+(?:all\s+)?(.+?)\s*$')
ext = collections.Counter()
lines_of = {}
for root, _, files in os.walk(src):
    for f in files:
        if not f.endswith('.lean'): continue
        p = os.path.join(root, f)
        m = os.path.relpath(p, src)[:-5].replace(os.sep, '.')
        imps = []
        n = 0
        with open(p, encoding='utf-8', errors='replace') as fh:
            in_header = True
            for line in fh:
                n += 1
                if in_header:
                    mm = imp_re.match(line)
                    if mm:
                        imps += mm.group(1).split()
                    elif line.strip() and not line.strip().startswith('--') and not line.strip().startswith('module'):
                        in_header = False
        mods[m] = imps
        lines_of[m] = n
for m, imps in mods.items():
    for i in imps:
        if i not in mods: ext[i] += 1
print("modules:", len(mods), "total lines:", sum(lines_of.values()))
print("external imports (name: count):", dict(ext.most_common(30)))
def closure(root):
    seen = set(); st = [root]
    while st:
        x = st.pop()
        if x in seen or x not in mods: continue
        seen.add(x); st += mods[x]
    return seen
for r in sys.argv[2:]:
    c = closure(r)
    print(f"{r}: in-repo closure = {len(c)} modules, {sum(lines_of[x] for x in c)} lines, exists={r in mods}")
c = closure('Main')
missing = sorted(set(mods) - c)
print("modules NOT in Main closure:", len(missing), missing[:20])
tops = collections.Counter(m.split('.')[0] for m in mods)
print("top-level:", dict(tops))
