#!/bin/sh

game=doom2
game_dir="$HOME/games/doom"
mod_files="$game_dir/mods/vanilla/sound/pk_doom_sfx/pk_doom_sfx_20120224.wad \
  $game_dir/mods/vanilla/palette/dimm_pal/doom-pal.wad \
  $game_dir/mods/vanilla/enhancements/vbright/vbright.wad \
  $game_dir/mods/vanilla/sound/softfx/softfx.wad \
  $game_dir/mods/vanilla/enhancements/smoothed/smoothed.wad"

pwad_file=$(find "${game_dir}"/maps/${game}/vanilla/*/*.wad \
  "$game_dir"/maps/${game}/nolimit/*/*.wad \
   -ls | sort -rn | awk '{print $11}' | shuf -n 1)

set -x
eval crispy-doom -config "$game_dir"/config/crispy/config_vanilla.ini \
  -fullscreen -iwad "$game_dir"/maps/iwads/${game}.wad \
  -file "$pwad_file" "$mod_files" \
  -savedir "$game_dir"/savegames/${game}/ \
  -skill 3 \
  -warp 1 \
  > /tmp/crispy-doom.log
set +x
