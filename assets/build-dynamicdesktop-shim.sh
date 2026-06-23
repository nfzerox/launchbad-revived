#!/bin/sh
# Rebuild assets/DynamicDesktop.framework from DynamicDesktop-shim.c.
#
# The prebuilt framework is committed to the repo so installs need no compiler,
# but this script documents exactly how it was produced and lets you regenerate
# it.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

INSTALL_NAME=/System/Library/PrivateFrameworks/DynamicDesktop.framework/Versions/A/DynamicDesktop
FW=DynamicDesktop.framework

rm -rf "$FW"
mkdir -p "$FW/Versions/A/Resources"

clang -arch x86_64 -arch arm64e -dynamiclib \
    -install_name "$INSTALL_NAME" \
    -compatibility_version 1.0.0 -current_version 2419.0.0 \
    -o "$FW/Versions/A/DynamicDesktop" DynamicDesktop-shim.c

cat > "$FW/Versions/A/Resources/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIdentifier</key>
    <string>com.apple.DynamicDesktop</string>
    <key>CFBundleName</key>
    <string>DynamicDesktop</string>
    <key>CFBundleVersion</key>
    <string>2419.0.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
</dict>
</plist>
PLIST

ln -s A "$FW/Versions/Current"
ln -s Versions/Current/DynamicDesktop "$FW/DynamicDesktop"
ln -s Versions/Current/Resources "$FW/Resources"

codesign --force --sign - "$FW/Versions/A/DynamicDesktop"

echo "Built $FW:"
lipo -archs "$FW/Versions/A/DynamicDesktop"
otool -D "$FW/Versions/A/DynamicDesktop" | tail -n +2 | sort -u
