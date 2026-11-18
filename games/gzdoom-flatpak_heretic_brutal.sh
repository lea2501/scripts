#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_common_paths.sh"
. "$SCRIPT_DIR/_common_mods_zdoom.sh"

game=heretic
mod_files="$game_dir/mods/vanilla/palette/dimm_pal/her-pal.wad \
  $mods_zdoom_brutal_heretic \
  $mods_zdoom_brutal_heretic_textures \
  $mods_zdoom_brutal_heretic_music \
  $mods_zdoom_bullet_time"

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
  -iwad "$(iwad_path "$game")" \
  -file "$pwad_file" $mod_files \
  -savedir "$game_dir"/savegames/"$game"/ \
  -skill 3 \
  -warp 1 1 \
  > /tmp/gzdoom.log
