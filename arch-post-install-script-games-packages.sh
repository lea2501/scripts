#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

# games and personal packages

read -rp "Install roguelike games?: (y|n)" installRoguelikes
read -rp "Install doom source ports?: (y|n)" installDoom
read -rp "Install quake 1 source ports?: (y|n)" installQuake
read -rp "Install quake 2 source ports?: (y|n)" installQuake2
read -rp "Install hexen 2 source ports?: (y|n)" installHexen2
read -rp "Install marathon source ports?: (y|n)" installMarathon
read -rp "Install descent source ports?: (y|n)" installDescent
read -rp "Install diablo source ports?: (y|n)" installDiablo
read -rp "Install doom 3 source ports?: (y|n)" installDoom3
read -rp "Install urquan masters?: (y|n)" installUqm
read -rp "Install build games source port?: (y|n)" installBuildGames
read -rp "Install return to castle wolfestein source port?: (y|n)" installIortcw
read -rp "Install extra tools?: (y|n)" installExtraTools
read -rp "Install racing games?: (y|n)" installRacingGames
read -rp "Install console emulators?: (y|n)" installEmulators
read -rp "Install other games?: (y|n)" installOtherGames
read -rp "Install ps5 joystick driver?: (y|n)" installJoystickPs5

echo "Installing games packages..."
if [ "$installRoguelikes" = "y" ]; then
  sudo pacman -Sy --noconfirm angband
  sudo pacman -Sy --noconfirm nethack
  sudo pacman -Sy --noconfirm rogue
  sudo pacman -Sy --noconfirm stone-soup
  sudo pacman -Sy --noconfirm cataclysm-dda
  sudo pacman -Sy --noconfirm bsd-games
fi

if [ "$installEmulators" = "y" ]; then
  sudo pacman -Sy --noconfirm dosbox
  sudo pacman -Sy --noconfirm dolphin-emu
  sudo pacman -Sy --noconfirm mednafen
  sudo pacman -Sy --noconfirm hatari
  sudo pacman -Sy --noconfirm ppsspp
  sudo pacman -Sy --noconfirm scummvm scummvm-tools
  sudo pacman -Sy --noconfirm fs-uae fs-uae-launcher
fi

if [ "$installOtherGames" = "y" ]; then
  sudo pacman -Sy --noconfirm lbreakout2
  sudo pacman -Sy --noconfirm lincity-ng
fi
echo "Installing games packages... DONE"

# aur packages
echo "Creating user 'aur' directory..."
mkdir -p ~/aur
echo "Creating user 'aur' directory... DONE"

echo "Installing AUR packages..."
if [ "$installDoom" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/vtable-dumper.git
  cd vtable-dumper || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/abi-dumper.git
  cd abi-dumper || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/abi-compliance-checker.git
  cd abi-compliance-checker || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/zmusic.git
  cd zmusic || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/gzdoom.git
  cd gzdoom || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/chocolate-doom.git
  cd chocolate-doom || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/crispy-doom.git
  cd crispy-doom || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/prboom-plus.git
  cd prboom-plus || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/pygtk.git
  cd pygtk || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/bsp.git
  cd bsp || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/k8vavoom-git.git
  cd k8vavoom-git || return
  makepkg -sic --noconfirm
fi

if [ "$installQuake" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/quakespasm.git
  cd quakespasm || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/tyrquake-git.git
  cd tyrquake-git || return
  makepkg -sic --noconfirm

  cd ~/games || return
  mkdir -p quakeinjector
  cd ~/quakeinjector || return
  mkdir -p bin
  mkdir -p downloads
  cd ~/games/quakeinjector/bin || return
  curl -O -L "$(curl -s https://api.github.com/repos/hrehfeld/QuakeInjector/releases/latest | jq -r ".assets[] | select(.name | test(\"quakeinjector\")) | .browser_download_url")"
  unzip quakeinjector*.zip
fi

if [ "$installQuake2" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/yamagi-quake2.git
  cd yamagi-quake2 || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/yamagi-quake2-rogue.git
  cd yamagi-quake2 || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/yamagi-quake2-xatrix.git
  cd yamagi-quake2-xatrix || return
  makepkg -sic --noconfirm
fi

if [ "$installHexen2" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/hexen2.git
  cd hexen2 || return
  makepkg -sic --noconfirm
fi

if [ "$installMarathon" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/alephone.git
  cd alephone || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/alephone-marathon.git
  cd alephone-marathon || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/alephone-marathon2.git
  cd alephone-marathon2 || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/alephone-rubiconx.git
  cd alephone-rubiconx || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/alephone-infinity.git
  cd alephone-infinity || return
  makepkg -sic --noconfirm
fi

if [ "$installDescent" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/d1x-rebirth.git
  cd d1x-rebirth || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/d2x-rebirth.git
  cd d2x-rebirth || return
  makepkg -sic --noconfirm
fi

if [ "$installDiablo" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/devilutionx.git
  cd devilutionx || return
  makepkg -sic --noconfirm
fi

if [ "$installDoom3" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/dhewm3.git
  cd dhewm3 || return
  makepkg -sic --noconfirm
fi

if [ "$installUqm" = "y" ]; then
  sudo pacman -Sy --noconfirm uqm
  cd ~/aur || return
  git clone https://aur.archlinux.org/uqm-sound.git
  cd uqm-sound || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/uqm-remix.git
  cd uqm-sound || return
  makepkg -sic --noconfirm
#  cd ~/aur || return
#  git clone https://aur.archlinux.org/uqm-hd.git
#  cd uqm-sound || return
#  makepkg -sic --noconfirm
#  cd ~/aur || return
#  git clone https://aur.archlinux.org/uqm-hd-sound.git
#  cd uqm-sound || return
#  makepkg -sic --noconfirm
fi

if [ "$installBuildGames" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/eduke32.git
  cd eduke32 || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/nblood.git
  cd nblood || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/raze.git
  cd raze || return
  makepkg -sic --noconfirm
fi

if [ "$installRoguelikes" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/angband-git.git
  cd angband-git || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/infra-arcana.git
  cd infra-arcana || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/termcap.git
  cd termcap || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/umoria.git
  cd umoria || return
  makepkg -sic --noconfirm

  sudo pacman -Sy --noconfirm autoconf
  sudo pacman -Sy --noconfirm gcc
  sudo pacman -Sy --noconfirm libx11
  cd ~/aur || return
  git clone https://aur.archlinux.org/ncurses5-compat-libs.git
  cd ncurses5-compat-libs || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/libstdc++296.git
  cd libstdc++296 || return
  makepkg -sic --noconfirm
  mkdir -p ~/src
  cd ~/src || return
  git clone https://github.com/sulkasormi/frogcomposband.git
  cd frogcomposband || return
  sh autogen.sh
  ./configure --prefix "$HOME"/.frogcomposband
  make clean
  make
  make install
fi

if [ "$installIortcw" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/iortcw-data.git
  cd iortcw-data || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/iortcw-git.git
  cd iortcw-git || return
  makepkg -sic --noconfirm
fi

if [ "$installExtraTools" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/flacon.git
  cd flacon || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/jdownloader2.git
  cd jdownloader2 || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/mkcue.git
  cd mkcue || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/tor-browser.git
  cd tor-browser || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/xbindkeys.git
  cd xbindkeys || return
  makepkg -sic --noconfirm
fi

if [ "$installRacingGames" = "y" ]; then
  cd ~/aur || return
  git clone https://aur.archlinux.org/plib.git
  cd plib || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/speed-dreams-svn.git
  cd speed-dreams-svn || return
  makepkg -sic --noconfirm

  cd ~/aur || return
  git clone https://aur.archlinux.org/torcs-data.git
  cd torcs-data || return
  makepkg -sic --noconfirm
  cd ~/aur || return
  git clone https://aur.archlinux.org/torcs.git
  cd torcs || return
  makepkg -sic --noconfirm
fi

# joysticks
if [ "$installJoystickPs5" = "y" ]; then
  sudo pacman -Sy --noconfirm joyutils

  cd ~/aur || return
  git clone https://aur.archlinux.org/hid-playstation-dkms.git
  cd hid-playstation-dkms || return
  makepkg -sic --noconfirm
fi

echo "Cleaning temporary data... "
for dir in ~/aur/*; do
  cd "$dir" || exit
  CURRENT_DIR=$(basename "$PWD")
  rm -rf ./pkg/ ./src/ ./*.tar.* ./*.zip* ./*.tgz* ./*.bz* ./"${CURRENT_DIR}"
done
echo "Cleaning temporary data... DONE"

echo "Installing AUR packages... DONE"
