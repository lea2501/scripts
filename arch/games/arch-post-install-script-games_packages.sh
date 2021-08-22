#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

cd || return

# roguelikes
echo \
  'nethack
rogue
stone-soup
cataclysm-dda
bsd-games
angband
infra-arcana
umoria' >packages_games.txt

# roguelikes
echo \
  'nethack
rogue
stone-soup
cataclysm-dda
bsd-games
angband
infra-arcana
umoria' >packages_games.txt

# doom
echo \
  'chocolate-doom
crispy-doom
prboom-plus
gzdoom' >packages_games.txt

# doom3
echo \
  'dhewm3' >packages_games.txt

# quake
echo \
  'quakespasm
qpakman' >packages_games.txt

# quake2
echo \
  'yamagi-quake2
yamagi-quake2-rogue
yamagi-quake2-xatrix' >packages_games.txt

# hexen2
echo \
  'hexen2' >packages_games.txt

# half life
echo \
  'xash3d-fwgs-git' >packages_games.txt

# build games
echo \
  'eduke32
nblood
raze' >packages_games.txt

# rtcw
echo \
  'iortcw-git
iortcw-data' >packages_games.txt

# marathon
echo \
  'alephone
alephone-marathon
alephone-marathon2
alephone-rubiconx
alephone-infinity' >packages_games.txt

# descent
echo \
  'd1x-rebirth
d2x-rebirth' >packages_games.txt

# diablo
echo \
  'devilutionx' >packages_games.txt

# uqm
echo \
  'uqm
uqm-sound
uqm-remix' >packages_games.txt

# minetest
echo \
  'minetest
minetest-server' >packages_games.txt

# applications
echo \
  'flacon
tsmuxer-git
jdownloader2
mangohud' >packages_games.txt

# torcs
echo \
  'torcs
torcs-data
speed-dreams-svn' >packages_games.txt

# emulators
echo \
  'dosbox
mgba
snes9x
mupen64plus
dolphin-emu
higan
mednafen
hatari
ppsspp
scummvm scummvm-tools
fs-uae fs-uae-launcher
sameboy
nestopia
pcsx2-git
yuzu-git' >packages_games.txt

# wine
echo \
  'wine wine-gecko wine-mono winetricks zenity vkd3d lutris' >packages_games.txt

# retroarch
echo \
  'retroarch libretro
libretro-dosbox-pure-git
libretro-beetle-saturn-git
libretro-opera-git' >packages_games.txt

# games
echo \
  'lbreakout2' >packages_games.txt

echo "Cleaning temporary data... "
for dir in ~/aur/*; do
  cd "$dir" || exit
  CURRENT_DIR=$(basename "$PWD")
  rm -rf ./pkg/ ./src/ ./*.tar.* ./*.zip* ./*.tgz* ./*.bz* ./"${CURRENT_DIR}"
done
echo "Cleaning temporary data... DONE"

paru -S $(cat packages_games.txt)

echo "Installing AUR packages... DONE"
