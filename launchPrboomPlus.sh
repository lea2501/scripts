#!/bin/sh
if [[ -z $1 ]]; then
      echo "Usage: $0 [game] [map]"
      echo "Find available wads with:"
      echo "  $ find ~/games/doom/wads/{doom,doom2,tnt,plutonia}/{vanilla,nolimit,boom}/*/*.wad ! -name *tex*.* ! -name *res*.* ! -name *fix.* ! -name *demo*.* ! -name *credits*.* -type f"
      exit
fi

cd ~/src/prboom-plus/prboom2/ && ~/src/prboom-plus/prboom2/prboom-plus -config ~/src/prboom-plus/prboom2/prboom-plus.cfg -vidmode gl -complevel 17 -width 1920 -height 1080 -fullscreen -geom 640x360f -aspect 16:9 -iwad ~/games/doom/wads/iwads/"$1".wad -file "$2" ~/games/doom/mods/vanilla/pk_doom_sfx/pk_doom_sfx_20120224.wad ~/games/doom/mods/vanilla/jovian_palette/JoyPal.wad -save ~/games/doom/savegames/"$1"/ -skill 3 -warp 01 && cd -
