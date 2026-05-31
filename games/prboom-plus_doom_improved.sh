#!/bin/sh

param_game_dir="$HOME/games/doom"
mod_files="$param_game_dir/mods/vanilla/sound/pk_doom_sfx/pk_doom_sfx_20120224.wad \
  $param_game_dir/mods/vanilla/palette/dimm_pal/doom-pal.wad \
  $param_game_dir/mods/vanilla/enhancements/vbright/vbright.wad \
  $param_game_dir/mods/vanilla/sound/softfx/softfx.wad \
  $param_game_dir/mods/vanilla/enhancements/smoothed/smoothed.wad"

get_random_map() {
  iwad=$(find "$HOME"/games/doom/maps/iwads/doom.wad "$HOME"/games/doom/maps/iwads/doom2.wad \
    "$HOME"/games/doom/maps/iwads/tnt.wad "$HOME"/games/doom/maps/iwads/plutonia.wad \
    2>/dev/null | shuf -n 1 | sed 's/.*\///' | sed 's/.wad//')
  map_file=$(find "$HOME"/games/doom/maps/"$iwad"/vanilla \
    "$HOME"/games/doom/maps/"$iwad"/nolimit \
    "$HOME"/games/doom/maps/"$iwad"/boom \
    "$HOME"/games/doom/maps/"$iwad"/zdoom \
    -type f -name '*.wad' 2>/dev/null | shuf -n 1)
  echo "INFO: Map file: $map_file"
  map_number=$("$(dirname "$0")"/doomGetRandomMapFromPwadWadtools.sh "$iwad" "$map_file")
}

get_random_map
while [ -z "$map_number" ]; do
  unset map_number
  get_random_map
done

bin=$(command -v prboom-plus 2>/dev/null || echo "$HOME/src/prboom-plus/prboom2/build/prboom-plus")
"$bin" \
  -config "$param_game_dir"/config/prboom-plus/prboom-plus_vanilla.cfg \
  -vidmode gl \
  -complevel 17 \
  -width 1920 -height 1080 \
  -fullscreen \
  -geom 640x360f -aspect 16:9 \
  -iwad "$param_game_dir"/maps/iwads/"$iwad".wad \
  -file "$map_file" $mod_files \
  -save "$param_game_dir"/savegames/"$iwad"/ \
  -skill 3 \
  -warp $map_number \
  > /tmp/prboom-plus.log
