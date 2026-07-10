#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FIXTURES="$ROOT/test/fixtures"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

"$ROOT/scripts/update-cooldis.rb" \
  --tag v0.1.0-rc.5 \
  --release-json "$FIXTURES/release-complete.json" \
  --asset-dir "$FIXTURES/assets" \
  --output "$TMP/cooldis.rb"

grep -q 'version "0.1.0-rc.5"' "$TMP/cooldis.rb"
while read -r target checksum; do
  grep -F -A1 "cooldis-0.1.0-rc.5-$target.tar.gz\"" "$TMP/cooldis.rb" \
    | grep -Fq "sha256 \"$checksum\""
done <<'MAPPINGS'
aarch64-apple-darwin b794fb034851fcd2a6f73c94a2410c5f2f53582970dbd755353150bfd1284a2c
x86_64-apple-darwin 3db9937f9c8b76e9bf1322e8b32893265303b19c3e4f849d55c2112032b58d21
aarch64-unknown-linux-gnu b21cd8f1755674f1393e0d8df1b7687b9f4b11423431c8caa17ed74f436efdc7
x86_64-unknown-linux-gnu a9ab2686ae8c68586f1ac838977e305fc39eb54536d3a829c7d1b4bfadbc8e02
MAPPINGS

sed -n '/^  on_macos do$/,/^  end$/p' "$TMP/cooldis.rb" >"$TMP/macos.rb"
grep -q 'aarch64-apple-darwin' "$TMP/macos.rb"
grep -q 'x86_64-apple-darwin' "$TMP/macos.rb"
if grep -q 'unknown-linux-gnu' "$TMP/macos.rb"; then
  echo "Linux target rendered in macOS block" >&2
  exit 1
fi

sed -n '/^  on_linux do$/,/^  end$/p' "$TMP/cooldis.rb" >"$TMP/linux.rb"
grep -q 'aarch64-unknown-linux-gnu' "$TMP/linux.rb"
grep -q 'x86_64-unknown-linux-gnu' "$TMP/linux.rb"
if grep -q 'apple-darwin' "$TMP/linux.rb"; then
  echo "macOS target rendered in Linux block" >&2
  exit 1
fi

"$ROOT/scripts/update-cooldis.rb" \
  --release-json "$FIXTURES/release-pages.json" \
  --asset-dir "$FIXTURES/assets" \
  --output "$TMP/discovered.rb"
cmp "$TMP/cooldis.rb" "$TMP/discovered.rb"

"$ROOT/scripts/update-cooldis.rb" \
  --tag v0.2.0 \
  --release-json "$FIXTURES/release-stable.json" \
  --asset-dir "$FIXTURES/stable-assets" \
  --output "$TMP/stable.rb"
grep -q 'cooldis-0.2.0-aarch64-apple-darwin.tar.gz' "$TMP/stable.rb"
if grep -q '^  version ' "$TMP/stable.rb"; then
  echo "stable formula unexpectedly has an explicit version" >&2
  exit 1
fi

if "$ROOT/scripts/update-cooldis.rb" \
  --tag v0.1.0-rc.5 \
  --release-json "$FIXTURES/release-incomplete.json" \
  --asset-dir "$FIXTURES/assets" \
  --output "$TMP/incomplete.rb" >"$TMP/incomplete.out" 2>&1
then
  echo "incomplete release unexpectedly succeeded" >&2
  exit 1
fi
grep -q 'release v0.1.0-rc.5 is incomplete for x86_64-unknown-linux-gnu' "$TMP/incomplete.out"
test ! -e "$TMP/incomplete.rb"

cp -R "$FIXTURES/assets" "$TMP/malformed-assets"
printf '%s\n' 'not-a-checksum  cooldis-0.1.0-rc.5-aarch64-apple-darwin.tar.gz' \
  >"$TMP/malformed-assets/cooldis-0.1.0-rc.5-aarch64-apple-darwin.tar.gz.sha256"
if "$ROOT/scripts/update-cooldis.rb" \
  --tag v0.1.0-rc.5 \
  --release-json "$FIXTURES/release-complete.json" \
  --asset-dir "$TMP/malformed-assets" \
  --output "$TMP/malformed.rb" >"$TMP/malformed.out" 2>&1
then
  echo "malformed checksum unexpectedly succeeded" >&2
  exit 1
fi
grep -q 'malformed checksum for cooldis-0.1.0-rc.5-aarch64-apple-darwin.tar.gz' "$TMP/malformed.out"
test ! -e "$TMP/malformed.rb"

if "$ROOT/scripts/update-cooldis.rb" \
  --tag not-a-release \
  --release-json "$FIXTURES/release-complete.json" \
  --asset-dir "$FIXTURES/assets" \
  --output "$TMP/unexpected.rb" >"$TMP/unexpected.out" 2>&1
then
  echo "unexpected tag unexpectedly succeeded" >&2
  exit 1
fi
grep -q 'unexpected requested tag "not-a-release"' "$TMP/unexpected.out"
test ! -e "$TMP/unexpected.rb"

echo "updater tests passed: pagination, prerelease and stable versions, four target mappings, fail-closed releases"
