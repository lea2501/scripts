#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

options=(y n)
read -rp "Install system tools?: (y|n)" installSystemTools
if [[ " "${options[@]}" " != *" $installSystemTools "* ]]; then
  echo "$installSystemTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install development tools?: (y|n)" installDevelTools
if [[ " "${options[@]}" " != *" $installDevelTools "* ]]; then
  echo "$installDevelTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install multimedia tools?: (y|n)" installMultimediaTools
if [[ " "${options[@]}" " != *" $installMultimediaTools "* ]]; then
  echo "$installMultimediaTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install extra tools?: (y|n)" installExtraTools
if [[ " "${options[@]}" " != *" $installExtraTools "* ]]; then
  echo "$installExtraTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install forensic tools?: (y|n)" installForensicTools
if [[ " "${options[@]}" " != *" $installForensicTools "* ]]; then
  echo "$installForensicTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install image tools?: (y|n)" installImageTools
if [[ " "${options[@]}" " != *" $installImageTools "* ]]; then
  echo "$installImageTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install network tools?: (y|n)" installNetworkTools
if [[ " "${options[@]}" " != *" $installNetworkTools "* ]]; then
  echo "$installNetworkTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install misc tools?: (y|n)" installMiscTools
if [[ " "${options[@]}" " != *" $installMiscTools "* ]]; then
  echo "$installMiscTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install emulation tools?: (y|n)" installEmulationTools
if [[ " "${options[@]}" " != *" $installEmulationTools "* ]]; then
  echo "$installEmulationTools: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi

# pacman packages
echo "Updating system repositories and packages..."
sudo pacman -Syu --noconfirm
echo "Updating system repositories and packages... DONE"

# Arch Repository
echo "installing packages..."
# system
if [ "$installSystemTools" = "y" ]; then
  sudo pacman -Sy --noconfirm \
  base-devel \
  tmux \
  vim \
  vi \
  nano \
  udisks2 \
  brightnessctl \
  dos2unix \
  exfat-utils \
  picom \
  terminus-font \
  xclip \
  xosd \
  ttf-bitstream-vera ttf-dejavu ttf-inconsolata ttf-liberation ttf-opensans \
  usbutils \
  udftools \
  bash-completion \
  gnu-free-fonts \
  htop \
  findutils \
  acpi \
  lm_sensors \
  ntp \
  alsa-plugins alsa-utils \
  pulseaudio pavucontrol pulseaudio-alsa
fi

# devel
if [ "$installDevelTools" = "y" ]; then
  sudo pacman -Sy --noconfirm \
  cmake \
  jre-openjdk \
  jdk-openjdk \
  jdk8-openjdk \
  jdk11-openjdk \
  maven \
  gradle \
  npm \
  jq \
  git \
  subversion \
  groovy \
  intellij-idea-community-edition \
  kotlin \
  docker \
  mariadb mariadb-clients \
  geany geany-plugins
fi

# multimedia
if [ "$installMultimediaTools" = "y" ]; then
  sudo pacman -Sy --noconfirm \
  flac faac mac opus-tools vorbis-tools wavpack \
  mpv \
  ffmpeg \
  sox \
  shntool \
  libdvdcss \
  lsdvd \
  vlc
fi

# extra tools
if [ "$installExtraTools" = "y" ]; then
  sudo pacman -Sy --noconfirm \
  wmname \
  moc \
  audacity \
  avidemux-qt \
  lynx \
  w3m \
  newsboat \
  elinks \
  rtorrent \
  amule \
  transmission-gtk \
  aria2 \
  youtube-dl \
  dmenu \
  pcmanfm \
  detox \
  scrot \
  slock \
  mc \
  syncthing \
  wine wine-gecko wine-mono \
  mcomix \
  zathura zathura-pdf-mupdf \
  mupdf mupdf-tools
fi

# forensic tools
if [ "$installForensicTools" = "y" ]; then
  sudo pacman -Sy --noconfirm \
  foremost \
  testdisk \
  sleuthkit
fi

# images
if [ "$installImageTools" = "y" ]; then
  sudo pacman -Sy --noconfirm \
  feh \
  geeqie \
  gimp \
  imagemagick
fi

# net
if [ "$installNetworkTools" = "y" ]; then
  sudo pacman -Sy --noconfirm \
  curl \
  wget \
  axel \
  firefox \
  geckodriver \
  tigervnc \
  filezilla \
  openconnect \
  networkmanager-openconnect \
  samba
fi

# tools
if [ "$installMiscTools" = "y" ]; then
  sudo pacman -Sy --noconfirm \
  ntfs-3g \
  rsync \
  clamav \
  gparted \
  freerdp \
  rdesktop \
  libreoffice-fresh libreoffice-fresh-es \
  cabextract arj unrar p7zip unarj unace unzip zip tar \
  xarchiver \
  galculator
fi

# emulators
if [ "$installEmulationTools" = "y" ]; then
  sudo pacman -Sy --noconfirm \
  qemu qemu-arch-extra \
  virtualbox virtualbox-guest-utils libvirt virtualbox-host-dkms \
  vagrant

  #vagrant plugin install vagrant-vbguest
fi

echo "installing packages... DONE"
