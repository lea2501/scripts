#!/usr/bin/env bash
set -euo pipefail

readonly SOURCE_DIR="$HOME/src/mods/doom/vomitoreum_for_doom"
readonly OUTPUT_DIR="$HOME/games/doom/mods/zdoom/gameplay/vomitoreum_for_doom"
readonly OUTPUT_FILE="$OUTPUT_DIR/vomitoreum_for_doom.pk3"
readonly IWAD="$HOME/games/doom/maps/iwads/doom2.wad"
readonly VOMITOREUM="$HOME/games/doom/mods/zdoom_tc/vomitoreum/shrine.ipk3"

if [[ ! -f "$IWAD" ]]; then
    printf 'Missing Doom II IWAD: %s\n' "$IWAD" >&2
    exit 1
fi

if [[ ! -f "$VOMITOREUM" ]]; then
    printf 'Missing Vomitoreum IPK3: %s\n' "$VOMITOREUM" >&2
    exit 1
fi

"$SOURCE_DIR/generate_textures.pl" "$IWAD" "$SOURCE_DIR/TEXTURES"

mkdir -p "$OUTPUT_DIR"
rm -f "$OUTPUT_FILE"

BUILD_DIR="$(mktemp -d /tmp/vomitoreum-for-doom.XXXXXX)"
trap 'rm -rf -- "$BUILD_DIR"' EXIT

unzip -oq "$VOMITOREUM" \
    'SPRITES/*' \
    'SOUNDS/*' \
    'Decorate/ENEMIES' \
    'Textures.wad' \
    'PLAYPAL' \
    'SNDINFO.MAIN' \
    'DECALDEFS' \
    'GLDEFS' \
    -d "$BUILD_DIR"

cp "$SOURCE_DIR/DECORATE" "$BUILD_DIR/DECORATE"
cp "$SOURCE_DIR/DECORATE.COMPAT" "$BUILD_DIR/DECORATE.COMPAT"
cp "$SOURCE_DIR/ZSCRIPT" "$BUILD_DIR/ZSCRIPT"
cp "$SOURCE_DIR/TEXTURES" "$BUILD_DIR/TEXTURES"
cp "$SOURCE_DIR/README.md" "$BUILD_DIR/README.md"
mv "$BUILD_DIR/SNDINFO.MAIN" "$BUILD_DIR/SNDINFO"
sed -i 's/"Nephilem"/"DoomPlayer"/g' "$BUILD_DIR/Decorate/ENEMIES"

(
    cd "$BUILD_DIR"
    zip -q -9 -r "$OUTPUT_FILE" .
)

printf 'Created: %s\n' "$OUTPUT_FILE"

