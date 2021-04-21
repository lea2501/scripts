#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

read -rp "Install system tools?: (y|n)" installSystemTools
read -rp "Install development tools?: (y|n)" installDevelTools
read -rp "Install multimedia tools?: (y|n)" installMultimediaTools
read -rp "Install extra tools?: (y|n)" installExtraTools
read -rp "Install forensic tools?: (y|n)" installForensicTools
read -rp "Install image tools?: (y|n)" installImageTools
read -rp "Install network tools?: (y|n)" installNetworkTools
read -rp "Install misc tools?: (y|n)" installMiscTools
read -rp "Install emulation tools?: (y|n)" installEmulationTools

# pacman packages
echo "Updating system repositories and packages..."
sudo pacman -Syu --noconfirm
echo "Updating system repositories and packages... DONE"

# Arch Repository
echo "installing packages..."
# system
if [ $installSystemTools = "y" ]; then
  sudo pacman -Sy --noconfirm \
  base-devel \
  tmux \
  vim \
  vi \
  nano \
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
  pulseaudio pavucontrol
fi

# devel
if [ $installDevelTools = "y" ]; then
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
if [ $installMultimediaTools = "y" ]; then
  sudo pacman -Sy --noconfirm \
  flac faac mac opus-tools vorbis-tools wavpack \
  mpv \
  ffmpeg \
  sox \
  shntool \
  libdvdcss \
  lsdvd \
  vlc \
fi

# extra tools
if [ $installExtraTools = "y" ]; then
  sudo pacman -Sy --noconfirm \
  wmname \
  moc \
  mkcue \
  audacity \
  avidemux-qt \
  lynx \
  w3m \
  surf \
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
if [ $installForensicTools = "y" ]; then
  sudo pacman -Sy --noconfirm \
  foremost \
  testdisk \
  sleuthkit
fi

# images
if [ $installImageTools = "y" ]; then
  sudo pacman -Sy --noconfirm \
  feh \
  geeqie \
  gimp \
  imagemagick
fi

# net
if [ $installNetworkTools = "y" ]; then
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
if [ $installMiscTools = "y" ]; then
  sudo pacman -Sy --noconfirm \
  ntfs-3g \
  rsync \
  clamav \
  gparted \
  freerdp \
  rdesktop \
  libreoffice-fresh libreoffice-fresh-es \
  cabextract arj unrar p7zip unarj unace zip tar \
  xarchiver \
  galculator
fi

# emulators
if [ $installEmulationTools = "y" ]; then
  sudo pacman -Sy --noconfirm \
  qemu qemu-arch-extra \
  virtualbox virtualbox-guest-utils libvirt virtualbox-host-dkms \
  vagrant

  #vagrant plugin install vagrant-vbguest
fi

echo "installing packages... DONE"