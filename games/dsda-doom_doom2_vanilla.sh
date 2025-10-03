#!/bin/sh

game=doom2
game_dir="$HOME/games/doom"
mod_files="$game_dir/mods/vanilla/sound/pk_doom_sfx/pk_doom_sfx_20120224.wad \
  $game_dir/mods/vanilla/palette/dimm_pal/doom-pal.wad"

pwad_file=$(find "${game_dir}"/maps/${game}/vanilla/*/*.wad \
  "$game_dir"/maps/${game}/nolimit/*/*.wad \
  "$game_dir"/maps/${game}/boom/*/*.wad \
   -ls | sort -rn | awk '{print $11}' | shuf -n 1)

set -x
eval dsda-doom -config "${game_dir}"/config/dsda-doom/dsda-doom_vanilla.cfg \
  -vidmode gl \
  -complevel 17 \
  -width 1920 -height 1080 \
  -fullscreen \
  -geom 640x360f -aspect 16:9 \
  -iwad "$game_dir"/maps/iwads/${game}.wad \
  -file "$pwad_file" "$mod_files" \
  -save ~/games/doom/savegames/${game}/ \
  -skill 3 \
  -warp 1 \
  > /tmp/dsda-doom.log
set +x
