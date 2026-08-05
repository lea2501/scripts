#!/bin/sh
set -x

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_common_paths.sh"
. "$SCRIPT_DIR/_common_mods_vanilla.sh"

mod_files="$mods_vanilla_doom_improved"

get_random_map() {
  iwad=$(find "$(iwad_path doom)" "$(iwad_path doom2)" \
    "$(iwad_path tnt)" "$(iwad_path plutonia)" \
    2>/dev/null | shuf -n 1 | sed 's/.*\///' | sed 's/.wad//')
  map_file=$(find "$game_dir"/maps/"$iwad"/vanilla \
    "$game_dir"/maps/"$iwad"/nolimit \
    "$game_dir"/maps/"$iwad"/boom \
    "$game_dir"/maps/"$iwad"/zdoom \
    -type f -name '*.wad' 2>/dev/null | shuf -n 1)
  echo "INFO: Map file: $map_file"
  map_number=$("$SCRIPT_DIR"/doomGetRandomMapFromPwadWadtools.sh "$iwad" "$map_file")
}

get_random_map
while [ -z "$map_number" ]; do
  unset map_number
  get_random_map
done

bin=$(game_bin "$HOME/src/prboom-plus/prboom2/prboom-plus" prboom-plus) || exit 1
"$bin" \
  -config "$game_dir"/config/prboom-plus/prboom-plus_vanilla.cfg \
  -vidmode gl \
  -complevel 17 \
  -width 1920 -height 1080 \
  -fullscreen \
  -geom 640x360f -aspect 16:9 \
  -iwad "$(iwad_path "$iwad")" \
  -file "$map_file" $mod_files \
  -save "$game_dir"/savegames/"$iwad"/ \
  -skill 3 \
  -warp $map_number \
  > /tmp/prboom-plus.log
