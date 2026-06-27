#!/bin/sh
set -x

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_common_paths.sh"
. "$SCRIPT_DIR/_common_mods_vanilla.sh"
. "$SCRIPT_DIR/_common_mods_zdoom.sh"

game=doom2
uzdoom_bin="${UZDOOM_BIN:-/home/lea/src/UZDoom/build/uzdoom}"
mod_files="$mods_vanilla_doom $mods_zdoom_brutal"

"$uzdoom_bin" \
  -config "$game_dir"/config/zdoom/config_zdoom.ini \
  -width 1920 -height 1080 \
  -fullscreen \
  -iwad "$(iwad_path "$game")" \
  -file $mod_files \
  -savedir "$game_dir"/savegames/"$game"/ \
  -skill 3 \
  -warp 01 \
  > /tmp/uzdoom_doom2_brutal.log
