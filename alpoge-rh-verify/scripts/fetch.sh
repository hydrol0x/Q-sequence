#!/bin/bash
# runs as unprivileged user "builder" with a scrubbed environment
set -u
ts(){ date -u +"[%Y-%m-%dT%H:%M:%SZ]"; }
echo "$(ts) == whoami: $(id -un); env names: $(env | cut -d= -f1 | tr '\n' ' ')"
cd /work/dl
echo "$(ts) == download 14 parts from alpo.ge"
S=$(date +%s)
for i in $(seq -w 1 14); do curl -fsSL --retry 3 -o lean.tar.gz.part$i -w "part$i http=%{http_code} bytes=%{size_download} ip=%{remote_ip}\n" https://alpo.ge/lean.tar.gz.part$i || echo "part$i FAILED rc=$?"; done
echo "download wall=$(( $(date +%s)-S ))s"
ls -l /work/dl
sha256sum lean.tar.gz.part*
cat lean.tar.gz.part{01..14} > lean.tar.gz
echo "$(ts) == merged archive"; stat -c "bytes=%s" lean.tar.gz; sha256sum lean.tar.gz
echo "expected (mirror README): 9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc bytes=239275554"
echo "$(ts) == archive listing checks"
/usr/bin/time -f "tar-list wall=%es rss=%MKB" tar -tvzf lean.tar.gz > /work/logs/tar-listing.txt
echo "entries: $(wc -l < /work/logs/tar-listing.txt)"
echo "entry types (first char of mode):"; cut -c1 /work/logs/tar-listing.txt | sort | uniq -c
tar -tzf lean.tar.gz > /work/logs/tar-names.txt
echo "absolute paths: $(grep -c '^/' /work/logs/tar-names.txt)"
echo "dotdot components: $(grep -cE '(^|/)\.\.(/|$)' /work/logs/tar-names.txt)"
echo "top-level entries:"; cut -d/ -f1,2 /work/logs/tar-names.txt | sort -u | head -20
echo "non-.lean regular files:"; grep -vE '/$' /work/logs/tar-names.txt | grep -v '\.lean$' | head -20
echo "owners/modes:"; awk '{print $1, $2}' /work/logs/tar-listing.txt | sort | uniq -c | sort -rn | head
BAD=$(cut -c1 /work/logs/tar-listing.txt | grep -vc '^[-d]')
if [ "$BAD" != "0" ] || grep -q '^/' /work/logs/tar-names.txt || grep -qE '(^|/)\.\.(/|$)' /work/logs/tar-names.txt; then echo "UNSAFE ARCHIVE ENTRIES, not extracting"; exit 3; fi
echo "$(ts) == extract"
/usr/bin/time -f "extract wall=%es rss=%MKB" tar -xzf lean.tar.gz -C /work/ext --no-same-owner
ls -la /work/ext; P=$(dirname "$(find /work/ext -maxdepth 2 -name lakefile.toml | head -1)"); echo "project root: $P"; ls -la "$P"
cd "$P"
echo "src manifest hash: $(find src -type f -print0 | LC_ALL=C sort -z | xargs -0 sha256sum | sha256sum)"
echo "src files: $(find src -type f | wc -l) lean: $(find src -name '*.lean' | wc -l) symlinks: $(find . -type l | wc -l)"
sha256sum lakefile.toml lean-toolchain lake-manifest.json; cat lean-toolchain; ls -la
cp lake-manifest.json /work/logs/lake-manifest.orig.json
echo "$(ts) == elan"
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh -s -- -y --default-toolchain none
. ~/.elan/env
elan --version
/usr/bin/time -f "toolchain wall=%es rss=%MKB" lean --version
lake --version
elan show
echo "$(ts) == lake exe cache get"
/usr/bin/time -v lake exe cache get 2>&1 | tail -60
echo "$(ts) == post-cache checks"
git -C .lake/packages/mathlib rev-parse HEAD
for p in .lake/packages/*; do echo "$(basename $p) $(git -C $p rev-parse HEAD)"; done
cmp lake-manifest.json /work/logs/lake-manifest.orig.json && echo "lake-manifest.json unchanged" || echo "lake-manifest.json CHANGED"
du -sh .lake; df -h /work | tail -1
echo "$(ts) == prep done"
