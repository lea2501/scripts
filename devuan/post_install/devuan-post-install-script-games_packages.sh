#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

echo "Installing games..."

# roguelikes
echo \
  'angband
moria
nethack-console
cataclysm-dda-curses
games-rogue' >packages_games.txt

# doom
echo \
  'chocolate-doom
crispy-doom
prboom-plus
glbsp zdbsp' >>packages_games.txt

# doom3
echo \
  'dhewm3 dhewm3-doom3 dhewm3-d3xp
rbdoom3bfg' >>packages_games.txt

# quake
echo \
  'quakespasm' >>packages_games.txt

# quake2
echo \
  'yamagi-quake2' >>packages_games.txt

# hexen2
echo \
  'uhexen2' >>packages_games.txt

# rtcw
echo \
  'rtcw' >>packages_games.txt

# descent
echo \
  'd1x-rebirth
d2x-rebirth' >>packages_games.txt

# uqm
echo \
  'uqm uqm-content uqm-voice uqm-music' >>packages_games.txt

# minetest
echo \
  'minetest minetest-server' >>packages_games.txt

# tor
echo \
  'tor obfs4proxy' >>packages_games.txt

# torcs
echo \
  'torcs torcs-data' >>packages_games.txt

# emulators
echo \
  'dosbox
mgba-sdl
dolphin-emu
mednafen
higan
hatari
scummvm scummvm-tools
fs-uae fs-uae-launcher
nestopia
mame mame-extra mame-tools' >>packages_games.txt

# wine
echo \
  'wine wine64 dxvk' >>packages_games.txt

# retroarch
echo \
  'retroarch' >>packages_games.txt

# other games
echo \
  'lbreakout2
micropolis
lincity' >>packages_games.txt

sudo apt-get -y install $(cat packages_games.txt)

echo "Installing games... DONE"
