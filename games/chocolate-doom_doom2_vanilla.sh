#!/bin/sh

game=doom2
game_dir="$HOME/games/doom"
mod_files="$game_dir/mods/vanilla/sound/pk_doom_sfx/pk_doom_sfx_20120224.wad \
  $game_dir/mods/vanilla/palette/dimm_pal/doom-pal.wad"

pwad_file=$(find "$game_dir"/maps/"$game"/vanilla \
  -type f -name '*.wad' 2>/dev/null | shuf -n 1)

chocolate-doom -config "$game_dir"/config/chocolate/config.ini \
  -fullscreen -iwad "$game_dir"/maps/iwads/"$game".wad \
  -file "$pwad_file" $mod_files \
  -savedir "$game_dir"/savegames/"$game"/ \
  -skill 3 \
  -warp 1 \
  > /tmp/chocolate-doom.log
