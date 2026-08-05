#!/bin/sh
set -x

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_common_paths.sh"
. "$SCRIPT_DIR/_common_mods_vanilla.sh"

game=doom2
doom_bin=$(game_bin "$HOME/src/chocolate-doom/src/chocolate-doom" chocolate-doom) || exit 1
mod_files="$mods_vanilla_doom"

pwad_file=$(find "$game_dir"/maps/"$game"/vanilla \
  -type f -name '*.wad' 2>/dev/null | shuf -n 1)

"$doom_bin" -config "$game_dir"/config/chocolate/config.ini \
  -fullscreen -iwad "$(iwad_path "$game")" \
  -file "$pwad_file" $mod_files \
  -savedir "$game_dir"/savegames/"$game"/ \
  -skill 3 \
  -warp 1 \
  > /tmp/chocolate-doom.log
