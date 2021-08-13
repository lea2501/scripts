#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

# pacman packages
echo "Updating system repositories and packages..."
sudo apt update
sudo apt full-upgrade -y
echo "Updating system repositories and packages... DONE"

# Arch Repository
echo "installing packages..."
# system
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

# devel
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

# multimedia
sudo apt install -y \
  flac faac opus-tools vorbis-tools wavpack \
  mpv \
  ffmpeg \
  sox \
  shntool \
  lsdvd \
  vlc

# extra tools
sudo apt install -y \
  moc \
  lynx \
  w3m \
  newsboat \
  elinks \
  rtorrent \
  amule \
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

# forensic tools
sudo apt install -y \
  foremost \
  testdisk \
  sleuthkit \
  scalpel \
  guymager

# images
sudo apt install -y \
  feh \
  geeqie \
  gimp \
  imagemagick

# net
sudo apt install -y \
  curl \
  axel \
  tigervnc-viewer \
  openconnect \
  network-manager network-manager-openconnect \
  samba

# tools
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

# emulators
sudo apt install -y \
  qemu qemu-kvm qemu-system-x86 qemu-utils

echo "installing packages... DONE"
