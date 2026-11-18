#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/_common_paths.sh"
. "$SCRIPT_DIR/_common_mods_zdoom.sh"
iwad=
wad=
mod_brutal=0
mod_beautiful=0

function show_usage() {
  printf "Usage: $0 [options [parameters]]\n"
  printf "\n"
  printf "Mandatory options:\n"
  printf " -i|--iwad                [doom | doom2 | tnt | plutonia | heretic | hexen | hexdd] (Mandatory)\n"
  printf "\n"
  printf "Options:\n"
  printf " -w|--wads                (wad or space separated wad list)\n"
  printf " -b|--brutal              (Doom: Community Expansion 21.50.1; Heretic: 6.5; Hexen: 8.0 beta)\n"
  printf " --beautiful             (add Beautiful Doom 7.1.6 for Doom)\n"
  printf "\n"
  printf " -l|--list, list available wad files\n"
  printf " -h|--help, Print help\n"

  exit
}

if [ -z "$1" ]; then
  show_usage
fi
if { [ "$1" = --help ] || [ "$1" = -h ];}; then
  show_usage
fi
if { [ "$1" = --list ] || [ "$1" = -l ];}; then
    find "$HOME"/games/doom/maps/{doom,doom2,tnt,plutonia,heretic,hexen}/{vanilla,limit-removing,boom,zdoom}/*/*.wad -type f 2>/dev/null | grep -v 'tex'  | grep -v 'fix' | grep -v 'res' | grep -v 'demo' | grep -v 'credits'
    echo ""
    exit
fi

while [ -n "$1" ]; do
  case "$1" in
  --iwad | -i)
    shift
    echo "iwad: $1"
    iwad=$1
    ;;
  --wad | --wads | -w)
    shift
    echo "wad: $1"
    wad=$1
    ;;
  --brutal | -b)
    mod_brutal=1
    ;;
  --beautiful)
    mod_beautiful=1
    ;;
  *)
    show_usage
    ;;
  esac
  shift
done

if [ -z "$iwad" ]; then
  show_usage
fi
if [ -z "$wad" ]; then
  show_usage
fi

iwads=(doom doom2 tnt plutonia heretic hexen hexdd)
if [[ " "${iwads[@]}" " != *" $iwad "* ]]; then
  echo "$iwad: not recognized. Valid environments are:"
  echo "${iwads[@]/%/,}"
  exit 1
fi

mods=
base_dir="$game_dir"
iwad_file="$base_dir/maps/iwads/$iwad.wad"
if [ ! -f "$iwad_file" ]; then
  iwad_file="$base_dir/maps/original/$iwad.wad"
fi
doom_mods="$base_dir/mods/vanilla/sound/pk_doom_sfx/pk_doom_sfx_20120224.wad $base_dir/mods/vanilla/palette/jovian_palette/JovPal.wad $base_dir/mods/zdoom/enhancements/vanilla_essence/vanilla_essence_4_3.pk3"
heretic_mods="$base_dir/mods/vanilla/palette/dimm_pal/her-pal.wad $base_dir/mods/zdoom/enhancements/vanilla_essence/vanilla_essence_4_3.pk3"
hexen_mods="$base_dir/mods/vanilla/palette/dimm_pal/hex-pal.wad $base_dir/mods/zdoom/enhancements/vanilla_essence/vanilla_essence_4_3.pk3"
if [ "$mod_brutal" = 1 ]; then
  # Preserve this launcher's Community Expansion branch, using the newest local release.
  doom_mods="$doom_mods $base_dir/mods/zdoom/brutal/brutal_doom_community_expansion/brutalv21.50.1.pk3"
  heretic_mods="$heretic_mods $mods_zdoom_brutal_heretic"
  hexen_mods="$hexen_mods $mods_zdoom_brutal_hexen"
fi
if [ "$mod_beautiful" = 1 ]; then
  doom_mods="$doom_mods $mods_zdoom_beautiful"
  heretic_mods="$base_dir/mods/vanilla/palette/dimm_pal/her-pal.wad $base_dir/mods/zdoom/enhancements/vanilla_essence/vanilla_essence_4_3.pk3"
  hexen_mods="$base_dir/mods/vanilla/palette/dimm_pal/hex-pal.wad $base_dir/mods/zdoom/enhancements/vanilla_essence/vanilla_essence_4_3.pk3"
fi
doom_config="$base_dir"/config/zdoom/config_zdoom.ini
heretic_config="$base_dir"/config/zdoom/config_zdoom_heretic.ini
hexen_config="$base_dir"/config/zdoom/config_zdoom_hexen.ini

case "$iwad" in
  *doom*) mods=$doom_mods; config=$doom_config ;;
  *tnt*)  mods=$doom_mods; config=$doom_config ;;
  *plutonia*) mods=$doom_mods; config=$doom_config ;;
  *heretic*) mods=$heretic_mods; config=$heretic_config ;;
  *hexen*) mods=$hexen_mods; config=$hexen_config ;;
  *hexdd*) mods=$hexen_mods; config=$hexen_config ;;
esac

if [ -f ~/src/gzdoom/build/gzdoom ]; then
  cd ~/src/gzdoom/build/ && ./gzdoom -config "$config" -width 1920 -height 1080 -fullscreen -iwad "$iwad_file" -file "$wad" $mods -savedir "$base_dir"/savegames/"$iwad"/ -skill 3 -warp 01 && cd -
else
  gzdoom -config "$config" -width 1920 -height 1080 -fullscreen -iwad "$iwad_file" -file "$wad" $mods -savedir "$base_dir"/savegames/"$iwad"/ -skill 3 -warp 01
fi
