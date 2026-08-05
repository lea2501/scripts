#!/bin/sh
set -x

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_common_paths.sh"
. "$SCRIPT_DIR/_common_mods_vanilla.sh"

mod_files="$game_dir/mods/vanilla/palette/dimm_pal/doom-pal.wad"

iwad=$(find "$(iwad_path freedoom1-git)" \
  "$(iwad_path freedoom2-git)" \
  2>/dev/null | shuf -n 1 | sed 's/.*\///' | sed 's/.wad//')
echo "INFO: iwad file: $iwad"
map_file=$(find "$game_dir"/maps/"$iwad"/vanilla \
  "$game_dir"/maps/"$iwad"/nolimit \
  "$game_dir"/maps/"$iwad"/boom \
  -type f -name '*.wad' 2>/dev/null | shuf -n 1)
echo "INFO: Map file: $map_file"

bin=$(game_bin "$HOME/src/prboom-plus/prboom2/prboom-plus" prboom-plus) || exit 1

case "$iwad" in
  *doom1*) warp="$(shuf -i 1-4 -n 1) $(shuf -i 1-8 -n 1)" ;;
  *)       warp="$(shuf -i 1-30 -n 1)" ;;
esac

"$bin" \
  -config "$game_dir"/config/prboom-plus/prboom-plus_vanilla.cfg \
  -vidmode gl \
  -complevel 17 \
  -width 1920 -height 1080 \
  -fullscreen \
  -geom 640x360f -aspect 16:9 \
  -iwad "$(iwad_path "$iwad")" \
  -file "$map_file" $mod_files \
  -save "$game_dir"/savegames/"$iwad"/ \
  -skill 3 \
  -warp $warp
