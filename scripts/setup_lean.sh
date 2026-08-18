#!/usr/bin/env bash
# Bootstrap the exact Lean toolchain used by this project WITHOUT elan.
#
# Rationale: in this sandbox the elan installer host (elan.lean-lang.org) and
# the GitHub *API* are blocked, but GitHub *release asset* downloads and
# anonymous git reads work.  So we fetch the prebuilt toolchain tarball
# directly and put `lean`/`lake` on PATH.  Idempotent.
#
# After running, `lean`/`lake` are on PATH (via /usr/local/bin symlinks) and
# `lake build` works in this repo.
set -euo pipefail

LEAN_VERSION="${LEAN_VERSION:-4.33.0}"   # must match ./lean-toolchain
PREFIX="/opt/lean-${LEAN_VERSION}"
URL="https://github.com/leanprover/lean4/releases/download/v${LEAN_VERSION}/lean-${LEAN_VERSION}-linux.tar.zst"

if [ -x "${PREFIX}/bin/lean" ]; then
  echo "Lean ${LEAN_VERSION} already installed at ${PREFIX}"
else
  echo "Installing dependencies (zstd; GMP/libuv already present in base image)..."
  if command -v apt-get >/dev/null 2>&1; then
    apt-get install -y -qq zstd >/dev/null 2>&1 || true
  fi
  command -v zstd >/dev/null 2>&1 || { echo "ERROR: zstd required"; exit 1; }

  tmp="$(mktemp -d)"
  echo "Downloading ${URL} ..."
  curl -sSL --max-time 600 -o "${tmp}/lean.tar.zst" "${URL}"
  echo "Extracting to ${PREFIX} ..."
  mkdir -p "${PREFIX}"
  tar --use-compress-program=unzstd -xf "${tmp}/lean.tar.zst" -C "${PREFIX}" --strip-components=1
  rm -rf "${tmp}"
fi

echo "Linking into /usr/local/bin ..."
for b in lean lake leanc leanmake leanchecker leantar; do
  ln -sf "${PREFIX}/bin/${b}" "/usr/local/bin/${b}"
done
echo 'export PATH='"${PREFIX}"'/bin:$PATH' > /etc/profile.d/lean.sh 2>/dev/null || true

echo "----"
lean --version
lake --version
echo "OK. Run 'lake build' in the repo root to build + re-verify."
