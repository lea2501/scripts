#!/usr/bin/env bash
set -euo pipefail

if (( $# < 1 || $# > 2 )); then
    printf 'Usage: %s MAP.wad [MAP_NUMBER]\n' "$0" >&2
    exit 2
fi

readonly MAP_WAD="$1"
readonly WARP="${2:-01}"
readonly UZDOOM_LOCAL="$HOME/src/UZDoom/build/uzdoom"
readonly IWAD="$HOME/games/doom/maps/iwads/doom2.wad"
readonly MOD="$HOME/games/doom/mods/zdoom/gameplay/vomitoreum_for_doom/vomitoreum_for_doom.pk3"
readonly CONFIG="$HOME/games/doom/config/zdoom/config_zdoom.ini"
readonly SAVEDIR="$HOME/games/doom/savegames/doom2"

if [[ ! -f "$MAP_WAD" ]]; then
    printf 'Map not found: %s\n' "$MAP_WAD" >&2
    exit 1
fi

if [[ ! -f "$MOD" ]]; then
    "$HOME/src/scripts/games/build_vomitoreum_for_doom.sh"
fi

if [[ -x "$UZDOOM_LOCAL" ]]; then
    uzdoom_bin="$UZDOOM_LOCAL"
else
    uzdoom_bin="$(command -v uzdoom)"
fi

mkdir -p "$SAVEDIR"

exec "$uzdoom_bin" \
    -config "$CONFIG" \
    -width 1920 -height 1080 -fullscreen \
    -iwad "$IWAD" \
    -file "$MAP_WAD" "$MOD" \
    -savedir "$SAVEDIR" \
    -skill 3 -warp "$WARP"

