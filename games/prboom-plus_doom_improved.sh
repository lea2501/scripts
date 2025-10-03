#!/bin/sh

param_game_dir="$HOME/games/doom"
mod_files="$param_game_dir/mods/vanilla/sound/pk_doom_sfx/pk_doom_sfx_20120224.wad $param_game_dir/mods/vanilla/palette/dimm_pal/doom-pal.wad $param_game_dir/mods/vanilla/enhancements/vbright/vbright.wad $param_game_dir/mods/vanilla/sound/softfx/softfx.wad $param_game_dir/mods/vanilla/enhancements/smoothed/smoothed.wad"

get_random_map() {
	iwad=$(find /home/lea/games/doom/maps/iwads/{doom.wad,doom2.wad,tnt.wad,plutonia.wad} | shuf -n 1 | sed 's/.*\///' | sed 's/.wad//')
    map_file=$(find $HOME/games/doom/maps/$iwad/{vanilla,nolimit,boom,zdoom}/*/*.wad -type f 2>/dev/null | shuf -n 1)
    echo "INFO: Map file: $map_file"
    map_number=$("$(dirname "$0")"/doomGetRandomMapFromPwadWadtools.sh $iwad $map_file)
}

get_random_map
while [ -z $map_number ]
do
    unset map_number
    get_random_map
done

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
  -warp ${map_number} \
  > /tmp/prboom-plus.log
set +x
