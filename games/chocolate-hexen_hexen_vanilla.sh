#!/bin/sh
set -x

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_common_paths.sh"
. "$SCRIPT_DIR/_common_mods_vanilla.sh"

game=hexen
hexen_bin=$(game_bin "$HOME/src/chocolate-doom/src/chocolate-hexen" chocolate-hexen) || exit 1
mod_files="$mods_vanilla_hexen"

pwad_file=$(find "$game_dir"/maps/"$game"/vanilla \
  "$game_dir"/maps/"$game"/vanilla_cds \
  -type f -name '*.wad' 2>/dev/null | shuf -n 1)

"$hexen_bin" -config "$game_dir"/config/chocolate/config_heretic.ini \
  -fullscreen -iwad "$(iwad_path "$game")" \
  -file "$pwad_file" $mod_files \
  -savedir "$game_dir"/savegames/"$game"/ \
  -skill 3 \
  -warp 1 1 \
  > /tmp/chocolate-hexen.log
