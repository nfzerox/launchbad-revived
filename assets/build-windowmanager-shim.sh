#!/bin/sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

SHIM_INSTALL_PATH=/Users/Shared/.launchpad/Frameworks/WindowManagerShim.dylib
WM_CANONICAL=/System/Library/PrivateFrameworks/WindowManager.framework/Versions/A/WindowManager
SRC=windowmanager-shim-src
OUT=WindowManagerShim.dylib

macos_version=$(sw_vers -productVersion | cut -d '.' -f 1)
if [ "$macos_version" -lt 27 ]; then
    echo "WindowManagerShim only needs rebuilding from a macOS 27+ host, where the real" >&2
    echo "WindowManager.framework (used to compute the symbol list below) is missing" >&2
    echo "the 4 symbols this shim replaces." >&2
    exit 1
fi

echo "Computing the set of WindowManager symbols Dock.app needs but the real" >&2
echo "WindowManager.framework on this system doesn't export (should be exactly 4)..." >&2
NEEDS=$(mktemp -t wm-needs)
HAVE=$(mktemp -t wm-have)
MISSING=$(mktemp -t wm-missing)
REEXPORT=$(mktemp -t wm-reexport)
trap 'rm -f "$NEEDS" "$HAVE" "$MISSING" "$REEXPORT"' EXIT

dyld_info -imports Dock.app/Contents/MacOS/Dock 2>/dev/null \
    | grep -i windowmanager | awk '{print $2}' | grep -E '^_?\$s' | sed 's/^_//' | sort -u > "$NEEDS"
dyld_info -exports "$WM_CANONICAL" 2>/dev/null \
    | awk '{print $NF}' | grep -E '^_?\$s' | sed 's/^_//' | sort -u > "$HAVE"
comm -23 "$NEEDS" "$HAVE" > "$MISSING"
comm -12 "$NEEDS" "$HAVE" > "$REEXPORT"

echo "  needed: $(wc -l < "$NEEDS" | tr -d ' ')  missing: $(wc -l < "$MISSING" | tr -d ' ')  re-exported: $(wc -l < "$REEXPORT" | tr -d ' ')" >&2
if [ "$(wc -l < "$MISSING" | tr -d ' ')" != 4 ]; then
    echo "warning: expected exactly 4 missing symbols; got:" >&2
    cat "$MISSING" >&2
fi

REALSTUB=$(mktemp -t wm-realstub).s
{
    echo '.data'
    echo '.p2align 3'
    while IFS= read -r s; do
        printf '.globl "_%s"\n"_%s":\n    .quad 0\n' "$s" "$s"
    done < "$REEXPORT"
} > "$REALSTUB"
REALSTUB_DYLIB=$(mktemp -t wm-realstub).dylib
trap 'rm -f "$NEEDS" "$HAVE" "$MISSING" "$REEXPORT" "$REALSTUB" "$REALSTUB_DYLIB"' EXIT

clang -arch arm64e -c "$SRC/WindowManager-thunk.s" -o /tmp/wm-thunk.o
clang -arch arm64e -dynamiclib -install_name "$WM_CANONICAL" -Wl,-not_for_dyld_shared_cache \
    -o "$REALSTUB_DYLIB" "$REALSTUB"

swiftc -target "arm64e-apple-macos$(sw_vers -productVersion)" -emit-library -O \
    -module-name WindowManager \
    "$SRC/WindowManager.swift" /tmp/wm-thunk.o \
    -o "$OUT" \
    -Xlinker -install_name -Xlinker "$SHIM_INSTALL_PATH" \
    -Xlinker -reexport_library -Xlinker "$REALSTUB_DYLIB"
rm -f /tmp/wm-thunk.o

codesign --force --sign - "$OUT"

echo "Built $OUT:"
file "$OUT"
echo "install name: $(otool -D "$OUT" | tail -1)"
echo "re-export target: $(otool -l "$OUT" | grep -A2 LC_REEXPORT_DYLIB | grep name | awk '{print $2}')"
