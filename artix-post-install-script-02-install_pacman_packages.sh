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
sudo pacman -Syu --noconfirm
echo "Updating system repositories and packages... DONE"

# Add arch linux support
echo "Adding Arch Linux packages support..."
sudo pacman -Syu artix-archlinux-support
  {
    echo "#[testing]"
    echo "#Include = /etc/pacman.d/mirrorlist"
    echo ""
    echo "[extra]"
    echo "Include = /etc/pacman.d/mirrorlist"
    echo ""
    echo "#[community-testing]"
    echo "#Include = /etc/pacman.d/mirrorlist"
    echo ""
    echo "[community]"
    echo "Include = /etc/pacman.d/mirrorlist"
    echo ""
    echo "#[multilib-testing]"
    echo "#Include = /etc/pacman.d/mirrorlist"
    echo ""
    echo "[multilib]"
    echo "Include = /etc/pacman.d/mirrorlist"
  } | sudo tee -a /etc/pacman.conf
sudo pacman-key --populate archlinux
echo "Adding Arch Linux packages support... DONE"

# Arch Repository
echo "installing packages..."
# system
if [ "$installSystemTools" = "y" ]; then
  sudo pacman -Sy --noconfirm \
  pacman-contrib \
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
  xclip autocutsel \
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
  pulseaudio pavucontrol pulseaudio-alsa \
  autocutsel \
  pass xdotool \
  tree
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
  aria2 \
  youtube-dl \
  dmenu \
  pcmanfm \
  detox \
  scrot \
  slock \
  mc \
  syncthing \
  hdparm lshw \
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
  keepassxc \
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
