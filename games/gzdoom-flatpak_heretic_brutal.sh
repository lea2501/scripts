#!/bin/sh

game=heretic
game_dir="$HOME/games/doom"
mod_files="$game_dir/mods/vanilla/palette/dimm_pal/her-pal.wad \
  $game_dir/mods/zdoom/brutal/brutal_heretic/Heretic-Shadow_Collection_v6.1/1_BRUTAL_HERETIC/BrutalHereticRPG_V6.1.pk3 \
  $game_dir/mods/zdoom/brutal/brutal_heretic/Heretic-Shadow_Collection_v6.1/2_HD_TEXTURES/heretic_gz.pk3 \
  $game_dir/mods/zdoom/brutal/brutal_heretic/Heretic-Shadow_Collection_v6.1/3_HD_SOUNDTRACK/H20MUS.wad \
  $game_dir/mods/zdoom/gameplay/bullet_time_x/bullet-time-x_1.3.1.pk3"

pwad_file=$(find "$game_dir"/maps/"$game"/vanilla \
  "$game_dir"/maps/"$game"/nolimit \
  "$game_dir"/maps/"$game"/boom \
  "$game_dir"/maps/"$game"/mbf21 \
  "$game_dir"/maps/"$game"/zdoom \
  -type f \( -name '*.wad' -o -name '*.pk3' \) 2>/dev/null | shuf -n 1)

if [ -d /usr/share/gzdoom/ ]; then cd /usr/share/gzdoom/ || return; fi
if [ -d /usr/local/share/games/doom/ ]; then cd /usr/local/share/games/doom/ || return; fi
flatpak run org.zdoom.GZDoom -config "$game_dir"/config/zdoom/config_zdoom_heretic.ini \
  -width 1920 -height 1080 \
  -fullscreen \
  -iwad "$game_dir"/maps/iwads/"$game".wad \
  -file "$pwad_file" $mod_files \
  -savedir "$game_dir"/savegames/"$game"/ \
  -skill 3 \
  -warp 1 1 \
  > /tmp/gzdoom.log
