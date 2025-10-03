#!/bin/sh

game=hexen
game_dir="$HOME/games/doom"
mod_files="$game_dir/mods/vanilla/palette/dimm_pal/hex-pal.wad"

pwad_file=$(find "${game_dir}"/maps/${game}/vanilla/*/*.wad \
  "$game_dir"/maps/${game}/vanilla_cds/*/*.wad \
  "$game_dir"/maps/${game}/nolimit/*/*.wad \
   -ls | sort -rn | awk '{print $11}' | shuf -n 1)

set -x
eval crispy-hexen -config "$game_dir"/config/crispy/config_nolimit_hexen.ini \
  -fullscreen -iwad "$game_dir"/maps/iwads/${game}.wad \
  -file "$pwad_file" "$mod_files" \
  -savedir "$game_dir"/savegames/${game}/ \
  -skill 3 \
  -warp 1 1 \
  > /tmp/crispy-hexen.log
set +x