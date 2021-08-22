#!/bin/ksh

# fail if any commands fails
set -e
# debug log
#set -x

username=$USER

cloneRepo() {
  mkdir -p "$HOME"/src
  cd "$HOME"/src || return
  if [[ ! -e "$1" ]];then
    git clone https://aur.archlinux.org/"$1".git
    cd "$1" || return
  else
    cd "$1" || return
    git pull
  fi
}

options=(Y y N n)

# Section: games
read -rp "install games?: (y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  cd || return

  echo "Installing games..."

  # roguelikes
  echo \
    'angband
moria
nethack
cataclysm-dda' >"$HOME"/packages_games.txt

  # doom
  echo \
    'chocolate-doom
prboom-plus
gzdoom' >>"$HOME"/packages_games.txt

  # doom3
  echo \
    'dhewm3' >>"$HOME"/packages_games.txt

  # quake
  echo \
    'quakespasm' >>"$HOME"/packages_games.txt

  # quake2
  echo \
    'yquake2' >>"$HOME"/packages_games.txt

  # hexen2
  echo \
    'uhexen2' >>"$HOME"/packages_games.txt

  # descent
  echo \
    'dxx-rebirth' >>"$HOME"/packages_games.txt

    # diablo
  echo \
    'devilutionx' >>"$HOME"/packages_games.txt

    # build engine
  echo \
    'eduke32 nblood' >>"$HOME"/packages_games.txt

  # uqm
  echo \
    'uqm uqm-content uqm-voice uqm-threedomusic' >>"$HOME"/packages_games.txt

  # minetest
  echo \
    'minetest' >>"$HOME"/packages_games.txt

  # tor
  echo \
    'tor tor-browser' >>"$HOME"/packages_games.txt

  # emulators
  echo \
    'dosbox
gambatte
dolphin
mednafen
higan
hatari
ppsspp
scummvm scummvm-tools
fs-uae fs-uae-launcher
nestopia
sameboy
mame' >>"$HOME"/packages_games.txt

  # retroarch
  echo \
    'retroarch' >>"$HOME"/packages_games.txt

  # other games
  echo \
    'chromium-bsu
devilutionx
lbreakout2
micropolis
lincity' >>"$HOME"/packages_games.txt

  sudo apt-get -y install $(cat "$HOME"/packages_games.txt)

  echo "Installing games... DONE"
fi