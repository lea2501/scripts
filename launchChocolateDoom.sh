#!/bin/bash

function show_usage() {
  printf "Usage: $0 [options [parameters]]\n"
  printf "\n"
  printf "Mandatory options:\n"
  printf " -i|--iwad                [doom | doom2 | tnt | plutonia | heretic | hexen | hexdd] (Mandatory)\n"
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
    find "$HOME"/games/doom/wads/{doom,doom2,tnt,plutonia,heretic,hexen}/vanilla/*/*.wad -type f 2>/dev/null | grep -v 'tex'  | grep -v 'fix' | grep -v 'res' | grep -v 'demo' | grep -v 'credits'
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

iwads=(doom doom2 tnt plutonia heretic hexen hexdd)
if [[ " "${iwads[@]}" " != *" $iwad "* ]]; then
  echo "$iwad: not recognized. Valid environments are:"
  echo "${iwads[@]/%/,}"
  exit 1
fi

mods=
base_dir="$HOME/games/doom"
doom_mods="$base_dir/mods/vanilla/pk_doom_sfx/pk_doom_sfx_20120224.wad $base_dir/mods/vanilla/jovian_palette/JoyPal.wad"
heretic_mods="$base_dir/mods/vanilla/dimm_pal/her-pal.wad"
hexen_mods="$base_dir/mods/vanilla/dimm_pal/hex-pal.wad"

case "$iwad" in
  *doom*) mods=$doom_mods; engine="chocolate-doom" ;;
  *tnt*)  mods=$doom_mods; engine="chocolate-doom" ;;
  *plutonia*) mods=$doom_mods; engine="chocolate-doom" ;;
  *heretic*) mods=$heretic_mods, engine="chocolate-heretic" ;;
  *hexen*) mods=$hexen_mods; engine="chocolate-hexen" ;;
  *hexdd*) mods=$hexen_mods; engine="chocolate-hexen" ;;
esac

$engine -fullscreen -config "$base_dir"/config/chocolate/config.ini -iwad "$base_dir"/wads/iwads/"$iwad".wad -file "$wad" $mods -savedir "$base_dir"/savegames/"$iwad"/ -skill 3 -warp 01
