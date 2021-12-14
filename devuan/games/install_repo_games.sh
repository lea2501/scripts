#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi


cd || return

# roguelikes
$su apt-get -y install moria angband nethack-console cataclysm-dda-curses games-rogue

# doom
$su apt-get -y install chocolate-doom crispy-doom prboom-plus glbsp zdbsp

# doom3
$su apt-get -y install dhewm3 dhewm3-doom3 dhewm3-d3xp rbdoom3bfg

# quake
$su apt-get -y install quakespasm

# quake2
$su apt-get -y install yamagi-quake2

# hexen2
$su apt-get -y install uhexen2

# rtcw
$su apt-get -y install rtcw

# descent
#$su apt-get -y install d1x-rebirth d2x-rebirth

# uqm
$su apt-get -y install uqm

# minetest
$su apt-get -y install minetest minetest-server minetest-mod-basic-materials minetest-mod-homedecor minetest-mod-nether minetest-mod-player-3d-armor minetest-mod-mobs-redo

# tor
$su apt-get -y install tor obfs4proxy

# torcs
$su apt-get -y install torcs torcs-data

# emulators
$su apt-get -y install dosbox mgba-sdl mednafen mednaffe higan hatari scummvm scummvm-tools fs-uae fs-uae-launcher nestopia mame mame-tools pcsxr pcsx2

# wine
$su apt-get -y install wine wine64

# retroarch
#$su apt-get -y install retroarch

# other games
$su apt-get -y install lbreakout2 micropolis lincity

echo "Installing games... DONE"