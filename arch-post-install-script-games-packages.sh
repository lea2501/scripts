#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

############ Script

# games and personal packages

read -rp "Install everything?: (y|n)" installEverything
if [ "$installEverything" = "y" ]; then
  addUserToGamesGroup="y"
  installRoguelikes="y"
  installDoom="y"
  installDoom3="y"
  installQuake="y"
  installQuake2="y"
  installHexen2="y"
  installHalfLife="y"
  installBuildGames="y"
  installIortcw="y"
  installMarathon="y"
  installDescent="y"
  installDiablo="y"
  installUqm="y"
  installMinetest="y"
  installExtraTools="y"
  installRacingGames="y"
  installEmulators="y"
  installRetroarch="y"
  installOtherGames="y"
  installJoystickPs5="y"
elif [ "$installEverything" = "n" ]; then
  read -rp "add user to games group?: (y|n)" addUserToGamesGroup
  read -rp "Install roguelike games?: (y|n)" installRoguelikes
  read -rp "Install doom source ports?: (y|n)" installDoom
  read -rp "Install doom 3 source ports?: (y|n)" installDoom3
  read -rp "Install quake 1 source ports?: (y|n)" installQuake
  read -rp "Install quake 2 source ports?: (y|n)" installQuake2
  read -rp "Install hexen 2 source ports?: (y|n)" installHexen2
  read -rp "Install GoldSrc engine for Half life games source ports?: (y|n)" installHalfLife
  read -rp "Install build games source port?: (y|n)" installBuildGames
  read -rp "Install return to castle wolfenstein source port?: (y|n)" installIortcw
  read -rp "Install marathon source ports?: (y|n)" installMarathon
  read -rp "Install descent source ports?: (y|n)" installDescent
  read -rp "Install diablo source ports?: (y|n)" installDiablo
  read -rp "Install urquan masters?: (y|n)" installUqm
  read -rp "Install minetest?: (y|n)" installMinetest
  read -rp "Install extra tools?: (y|n)" installExtraTools
  read -rp "Install racing games?: (y|n)" installRacingGames
  read -rp "Install console emulators?: (y|n)" installEmulators
  read -rp "Install retroarch emulator?: (y|n)" installRetroarch
  read -rp "Install other games?: (y|n)" installOtherGames
  read -rp "Install ps5 joystick driver?: (y|n)" installJoystickPs5
fi

cloneAurAndCompile() {
  mkdir -p ~/aur
  cd ~/aur || return
  if [ ! -d "$1" ]; then
    git clone https://aur.archlinux.org/"$1".git
    cd "$1" || return
  else
    cd "$1" || return
    git pull
  fi
  makepkg -sic --noconfirm
  cd || return
}

cloneAurAndCompileSkipChecks() {
  mkdir -p ~/aur
  cd ~/aur || return
  if [ ! -d "$1" ]; then
    git clone https://aur.archlinux.org/"$1".git
    cd "$1" || return
  else
    cd "$1" || return
    git pull
  fi
  makepkg -sic --noconfirm --skippgpcheck
  cd || return
}

cloneSrc() {
  mkdir -p ~/src
  cd ~/src || return
  if [ ! -d "$1" ]; then
    git clone "$2"
    cd "$1" || return
  else
    cd "$1" || return
    git pull
  fi
}

if [ "$addUserToGamesGroup" = "y" ]; then
  username=$(echo "$USER")
  gpasswd -a "${username}" games
fi

if [ "$installRoguelikes" = "y" ]; then
  echo "Installing roguelikes games packages..."
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
  echo "Installing roguelikes games packages...DONE"
fi

if [ "$installDoom" = "y" ]; then
  echo "Installing doom packages..."
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
  echo "Installing doom packages...DONE"
fi

if [ "$installDoom3" = "y" ]; then
  echo "Installing doom3 packages..."
  cloneAurAndCompile dhewm3
  echo "Installing doom3 packages...DONE"
fi

if [ "$installQuake" = "y" ]; then
  echo "Installing quake 1 packages..."
  cloneAurAndCompile quakespasm
  cloneAurAndCompile qpakman
  #cloneAndCompile tyrquake-git

  cd ~/games || return
  mkdir -p quakeinjector
  cd ~/games/quakeinjector || return
  mkdir -p bin
  mkdir -p downloads
  cd ~/games/quakeinjector/bin || return
  curl -O -L "$(curl -s https://api.github.com/repos/hrehfeld/QuakeInjector/releases/latest | jq -r ".assets[] | select(.name | test(\"quakeinjector\")) | .browser_download_url")"
  unzip quakeinjector*.zip
  echo "Installing quake 1 packages...DONE"
fi

if [ "$installQuake2" = "y" ]; then
  echo "Installing quake 2 packages..."
  cloneAurAndCompile yamagi-quake2
  cloneAurAndCompile yamagi-quake2-rogue
  cloneAurAndCompile yamagi-quake2-xatrix
  echo "Installing quake 2 packages...DONE"
fi

if [ "$installHexen2" = "y" ]; then
  echo "Installing hexen 2 packages..."
  cloneAurAndCompile hexen2
  echo "Installing hexen 2 packages...DONE"
fi

if [ "$installHalfLife" = "y" ]; then
  echo "Installing HalfLife packages..."
  cloneAurAndCompile xash3d-fwgs-git
  echo "Installing HalfLife packages...DONE"
fi

if [ "$installBuildGames" = "y" ]; then
  echo "Installing build games packages..."
  cloneAurAndCompile eduke32
  cloneAurAndCompile nblood
  cloneAurAndCompile raze
  echo "Installing build games packages...DONE"
fi

if [ "$installIortcw" = "y" ]; then
  echo "Installing return to castle wolfenstein packages..."
  cloneAurAndCompile iortcw-data
  cloneAurAndCompile iortcw-git
  echo "Installing return to castle wolfenstein packages...DONE"
fi

if [ "$installMarathon" = "y" ]; then
  echo "Installing marathon packages..."
  cloneAurAndCompile alephone
  cloneAurAndCompile alephone-marathon
  cloneAurAndCompile alephone-marathon2
  cloneAurAndCompile alephone-rubiconx
  cloneAurAndCompile alephone-infinity
  echo "Installing marathon packages...DONE"
fi

if [ "$installDescent" = "y" ]; then
  echo "Installing descent packages..."
  cloneAurAndCompile d1x-rebirth
  cloneAurAndCompile d2x-rebirth
  echo "Installing descent packages...DONE"
fi

if [ "$installDiablo" = "y" ]; then
  echo "Installing diablo 1 packages..."
  cloneAurAndCompile devilutionx
  echo "Installing diablo 1 packages...DONE"
fi

if [ "$installUqm" = "y" ]; then
  echo "Installing urquan masters packages..."
  sudo pacman -Sy --noconfirm uqm
  cloneAurAndCompile uqm-sound
  cloneAurAndCompile uqm-remix
  #cloneAurAndCompile uqm-hd
  #cloneAurAndCompile uqm-hd-sound
  echo "Installing urquan masters packages...DONE"
fi

if [ "$installMinetest" = "y" ]; then
  echo "Installing minetest packages..."
  sudo pacman -Sy --noconfirm minetest minetest-server
  echo "Installing minetest packages...DONE"
fi

if [ "$installExtraTools" = "y" ]; then
  echo "Installing extra tools packages..."
  cloneAurAndCompile flacon
  cloneAurAndCompile tsmuxer-git
  cloneAurAndCompile bdinfo-git
  cloneAurAndCompile jdownloader2
  #cloneAurAndCompile mkcue
  gpg --auto-key-locate nodefault,wkd --locate-keys torbrowser@torproject.org
  cloneAurAndCompile tor-browser
  cloneAurAndCompile xbindkeys-git
  cloneAurAndCompile mangohud
  echo "Installing extra tools packages...DONE"
fi

if [ "$installRacingGames" = "y" ]; then
  echo "Installing racing games packages..."
  cloneAurAndCompile plib
  cloneAurAndCompile speed-dreams-svn
  cloneAurAndCompile torcs-data
  cloneAurAndCompile torcs
  echo "Installing racing games packages...DONE"
fi

if [ "$installEmulators" = "y" ]; then
  echo "Installing console emulators packages..."
  #sudo pacman -Sy --noconfirm dosbox
  sudo pacman -Sy --noconfirm mgba
  sudo pacman -Sy --noconfirm snes9x
  sudo pacman -Sy --noconfirm mupen64plus
  sudo pacman -Sy --noconfirm dolphin-emu
  sudo pacman -Sy --noconfirm higan
  sudo pacman -Sy --noconfirm mednafen
  sudo pacman -Sy --noconfirm hatari
  sudo pacman -Sy --noconfirm ppsspp
  sudo pacman -Sy --noconfirm scummvm scummvm-tools
  sudo pacman -Sy --noconfirm fs-uae fs-uae-launcher
  sudo pacman -Sy --noconfirm playonlinux
  cloneAurAndCompile dosbox-staging
  cloneAurAndCompile sameboy
  cloneAurAndCompile nestopia
  cloneAurAndCompile pcsx2-git
  cloneAurAndCompile rpcs3
  cloneAurAndCompile yuzu-git
  echo "Installing console emulators packages...DONE"
fi

if [ "$installRetroarch" = "y" ]; then
  echo "Installing retroarch packages..."
  sudo pacman -Sy --noconfirm retroarch libretro
  cloneAurAndCompile libretro-dosbox-pure-git
  cloneAurAndCompile libretro-beetle-saturn-git
  cloneAurAndCompile libretro-opera-git
  echo "Installing retroarch packages...DONE"
fi

if [ "$installOtherGames" = "y" ]; then
  echo "Installing other games packages..."
  sudo pacman -Sy --noconfirm lbreakout2
  sudo pacman -Sy --noconfirm lincity-ng
  echo "Installing other games packages...DONE"
fi

# joysticks
if [ "$installJoystickPs5" = "y" ]; then
  echo "Installing ps5 joystick packages..."
  sudo pacman -Sy --noconfirm joyutils
  cloneAurAndCompile hid-playstation-dkms
  echo "Installing ps5 joystick packages...DONE"
fi

echo "Cleaning temporary data... "
for dir in ~/aur/*; do
  cd "$dir" || exit
  CURRENT_DIR=$(basename "$PWD")
  rm -rf ./pkg/ ./src/ ./*.tar.* ./*.zip* ./*.tgz* ./*.bz* ./"${CURRENT_DIR}"
done
echo "Cleaning temporary data...DONE"

echo "Installing AUR packages...DONE"
