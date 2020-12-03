#!/bin/bash
set -eu

die () { echo "ERROR: $*" >&2; exit 2; }

for cmd in pdoc3; do
    command -v "$cmd" >/dev/null ||
    die "Missing $cmd; \`pip install $cmd\`"
done

DOCROOT="$(pwd)"
BUILDROOT="$DOCROOT/build"

echo
echo 'Building docs'
echo
mkdir -p "$BUILDROOT"
rm -r "$BUILDROOT" 2>/dev/null || true
pushd "$DOCROOT/.." >/dev/null
PYTHONPATH=./parametricilds pdoc3 --html \
--template-dir "$DOCROOT/parametricilds_template" \
--output-dir "$BUILDROOT" \parametricilds
popd >/dev/null


echo
echo "All good. Docs in: $BUILDROOT"
echo
echo "    file://$BUILDROOT/parametricilds/index.html"
echo
