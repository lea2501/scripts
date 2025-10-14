#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

show_usage() {
  printf "Usage: $0 [options [parameters]]\n"
  printf "\n"
  printf "Commands:\n"
  printf " -i|--install                [game name from lgogdownloader list]\n"
  printf " -l|--list                   (list available games in gog account)\n"
  printf "\n"
  printf "Options:\n"
  printf " --dxvk                      (installs dxvk to WINEPREFIX path after installation)\n"
  printf " --win                       (installs the windows version of the game)\n"
  printf " --lin                       (installs the linux version of the game)\n"
  printf "\n"
  printf " -l|--list, list available wad files\n"
  printf " -h|--help, Print help\n"

  exit
}

install_lgogdownloader() {
  lgog_downloader=$(pacman -Qs lgogdownloader-qt5-git)
  if [ "$lgog_downloader" = "" ]; then
    paru -S lgogdownloader-qt5
  else
    echo "INFO: lgogdownloader currently installed"
  fi
  echo -e "\033[33;5mINFO: If running for first time you need to type: '$ lgogdownloader --login --enable-login-gui'\033[0m"
}

# Check command
if [ -z "$1" ]; then
  show_usage
fi
if { [ "$1" = --help ] || [ "$1" = -h ];}; then
  show_usage
fi
if { [ "$1" = --list ] || [ "$1" = -l ];}; then
  install_lgogdownloader
  lgogdownloader --list
  exit
fi

# Parse parameters
while [ -n "$1" ]; do
  case "$1" in
  --install | -i)
    shift
    echo "INFO: Installing game: $1"
    game=$1
    ;;
  --dxvk)
    echo "INFO: Installing dxvk after game install"
    install_dxvk="true"
    ;;
  --win)
    echo "INFO: Installing windows version..."
    version_windows="true"
    ;;
  --lin)
    echo "INFO: Installing linux version..."
    version_linux="true"
    ;;
  *)
    show_usage
    ;;
  esac
  shift
done

# set defaults
if [ -z "$install_dxvk" ]; then
  install_dxvk="false"
fi
if [ -z "$version_windows" ]; then
  version_windows="true"
fi
if [ -z "$version_linux" ]; then
  version_linux="false"
fi

# Go to ~/Downloads directory
mkdir -p ~/Downloads
cd ~/Downloads || return

# check if game is in gog list
in_list=$(lgogdownloader --list | grep ${game})
if [ ! $in_list = "" ]; then
  echo "INFO: $game is in list, downloading..."

  # Retry downloading cause of bad connection
  counter=0 limit=10
  while [ "$counter" -lt "$limit" ]; do
    response="$(
      echo "INFO: Downloading $game files..." |
        lgogdownloader --download --threads 8 --retries 60 --timeout 20 --lowspeed-rate 200 --lowspeed-timeout 30 --exclude patches --game $game
        )" &&
      break
    counter="$(( $counter + 1 ))"
  done

  #lgogdownloader --download --threads 8 --retries 60 --timeout 20 --lowspeed-rate 200 --lowspeed-timeout 30 --exclude patches --game $game
else
  echo "INFO: $game is not in list, currently available games are:"
  lgogdownloader --list
fi

# Install game
if [ "$version_windows" = "true" ]; then
  mkdir -p ~/Games/gog/
  export WINEPREFIX=~/Games/gog/${game}
  echo "INFO: Wine prefix: $WINEPREFIX"

  ## Show downloaded files
  echo "INFO: Downloaded files:"
  ls -lahF ~/Downloads/*${game}*/

  ## Select game installer file and install
  read -rp "INPUT: Please enter installer filename: " installer_file
  echo "INFO: Installer file: $installer_file"
  wine ~/Downloads/${game}/${installer_file}

  # Install dxvk if requested
  if [ $install_dxvk = "true" ]; then
    setup_dxvk install
  fi

  # Show installed game files
  echo "INFO: To run game type: '$ wine <game_executable>'"
  echo ""
  echo "INFO: Installed game executables:"
  ls -l $WINEPREFIX/drive_c/GOG\ Games/*/*.exe | grep -v unins000.exe | awk '{for(i=9;i<=NF;++i)printf $i""FS ; print ""}'
elif [ "$version_linux" = "true" ]; then
  ## Show downloaded files
  echo "INFO: Downloaded files:"
  ls -lahF ~/Downloads/*${game}*/

  ## Select game installer file and install
  read -rp "INPUT: Please enter installer filename: " installer_file
  echo "INFO: Installer file: $installer_file"
  ~/Downloads/${game}/${installer_file}
fi