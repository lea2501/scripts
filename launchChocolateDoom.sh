#!/bin/sh
echo "Usage: $0 [game] [map]"

chocolate-doom -fullscreen -iwad ~/games/doom/wads/iwads/"$1".wad -file "$2" ~/games/doom/mods/vanilla/pk_doom_sfx/pk_doom_sfx_20120224.wad ~/games/doom/mods/vanilla/jovian_palette/JoyPal.wad -savedir ~/games/doom/savegames/"$1"/ -skill 3 -warp 01
