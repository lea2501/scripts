#!/bin/sh

game=doom2
game_dir="$HOME/games/doom"
mod_files="$game_dir/mods/vanilla/palette/dimm_pal/doom-pal.wad \
  $game_dir/mods/zdoom/enhancements/beautiful_doom/beautiful_doom_716.pk3 \
  $game_dir/mods/zdoom/gameplay/bullet_time_x/bullet-time-x_1.3.1.pk3"

pwad_file=$(find "${game_dir}"/maps/${game}/vanilla/*/*.wad \
  "$game_dir"/maps/${game}/nolimit/*/*.wad \
  "$game_dir"/maps/${game}/boom/*/*.wad \
  "$game_dir"/maps/${game}/zdoom/*/*.wad \
  "$game_dir"/maps/${game}/zdoom/*/*.pk3 \
   -ls | sort -rn | awk '{print $11}' | shuf -n 1)

set -x
if [ -d /usr/share/gzdoom/ ]; then cd /usr/share/gzdoom/ || return; fi
if [ -d /usr/local/share/games/doom/ ]; then cd /usr/local/share/games/doom/ || return; fi
eval flatpak run org.zdoom.GZDoom -config "$game_dir"/config/zdoom/config_zdoom.ini \
  -width 1920 -height 1080 \
  -fullscreen \
  -iwad "$game_dir"/maps/iwads/${game}.wad \
  -file "$pwad_file" "$mod_files" \
  -savedir "$game_dir"/savegames/${game}/ \
  -skill 3 \
  -warp 1 \
  > /tmp/gzdoom.log
set +x
