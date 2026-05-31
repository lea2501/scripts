#!/bin/sh

game=hexen
game_dir="$HOME/games/doom"
mod_files="$game_dir/mods/vanilla/palette/dimm_pal/hex-pal.wad"

pwad_file=$(find "$game_dir"/maps/"$game"/vanilla \
  "$game_dir"/maps/"$game"/vanilla_cds \
  -type f -name '*.wad' 2>/dev/null | shuf -n 1)

chocolate-hexen -config "$game_dir"/config/chocolate/config_heretic.ini \
  -fullscreen -iwad "$game_dir"/maps/iwads/"$game".wad \
  -file "$pwad_file" $mod_files \
  -savedir "$game_dir"/savegames/"$game"/ \
  -skill 3 \
  -warp 1 1 \
  > /tmp/chocolate-hexen.log
