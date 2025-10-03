#!/bin/sh

game=hexen
game_dir="$HOME/games/doom"
mod_files="$game_dir/mods/vanilla/palette/dimm_pal/hex-pal.wad \
  $game_dir/mods/zdoom/brutal/brutal_hexen/Hexen_v7.5/1_BRUTAL_HEXEN/BrutalHexenRPG_V7.5.pk3 \
  $game_dir/mods/zdoom/brutal/brutal_hexen/Hexen_v7.5/2_HD_TEXTURES/hexen_gz.pk3 \
  $game_dir/mods/zdoom/brutal/brutal_hexen/Hexen_v7.5/3_HEXEN64_MUSIC/3_HEXEN64.wad \
  $game_dir/mods/zdoom/gameplay/bullet_time_x/bullet-time-x_1.3.1.pk3"

pwad_file=$(find "${game_dir}"/maps/${game}/vanilla/*/*.wad \
  "$game_dir"/maps/${game}/nolimit/*/*.wad \
  "$game_dir"/maps/${game}/boom/*/*.wad \
  "$game_dir"/maps/${game}/mbf21/*/*.wad \
  "$game_dir"/maps/${game}/zdoom/*/*.wad \
  "$game_dir"/maps/${game}/zdoom/*/*.pk3 \
   -ls | sort -rn | awk '{print $11}' | shuf -n 1)

set -x
if [ -d /usr/share/gzdoom/ ]; then cd /usr/share/gzdoom/ || return; fi
if [ -d /usr/local/share/games/doom/ ]; then cd /usr/local/share/games/doom/ || return; fi
eval flatpak run org.zdoom.GZDoom -config "$game_dir"/config/zdoom/config_zdoom_hexen.ini \
  -width 1920 -height 1080 \
  -fullscreen \
  -iwad "$game_dir"/maps/iwads/${game}.wad \
  -file "$pwad_file" "$mod_files" \
  -savedir "$game_dir"/savegames/${game}/ \
  -skill 3 \
  -warp 1 1 \
  > /tmp/gzdoom.log
set +x
