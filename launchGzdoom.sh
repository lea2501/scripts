#!/bin/bash

# fail if any commands fails
#set -e
# debug log
set -x

function show_usage() {
  printf "Usage: $0 [options [parameters]]\n"
  printf "\n"
  printf "Mandatory options:\n"
  printf " -i|--iwad                [doom | doom2 | tnt | plutonia | heretic | hexen | hexdd] (Mandatory)\n"
  printf "\n"
  printf "Options:\n"
  printf " -w|--wads                (wad or space separated wad list)\n"
  printf " -b|--brutal              (add brutal mod)\n"
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
    find "$HOME"/games/doom/wads/{doom,doom2,tnt,plutonia,heretic,hexen}/{vanilla,nolimit,boom,zdoom}/*/*.wad ! -name *tex*.* ! -name *res*.* ! -name *fix.* ! -name *demo*.* ! -name *credits*.* -type f
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
  --wad | -w)
    shift
    echo "wad: $1"
    wad=$1
    ;;
  --brutal | -b)
    shift
    mod_brutal=1
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
base_dir="$HOME"/games/doom
doom_mods="$base_dir/mods/vanilla/pk_doom_sfx/pk_doom_sfx_20120224.wad $base_dir/mods/vanilla/jovian_palette/JoyPal.wad $base_dir/mods/zdoom/vanilla_essence/vanilla_essence_4_3.pk3"
heretic_mods="$base_dir/mods/vanilla/dimm_pal/her-pal.wad $base_dir/mods/zdoom/vanilla_essence/vanilla_essence_4_3.pk3"
hexen_mods="$base_dir/mods/vanilla/dimm_pal/hex-pal.wad $base_dir/mods/zdoom/vanilla_essence/vanilla_essence_4_3.pk3"
if [ $mod_brutal = 1 ]; then
  doom_mods="$doom_mods $base_dir/mods/zdoom/brutal/brutal_doom/brutalv21.11.3.pk3"
  heretic_mods="$heretic_mods $base_dir/mods/zdoom/brutal/brutal_heretic/Heretic-Shadow_Collection/1_BRUTAL_HERETIC/BrutalHereticRPG_V5.0.pk3"
  hexen_mods="$hexen_mods $base_dir/mods/zdoom/brutal/brutal_hexen/Hexen/1_BRUTAL_HEXEN/BrutalHexenRPG_V4.7.pk3"
fi
doom_config="$base_dir"/config/zdoom/config_zdoom.ini
heretic_config="$base_dir"/config/zdoom/config_zdoom.ini
hexen_config="$base_dir"/config/zdoom/config_zdoom.ini

case "$iwad" in
  *doom*) mods=$doom_mods; config=$doom_config ;;
  *tnt*)  mods=$doom_mods; config=$doom_config ;;
  *plutonia*) mods=$doom_mods; config=$doom_config ;;
  *heretic*) mods=$heretic_mods; config=$heretic_config ;;
  *hexen*) mods=$hexen_mods; config=$hexen_config ;;
  *hexdd*) mods=$hexen_mods; config=$hexen_config ;;
esac

if [ -f ~/src/gzdoom/build/gzdoom ]; then
  cd ~/src/gzdoom/build/ && ./gzdoom -config "$config" -width 1920 -height 1080 -fullscreen -iwad "$base_dir"/wads/iwads/"$iwad".wad -file "$wad" $mods -savedir "$base_dir"/savegames/"$iwad"/ -skill 3 -warp 01 && cd -
else
  gzdoom -config "$config" -width 1920 -height 1080 -fullscreen -iwad "$base_dir"/wads/iwads/"$iwad".wad -file "$wad" $mods -savedir "$base_dir"/savegames/"$iwad"/ -skill 3 -warp 01
fi
