#!/bin/sh
# Doom II map picker; launch command follows games_doom_uzdoom.md.
set -eu
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
game_dir="$HOME/games/doom"
map_dir="$game_dir/maps/doom2"
engine="$HOME/src/UZDoom/build/uzdoom"
command -v dmenu >/dev/null 2>&1 || { echo 'dmenu is required.' >&2; exit 1; }
[ -x "$engine" ] || engine=$(command -v uzdoom)
[ -d "$map_dir" ] || { echo "Missing maps directory: $map_dir" >&2; exit 1; }
map=$(
    find "$map_dir" -type f \( -iname '*.wad' -o -iname '*.pk3' -o -iname '*.pk7' -o -iname '*.ipk3' \) |
        LC_ALL=C sort -f | dmenu -i -l 20 -p 'Doom II:'
) || exit 0
[ -n "$map" ] || exit 0
case "$map" in
    "$map_dir"/*) [ -f "$map" ] || exit 1 ;;
    *) exit 1 ;;
esac
mkdir -p "$game_dir/savegames/doom2"
# Keep the engine output available without holding open a terminal.
log_dir="${XDG_CACHE_HOME:-$HOME/.cache}/doom-launcher"
mkdir -p "$log_dir"
exec "$engine" \
    -config "$game_dir/config/zdoom/config_zdoom.ini" \
    -width 1920 -height 1080 -fullscreen \
    -iwad "$game_dir/maps/iwads/doom2.wad" \
    -file "$map" \
    "$game_dir/mods/vanilla/sound/pk_doom_sfx/pk_doom_sfx_20120224.wad" \
    "$game_dir/mods/vanilla/palette/jovian_palette/JovPal.wad" \
    "$game_dir/mods/zdoom/enhancements/vanilla_essence/vanilla_essence_4_3.pk3" \
    -savedir "$game_dir/savegames/doom2/" -skill 3 -warp 01 \
    > "$log_dir/uzdoom.log" 2>&1
