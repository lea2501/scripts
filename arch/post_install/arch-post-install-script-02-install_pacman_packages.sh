#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

# pacman packages
echo "Updating system repositories and packages..."
sudo pacman -Syu --noconfirm
echo "Updating system repositories and packages... DONE"

# Arch Repository
echo "installing packages..."
# system
sudo pacman -Sy --noconfirm --needed \
  pacman-contrib \
  base-devel \
  tmux \
  vi \
  vim \
  nano \
  udisks2 \
  brightnessctl \
  dos2unix \
  exfatprogs \
  picom \
  terminus-font \
  xclip \
  autocutsel \
  xosd \
  ttf-bitstream-vera ttf-dejavu ttf-inconsolata ttf-liberation ttf-opensans \
  gnu-free-fonts \
  usbutils \
  udftools \
  bash-completion \
  htop \
  findutils \
  acpi \
  lm_sensors \
  ntp \
  alsa-plugins alsa-utils

# pulseaudio
sudo pacman -Sy --noconfirm --needed \
  pulseaudio pavucontrol pulseaudio-alsa

# devel
sudo pacman -Sy --noconfirm --needed \
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
  geany geany-plugins \
  android-tools

# multimedia
sudo pacman -Sy --noconfirm --needed \
  flac faac mac opus-tools vorbis-tools wavpack \
  mpv \
  ffmpeg \
  sox \
  shntool \
  libdvdcss \
  lsdvd \
  vlc

# extra tools
sudo pacman -Sy --noconfirm --needed \
  wmname \
  moc \
  avidemux-qt \
  lynx \
  w3m \
  newsboat \
  rtorrent \
  amule \
  aria2 \
  youtube-dl \
  dmenu \
  pcmanfm \
  detox \
  scrot \
  slock \
  mc \
  hdparm lshw \
  mcomix \
  qpdf \
  zathura zathura-pdf-mupdf \
  mupdf mupdf-tools

# forensic tools
sudo pacman -Sy --noconfirm --needed \
  foremost \
  testdisk \
  sleuthkit

# images
sudo pacman -Sy --noconfirm --needed \
  feh \
  geeqie \
  gimp \
  imagemagick

# net
sudo pacman -Sy --noconfirm --needed \
  curl \
  wget \
  axel \
  tigervnc \
  filezilla \
  openconnect \
  networkmanager-openconnect \
  samba

# tools
sudo pacman -Sy --noconfirm --needed \
  ntfs-3g \
  rsync \
  clamav \
  gparted \
  freerdp \
  rdesktop \
  libreoffice-fresh libreoffice-fresh-es \
  keepassxc \
  cabextract arj unrar p7zip unarj unace unzip zip tar \
  xarchiver \
  galculator

# emulators
sudo pacman -Sy --noconfirm --needed \
  qemu qemu-arch-extra

#sudo pacman -Sy --noconfirm --needed \
#  virtualbox virtualbox-guest-utils libvirt virtualbox-host-dkms \
#  vagrant plugin install vagrant-vbguest

echo "installing packages... DONE"
