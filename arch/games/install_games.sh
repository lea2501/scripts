#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

cd || return

# roguelikes
paru -S nethack rogue stone-soup cataclysm-dda bsd-games angband umoria

# doom
paru -S chocolate-doom crispy-doom prboom-plus gzdoom

# doom3
paru -S dhewm3

# quake
paru -S quakespasm qpakman

# quake2
paru -S yamagi-quake2 yamagi-quake2-rogue yamagi-quake2-xatrix

# hexen2
#paru -S hexen2

# half life
#paru -S xash3d-fwgs-git

# build games
paru -S eduke32 nblood raze

# rtcw
#paru -S iortcw-git iortcw-data

# marathon
#paru -S alephone alephone-marathon alephone-marathon2 alephone-rubiconx alephone-infinity

# descent
paru -S d1x-rebirth d2x-rebirth

# diablo
paru -S devilutionx

# uqm
#paru -S uqm uqm-sound uqm-remix

# minetest
paru -S minetest minetest-server

# applications
paru -S flacon tsmuxer-git jdownloader2 mangohud

# torcs
paru -S torcs torcs-data

# emulators
paru -S dosbox dolphin-emu higan mednafen hatari ppsspp scummvm scummvm-tools sameboy nestopia

# wine
#paru -S wine wine-gecko wine-mono winetricks zenity vkd3d lutris

# retroarch
#paru -S retroarch libretro libretro-dosbox-pure-git libretro-beetle-saturn-git libretro-opera-git

# games
#paru -S lbreakout2

echo "Installing games... DONE"
