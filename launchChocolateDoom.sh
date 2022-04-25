#!/bin/bash
if { [ -z "$1" ] || [ "$1" = -h ] || [ "$1" = --help ];}; then
  echo "Usage:"
  echo "  $(basename "$0") [game] [map]"
  echo ""
  echo "To list all available game and maps:"
  echo "  $(basename "$0") --list|-l"
  echo ""
  exit
fi
if { [ "$1" = --list ] || [ "$1" = -l ];}; then
  find ~/games/doom/wads/{doom,doom2,tnt,plutonia}/vanilla/*/*.wad ! -name *tex*.* ! -name *res*.* ! -name *fix.* ! -name *demo*.* ! -name *credits*.* -type f
  echo ""
  exit
fi

chocolate-doom -fullscreen -iwad ~/games/doom/wads/iwads/"$1".wad -file "$2" ~/games/doom/mods/vanilla/pk_doom_sfx/pk_doom_sfx_20120224.wad ~/games/doom/mods/vanilla/jovian_palette/JoyPal.wad -savedir ~/games/doom/savegames/"$1"/ -skill 3 -warp 01
