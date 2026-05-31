#!/bin/sh

game=doom2
game_dir="$HOME/games/doom"
mod_files="$game_dir/mods/vanilla/palette/dimm_pal/doom-pal.wad \
  $game_dir/mods/zdoom/randomizer/dark_doom_creatures/latest/DMGMOD1.12c30h.wad \
  $game_dir/mods/zdoom/randomizer/dark_doom_creatures/latest/DMGMOD1.38-Gothic-Nightmare-addon.wad \
  $game_dir/mods/zdoom/randomizer/dark_doom_creatures/latest/DMGMOD-mutator_NOnightmares.wad \
  $game_dir/mods/zdoom/randomizer/dark_doom_creatures/latest/DMGMOD-mutator_LESSzombiesMOREimps.wad \
  $game_dir/mods/zdoom/randomizer/dark_doom_creatures/latest/DMGMOD-mutator_NOnewpowerups.wad \
  $game_dir/mods/zdoom/randomizer/dark_doom_creatures/latest/DMGMOD-mutator_NOnewzombies.wad \
  $game_dir/mods/zdoom/randomizer/dark_doom_creatures/latest/immerse_v104.pk3 \
  $game_dir/mods/zdoom/randomizer/dark_doom_creatures/latest/sm4BBgorev3.pk3 \
  $game_dir/mods/zdoom/gameplay/bullet_time_x/bullet-time-x_1.3.1.pk3"

pwad_file=$(find "$game_dir"/maps/"$game"/vanilla \
  "$game_dir"/maps/"$game"/nolimit \
  "$game_dir"/maps/"$game"/boom \
  "$game_dir"/maps/"$game"/zdoom \
  -type f \( -name '*.wad' -o -name '*.pk3' \) 2>/dev/null | shuf -n 1)

if [ -d /usr/share/gzdoom/ ]; then cd /usr/share/gzdoom/ || return; fi
if [ -d /usr/local/share/games/doom/ ]; then cd /usr/local/share/games/doom/ || return; fi
flatpak run org.zdoom.GZDoom -config "$game_dir"/config/zdoom/config_zdoom.ini \
  -width 1920 -height 1080 \
  -fullscreen \
  -iwad "$game_dir"/maps/iwads/"$game".wad \
  -file "$pwad_file" $mod_files \
  -savedir "$game_dir"/savegames/"$game"/ \
  -skill 3 \
  -warp 1 \
  > /tmp/gzdoom.log
