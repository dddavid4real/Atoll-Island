#!/bin/bash

set -euo pipefail

fail() {
  printf 'Code Island helper build failed: %s\n' "$1" >&2
  exit 1
}

if [ "$#" -ne 1 ]; then
  fail "usage: $0 '/path/to/Atoll Island.app/Contents/Helpers/codeisland-bridge'"
fi

DESTINATION=$1
SCRIPT_DIRECTORY=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(cd "$SCRIPT_DIRECTORY/.." && pwd)
PACKAGE_PATH="$PROJECT_ROOT/Packages/CodeIsland"

case "${CONFIGURATION:-Release}" in
  Debug|debug)
    SWIFT_CONFIGURATION=debug
    ;;
  Release|release)
    SWIFT_CONFIGURATION=release
    ;;
  *)
    fail "unsupported Xcode configuration: ${CONFIGURATION}"
    ;;
esac

BUILD_ROOT=${CODEISLAND_BRIDGE_SCRATCH_PATH:-${DERIVED_FILE_DIR:-${TARGET_TEMP_DIR:-/private/tmp}/AtollCodeIslandBridge}}
mkdir -p \
  "$BUILD_ROOT/cache" \
  "$BUILD_ROOT/config" \
  "$BUILD_ROOT/module-cache" \
  "$BUILD_ROOT/security"

export CLANG_MODULE_CACHE_PATH=${CLANG_MODULE_CACHE_PATH:-$BUILD_ROOT/module-cache}
export SWIFT_MODULECACHE_PATH=${SWIFT_MODULECACHE_PATH:-$BUILD_ROOT/module-cache}

SWIFT_EXEC=${SWIFT_EXECUTABLE:-}
if [ -z "$SWIFT_EXEC" ]; then
  SWIFT_EXEC=$(xcrun --find swift)
fi
[ -x "$SWIFT_EXEC" ] || fail "Swift compiler is unavailable"

ARCHITECTURES=${ARCHS:-${CURRENT_ARCH:-$(uname -m)}}
BUILD_ARGUMENTS=(
  build
  --disable-sandbox
  --package-path "$PACKAGE_PATH"
  --scratch-path "$BUILD_ROOT/build"
  --cache-path "$BUILD_ROOT/cache"
  --config-path "$BUILD_ROOT/config"
  --security-path "$BUILD_ROOT/security"
  --configuration "$SWIFT_CONFIGURATION"
)

ARCHITECTURE_COUNT=0
for architecture in $ARCHITECTURES; do
  case "$architecture" in
    arm64|x86_64)
      BUILD_ARGUMENTS+=(--arch "$architecture")
      ARCHITECTURE_COUNT=$((ARCHITECTURE_COUNT + 1))
      ;;
    *)
      fail "unsupported helper architecture: $architecture"
      ;;
  esac
done
[ "$ARCHITECTURE_COUNT" -gt 0 ] || fail "no helper architecture was selected"

"$SWIFT_EXEC" "${BUILD_ARGUMENTS[@]}" --product codeisland-bridge
BIN_PATH=$("$SWIFT_EXEC" "${BUILD_ARGUMENTS[@]}" --show-bin-path)
SOURCE="$BIN_PATH/codeisland-bridge"
[ -x "$SOURCE" ] || fail "SwiftPM did not produce codeisland-bridge"

DEPENDENCIES=$(/usr/bin/otool -L "$SOURCE")
if printf '%s\n' "$DEPENDENCIES" \
  | grep -Eq 'CodeIsland(Core|Runtime)\.framework|libCodeIsland(Core|Runtime)\.dylib'; then
  fail "SwiftPM produced a helper with private Code Island dependencies"
fi

mkdir -p "$(dirname "$DESTINATION")"
/usr/bin/install -m 755 "$SOURCE" "$DESTINATION"

if [ "${CODE_SIGNING_ALLOWED:-NO}" = "YES" ]; then
  SIGNING_IDENTITY=${EXPANDED_CODE_SIGN_IDENTITY:-${CODE_SIGN_IDENTITY:--}}
  [ -n "$SIGNING_IDENTITY" ] || SIGNING_IDENTITY=-
  SIGNING_ARGUMENTS=(--force --sign "$SIGNING_IDENTITY")
  if [ "${ENABLE_HARDENED_RUNTIME:-NO}" = "YES" ]; then
    SIGNING_ARGUMENTS+=(--options runtime)
  fi
  /usr/bin/codesign "${SIGNING_ARGUMENTS[@]}" "$DESTINATION"
fi

printf 'Built self-contained Code Island helper: %s\n' "$DESTINATION"
