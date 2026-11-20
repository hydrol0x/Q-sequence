# Index of declarations written in the project's source: one line per declaration "name<TAB>kind<TAB>file<TAB>line".
# Tracks namespace/section/end. Approximate (text-based), used only to attribute exported names to files.
import os, re, sys
src = '/work/ext/lean/src'; out = open('/home/judge/dep/src-index.tsv', 'w')
head = re.compile(r'^\s*(?:@\[[^\]]*\]\s*)*(?:(?:private|protected|noncomputable|nonrec|unsafe|partial|scoped|local)\s+)*(theorem|lemma|def|abbrev|structure|class|inductive|instance|alias|opaque|axiom)\s+(?:\(priority[^)]*\)\s*)?([^\s:(\[{]+)?')
ns_re = re.compile(r'^\s*namespace\s+(\S+)'); sec_re = re.compile(r'^\s*(?:noncomputable\s+)?section\b\s*(\S*)'); end_re = re.compile(r'^\s*end\b\s*(\S*)')
nfiles = ndecl = 0; lines_of = {}
for root, _, files in os.walk(src):
    for f in files:
        if not f.endswith('.lean'): continue
        p = os.path.join(root, f); rel = os.path.relpath(p, src); nfiles += 1
        stack = []  # entries: ('ns', name) or ('sec', name)
        n = 0
        with open(p, encoding='utf-8', errors='replace') as fh:
            for n, line in enumerate(fh, 1):
                c = line[:1]
                if c not in ' \tnseptadlcioau@': continue
                m = ns_re.match(line)
                if m: stack.append(('ns', m.group(1))); continue
                m = end_re.match(line)
                if m and stack:
                    stack.pop(); continue
                m = sec_re.match(line)
                if m: stack.append(('sec', m.group(1))); continue
                m = head.match(line)
                if m:
                    kind, name = m.group(1), m.group(2) or ''
                    if kind == 'instance' and (not name or name.startswith(':')): name = ''
                    if name.startswith('_root_.'): full = name[7:]
                    else:
                        pre = '.'.join(x[1] for x in stack if x[0] == 'ns')
                        full = (pre + '.' + name) if (pre and name) else (name or pre + '.<anon instance>')
                    out.write(f"{full}\t{kind}\t{rel}\t{n}\n"); ndecl += 1
        lines_of[rel] = n
out.close()
with open('/home/judge/dep/src-lines.tsv', 'w') as g:
    for k, v in lines_of.items(): g.write(f"{k}\t{v}\n")
print("files", nfiles, "declarations indexed", ndecl)
