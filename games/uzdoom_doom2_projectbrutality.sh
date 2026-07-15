#!/bin/sh
set -x

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_common_paths.sh"
. "$SCRIPT_DIR/_common_mods_vanilla.sh"
. "$SCRIPT_DIR/_common_mods_zdoom.sh"

game=doom2
compiled_bin="$HOME/src/UZDoom/build/uzdoom"
uzdoom_bin="$compiled_bin"
if [ ! -x "$uzdoom_bin" ]; then uzdoom_bin=$(command -v uzdoom 2>/dev/null || echo uzdoom); fi
mod_files="$mods_vanilla_doom $mods_zdoom_project_brutality $mods_zdoom_bullet_time"

pwad_file=$(find "$game_dir"/maps/"$game"/vanilla \
  "$game_dir"/maps/"$game"/nolimit \
  "$game_dir"/maps/"$game"/boom \
  "$game_dir"/maps/"$game"/zdoom \
  -type f \( -name '*.wad' -o -name '*.pk3' \) 2>/dev/null | shuf -n 1)

if [ -d /usr/share/uzdoom/ ]; then cd /usr/share/uzdoom/ || return; fi
if [ -d /usr/local/share/games/doom/ ]; then cd /usr/local/share/games/doom/ || return; fi
if [ -d "$HOME/src/UZDoom/build/" ]; then cd "$HOME/src/UZDoom/build/" || return; fi
"$uzdoom_bin" -config "$game_dir"/config/zdoom/config_zdoom.ini \
  -width 1920 -height 1080 \
  -fullscreen \
  -iwad "$(iwad_path "$game")" \
  -file "$pwad_file" $mod_files \
  -savedir "$game_dir"/savegames/"$game"/ \
  -skill 3 \
  -warp 1 \
  > /tmp/uzdoom.log
