#!/bin/sh

param_game_dir="$HOME/games/doom"
iwad=$(find /home/lea/games/doom/maps/iwads/{freedoom1-git.wad,freedoom2-git.wad} | shuf -n 1 | sed 's/.*\///' | sed 's/.wad//')
echo "INFO: iwad file: $iwad"
map_file=$(find $HOME/games/doom/maps/$iwad/{vanilla,nolimit,boom}/*/*.wad -type f 2>/dev/null | shuf -n 1)
echo "INFO: Map file: $map_file"
mod_files="$param_game_dir/mods/vanilla/palette/dimm_pal/doom-pal.wad"

installed_bin=$(which prboom-plus 2>/dev/null || echo false)
compiled_bin="$HOME/src/prboom-plus/prboom2/build/prboom-plus"
set -x
$(if [ ! $installed_bin = "false" ]; then echo "prboom-plus"; else if [ -f "$compiled_bin" ]; then echo "$compiled_bin"; fi; fi) \
  -config "$param_game_dir"/config/prboom-plus/prboom-plus_vanilla.cfg \
  -vidmode gl \
  -complevel 17 \
  -width 1920 -height 1080 \
  -fullscreen \
  -geom 640x360f -aspect 16:9 \
  -iwad $param_game_dir/maps/iwads/$iwad.wad \
  -file $map_file $mod_files \
  -save ~/games/doom/savegames/$iwad/ \
  -skill 3 \
  -warp $(if [ $iwad == *"doom1"* ]; then echo "$(shuf -i 1-4 -n 1) $(shuf -i 1-8 -n 1)"; else echo "$(shuf -i 1-30 -n 1)"; fi)
set +x
