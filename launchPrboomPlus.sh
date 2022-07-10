#!/bin/bash

function show_usage() {
  printf "Usage: $0 [options [parameters]]\n"
  printf "\n"
  printf "Mandatory options:\n"
  printf " -i|--iwad                [doom | doom2 | tnt | plutonia] (Mandatory)\n"
  printf "\n"
  printf "Options:\n"
  printf " -w|--wads                (wad or space separated wad list)\n"
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
    find "$HOME"/games/doom/wads/{doom,doom2,tnt,plutonia}/{vanilla,nolimit,boom}/*/*.wad -type f 2>/dev/null | grep -v 'tex'  | grep -v 'fix' | grep -v 'res' | grep -v 'demo' | grep -v 'credits'
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

iwads=(doom doom2 tnt plutonia)
if [[ " "${iwads[@]}" " != *" $iwad "* ]]; then
  echo "$iwad: not recognized. Valid environments are:"
  echo "${iwads[@]/%/,}"
  exit 1
fi

mods=
base_dir="$HOME/games/doom"
doom_mods="$base_dir/mods/vanilla/pk_doom_sfx/pk_doom_sfx_20120224.wad $base_dir/mods/vanilla/jovian_palette/JoyPal.wad"
doom_config="$base_dir"/config/prboom-plus/prboom-plus_vanilla.cfg

case "$iwad" in
  *doom*) mods=$doom_mods; config=$doom_config ;;
  *tnt*)  mods=$doom_mods; config=$doom_config ;;
  *plutonia*) mods=$doom_mods; config=$doom_config ;;
esac

#if [ -f ~/src/prboom-plus/prboom2/prboom-plus ]; then
#  cd ~/src/prboom-plus/prboom2/ && ./prboom-plus -config "$config" -vidmode gl -complevel 17 -width 1920 -height 1080 -fullscreen -aspect 16:9 -iwad "$base_dir"/wads/iwads/"$iwad".wad -file "$wad" "$mods" -save "$base_dir"/savegames/"$iwad"/ -skill 3 -warp 01 && cd -
#else
  prboom-plus -config "$config" -vidmode gl -complevel 17 -width 1920 -height 1080 -fullscreen -aspect 16:9 -iwad "$base_dir"/wads/iwads/"$iwad".wad -file "$wad" $mods -save "$base_dir"/savegames/"$iwad"/ -skill 3 -warp 01
#fi
