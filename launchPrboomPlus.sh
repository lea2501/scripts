#!/bin/sh
echo "Usage: $0 [game] [map]"

cd ~/src/prboom-plus/prboom2/ && ~/src/prboom-plus/prboom2/prboom-plus -config ~/src/prboom-plus/prboom2/prboom-plus.cfg -vidmode gl -complevel 17 -width 1920 -height 1080 -fullscreen -geom 640x360f -aspect 16:9 -iwad ~/games/doom/wads/iwads/doom2.wad -file "$1" ~/games/doom/mods/vanilla/pk_doom_sfx/pk_doom_sfx_20120224.wad ~/games/doom/mods/vanilla/jovian_palette/JoyPal.wad -save ~/games/doom/savegames/doom2/ -skill 3 -warp 01 && cd -
