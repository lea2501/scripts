#!/bin/sh

game=doom2
game_dir="$HOME/games/doom"
mod_files="$game_dir/mods/vanilla/sound/pk_doom_sfx/pk_doom_sfx_20120224.wad \
  $game_dir/mods/vanilla/palette/dimm_pal/doom-pal.wad"

pwad_file=$(find "$game_dir"/maps/"$game"/vanilla \
  "$game_dir"/maps/"$game"/nolimit \
  "$game_dir"/maps/"$game"/boom \
  -type f -name '*.wad' 2>/dev/null | shuf -n 1)

dsda-doom -config "$game_dir"/config/dsda-doom/dsda-doom_vanilla.cfg \
  -vidmode gl \
  -complevel 17 \
  -width 1920 -height 1080 \
  -fullscreen \
  -geom 640x360f -aspect 16:9 \
  -iwad "$game_dir"/maps/iwads/"$game".wad \
  -file "$pwad_file" $mod_files \
  -save "$game_dir"/savegames/"$game"/ \
  -skill 3 \
  -warp 1 \
  > /tmp/dsda-doom.log
