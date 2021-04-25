#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

# games and personal packages

read -rp "Install everything?: (y|n)" installEverything
if [ "$installEverything" = "y" ]; then
  installRoguelikes="y"
  installDoom="y"
  installDoom3="y"
  installQuake="y"
  installQuake2="y"
  installHexen2="y"
  installBuildGames="y"
  installIortcw="y"
  installMarathon="y"
  installDescent="y"
  installDiablo="y"
  installUqm="y"
  installExtraTools="y"
  installRacingGames="y"
  installEmulators="y"
  installOtherGames="y"
  installJoystickPs5="y"
elif [ "$installEverything" = "n" ]; then
  read -rp "Install roguelike games?: (y|n)" installRoguelikes
  read -rp "Install doom source ports?: (y|n)" installDoom
  read -rp "Install doom 3 source ports?: (y|n)" installDoom3
  read -rp "Install quake 1 source ports?: (y|n)" installQuake
  read -rp "Install quake 2 source ports?: (y|n)" installQuake2
  read -rp "Install hexen 2 source ports?: (y|n)" installHexen2
  read -rp "Install build games source port?: (y|n)" installBuildGames
  read -rp "Install return to castle wolfenstein source port?: (y|n)" installIortcw
  read -rp "Install marathon source ports?: (y|n)" installMarathon
  read -rp "Install descent source ports?: (y|n)" installDescent
  read -rp "Install diablo source ports?: (y|n)" installDiablo
  read -rp "Install urquan masters?: (y|n)" installUqm
  read -rp "Install extra tools?: (y|n)" installExtraTools
  read -rp "Install racing games?: (y|n)" installRacingGames
  read -rp "Install console emulators?: (y|n)" installEmulators
  read -rp "Install other games?: (y|n)" installOtherGames
  read -rp "Install ps5 joystick driver?: (y|n)" installJoystickPs5
fi

cloneAurAndCompile() {
  mkdir -p ~/aur
  cd ~/aur || return
  if [ ! -d "$1" ]; then
    git clone https://aur.archlinux.org/"$1".git
  else
    cd "$1" && git pull
  fi
  makepkg -sic --noconfirm
}

cloneAurAndCompileSkipChecks() {
  mkdir -p ~/aur
  cd ~/aur || return
  if [ ! -d "$1" ]; then
    git clone https://aur.archlinux.org/"$1".git
  else
    cd "$1" && git pull
  fi
  makepkg -sic --noconfirm --skippgpcheck
}

cloneSrc() {
  mkdir -p ~/src
  cd ~/src || return
  if [ ! -d "$1" ]; then
    git clone "$2"
  else
    cd "$1" && git pull
  fi
}

echo "Installing games packages..."
if [ "$installRoguelikes" = "y" ]; then
  #sudo pacman -Sy --noconfirm angband
  sudo pacman -Sy --noconfirm nethack
  sudo pacman -Sy --noconfirm rogue
  sudo pacman -Sy --noconfirm stone-soup
  sudo pacman -Sy --noconfirm cataclysm-dda
  sudo pacman -Sy --noconfirm bsd-games
  cloneAurAndCompile angband-git
  cloneAurAndCompile infra-arcana
  cloneAurAndCompile termcap
  cloneAurAndCompile umoria
  sudo pacman -Sy --noconfirm autoconf
  sudo pacman -Sy --noconfirm gcc
  sudo pacman -Sy --noconfirm libx11
  gpg --keyserver keys.gnupg.net --recv-keys 702353E0F7E48EDB
  cloneAurAndCompile ncurses5-compat-libs
  #cloneAurAndCompile libstdc++296 # Edit PKGBUILD manually (https://aur.archlinux.org/packages/libstdc%2B%2B296/)
  cloneSrc frogcomposband https://github.com/sulkasormi/frogcomposband.git
  #cd frogcomposband && sh autogen.sh && ./configure --prefix "$HOME"/.frogcomposband && make clean && make && make install # run this after installing libstdc++296 AUR package
fi

echo "Installing AUR packages..."
if [ "$installDoom" = "y" ]; then
  cloneAurAndCompile vtable-dumper
  cloneAurAndCompile abi-dumper
  cloneAurAndCompile abi-compliance-checker
  cloneAurAndCompile zmusic
  cloneAurAndCompile gzdoom
  cloneAurAndCompileSkipChecks chocolate-doom
  cloneAurAndCompile crispy-doom
  cloneAurAndCompile prboom-plus
  cloneSrc prboom-plus https://github.com/coelckers/prboom-plus.git
  cd ~/src/prboom-plus/prboom2 && cmake . && make
  #cloneAndCompile pygtk
  #cloneAndCompile bsp
  #cloneAndCompile k8vavoom-git
fi

if [ "$installDoom3" = "y" ]; then
  cloneAurAndCompile dhewm3
fi

if [ "$installQuake" = "y" ]; then
  cloneAurAndCompile quakespasm
  #cloneAndCompile tyrquake-git

  cd ~/games || return
  mkdir -p quakeinjector
  cd ~/games/quakeinjector || return
  mkdir -p bin
  mkdir -p downloads
  cd ~/games/quakeinjector/bin || return
  curl -O -L "$(curl -s https://api.github.com/repos/hrehfeld/QuakeInjector/releases/latest | jq -r ".assets[] | select(.name | test(\"quakeinjector\")) | .browser_download_url")"
  unzip quakeinjector*.zip
fi

if [ "$installQuake2" = "y" ]; then
  cloneAurAndCompile yamagi-quake2
  cloneAurAndCompile yamagi-quake2-rogue
  cloneAurAndCompile yamagi-quake2-xatrix
fi

if [ "$installHexen2" = "y" ]; then
  cloneAurAndCompile hexen2
fi

if [ "$installBuildGames" = "y" ]; then
  cloneAurAndCompile eduke32
  cloneAurAndCompile nblood
  cloneAurAndCompile raze
fi

if [ "$installIortcw" = "y" ]; then
  cloneAurAndCompile iortcw-data
  cloneAurAndCompile iortcw-git
fi

if [ "$installMarathon" = "y" ]; then
  cloneAurAndCompile alephone
  cloneAurAndCompile alephone-marathon
  cloneAurAndCompile alephone-marathon2
  cloneAurAndCompile alephone-rubiconx
  cloneAurAndCompile alephone-infinity
fi

if [ "$installDescent" = "y" ]; then
  cloneAurAndCompile d1x-rebirth
  cloneAurAndCompile d2x-rebirth
fi

if [ "$installDiablo" = "y" ]; then
  cloneAurAndCompile devilutionx
fi

if [ "$installUqm" = "y" ]; then
  sudo pacman -Sy --noconfirm uqm
  cloneAurAndCompile uqm-sound
  cloneAurAndCompile uqm-remix
  #cloneAurAndCompile uqm-hd
  #cloneAurAndCompile uqm-hd-sound
fi

if [ "$installExtraTools" = "y" ]; then
  cloneAurAndCompile flacon
  cloneAurAndCompile jdownloader2
  #cloneAurAndCompile mkcue
  cloneAurAndCompile tor-browser
  cloneAurAndCompile xbindkeys
fi

if [ "$installRacingGames" = "y" ]; then
  cloneAurAndCompile plib
  cloneAurAndCompile speed-dreams-svn
  cloneAurAndCompile torcs-data
  cloneAurAndCompile torcs
fi

if [ "$installEmulators" = "y" ]; then
  #sudo pacman -Sy --noconfirm dosbox
  sudo pacman -Sy --noconfirm dolphin-emu
  sudo pacman -Sy --noconfirm mednafen
  sudo pacman -Sy --noconfirm hatari
  sudo pacman -Sy --noconfirm ppsspp
  sudo pacman -Sy --noconfirm scummvm scummvm-tools
  sudo pacman -Sy --noconfirm fs-uae fs-uae-launcher
  cloneAurAndCompile dosbox-staging
fi

if [ "$installOtherGames" = "y" ]; then
  sudo pacman -Sy --noconfirm lbreakout2
  sudo pacman -Sy --noconfirm lincity-ng
fi
echo "Installing games packages... DONE"

# joysticks
if [ "$installJoystickPs5" = "y" ]; then
  sudo pacman -Sy --noconfirm joyutils
  cloneAurAndCompile hid-playstation-dkms
fi

echo "Cleaning temporary data... "
for dir in ~/aur/*; do
  cd "$dir" || exit
  CURRENT_DIR=$(basename "$PWD")
  rm -rf ./pkg/ ./src/ ./*.tar.* ./*.zip* ./*.tgz* ./*.bz* ./"${CURRENT_DIR}"
done
echo "Cleaning temporary data... DONE"

echo "Installing AUR packages... DONE"
