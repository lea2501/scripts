#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

############ Script

options=(y n)
read -rp "Install system tools?: (Y|n)" installSystemTools
if [[ " "${options[@]}" " != *" $installSystemTools "* ]]; then
  echo "$installSystemTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install development tools?: (Y|n)" installDevelTools
if [[ " "${options[@]}" " != *" $installDevelTools "* ]]; then
  echo "$installDevelTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install multimedia tools?: (Y|n)" installMultimediaTools
if [[ " "${options[@]}" " != *" $installMultimediaTools "* ]]; then
  echo "$installMultimediaTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install extra tools?: (Y|n)" installExtraTools
if [[ " "${options[@]}" " != *" $installExtraTools "* ]]; then
  echo "$installExtraTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install forensic tools?: (y|N)" installForensicTools
if [[ " "${options[@]}" " != *" $installForensicTools "* ]]; then
  echo "$installForensicTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install image tools?: (Y|n)" installImageTools
if [[ " "${options[@]}" " != *" $installImageTools "* ]]; then
  echo "$installImageTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install network tools?: (Y|n)" installNetworkTools
if [[ " "${options[@]}" " != *" $installNetworkTools "* ]]; then
  echo "$installNetworkTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install misc tools?: (Y|n)" installMiscTools
if [[ " "${options[@]}" " != *" $installMiscTools "* ]]; then
  echo "$installMiscTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install emulation tools?: (Y|n)" installEmulationTools
if [[ " "${options[@]}" " != *" $installEmulationTools "* ]]; then
  echo "$installEmulationTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi

# pacman packages
echo "Updating system repositories and packages..."
sudo apt update
sudo apt full-upgrade -y
echo "Updating system repositories and packages... DONE"

# Arch Repository
echo "installing packages..."
# system
if [ "$installSystemTools" = "y" ]; then
  sudo apt install -y \
  build-essential \
  tmux \
  vim \
  nano \
  udisks2 \
  suckless-tools \
  brightnessctl-udev \
  dos2unix \
  exfat-utils \
  xclip autocutsel \
  xosd-bin \
  ttf-bitstream-vera ttf-dejavu fonts-inconsolata fonts-liberation \
  usbutils \
  udftools \
  bash-completion \
  htop \
  findutils \
  acpi cpufreqd \
  lm-sensors \
  ntp \
  alsa-tools alsa-utils \
  pass xdotool \
  tree
fi

# devel
if [ "$installDevelTools" = "y" ]; then
  sudo apt install -y \
  cmake \
  openjdk-11-jdk \
  openjdk-11-jre \
  maven \
  gradle \
  npm \
  jq \
  git \
  subversion \
  groovy \
  docker.io \
  mariadb-server mariadb-client \
  geany geany-plugins \
  adb android-sdk android-sdk-build-tools android-sdk-platform-tools fastboot
fi

# multimedia
if [ "$installMultimediaTools" = "y" ]; then
  sudo apt install -y \
  flac faac opus-tools vorbis-tools wavpack \
  mpv \
  ffmpeg \
  sox \
  shntool \
  lsdvd \
  vlc
fi

# extra tools
if [ "$installExtraTools" = "y" ]; then
  sudo apt install -y \
  moc \
  audacity \
  lynx \
  w3m \
  newsboat \
  elinks \
  rtorrent \
  amule \
  aria2 \
  youtube-dl \
  pcmanfm \
  detox \
  scrot \
  mc \
  syncthing \
  hdparm lshw \
  mcomix \
  qpdf \
  zathura zathura-pdf-poppler zathura-djvu zathura-ps zathura-cb \
  mupdf mupdf-tools
fi

# forensic tools
if [ "$installForensicTools" = "y" ]; then
  sudo apt install -y \
  foremost \
  testdisk \
  sleuthkit
fi

# images
if [ "$installImageTools" = "y" ]; then
  sudo apt install -y \
  feh \
  geeqie \
  gimp \
  imagemagick
fi

# net
if [ "$installNetworkTools" = "y" ]; then
  sudo apt install -y \
  curl \
  wget \
  axel \
  tigervnc-viewer \
  filezilla \
  openconnect \
  network-manager network-manager-openconnect \
  samba
fi

# tools
if [ "$installMiscTools" = "y" ]; then
  sudo apt install -y \
  ntfs-3g \
  rsync \
  clamav \
  gparted \
  freerdp2-x11 \
  rdesktop \
  libreoffice libreoffice-es \
  keepassxc \
  cabextract arj unrar-free p7zip-full unace unzip zip tar \
  xarchiver \
  galculator
fi

# emulators
if [ "$installEmulationTools" = "y" ]; then
  sudo apt install -y \
  qemu qemu-kvm qemu-system-x86 qemu-utils
fi

echo "installing packages... DONE"
