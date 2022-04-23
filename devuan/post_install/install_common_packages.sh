#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

echo "Updating system repositories and packages..."
$su apt update
$su apt full-upgrade -y
echo "Updating system repositories and packages... DONE"
echo "installing packages..."
cd || return
# system
$su apt-get -y install build-essential tmux vim nano udisks2 suckless-tools brightnessctl brightness-udev dos2unix exfat-utils xclip autocutsel xosd-bin picom renameutils bsdmainutils firejail manpages
$su apt-get -y install ttf-bitstream-vera fonts-dejavu fonts-inconsolata fonts-liberation
$su apt-get -y install usbutils udftools bash-completion htop findutils acpi cpufreqd lm-sensors ntp alsa-tools alsa-utils xdotool tree

# pulseaudio
$su apt-get -y install pulseaudio pavucontrol

# devel
$su apt-get -y install cmake openjdk-17-jdk openjdk-11-jdk openjdk-11-jdk-headless openjdk-11-jre maven gradle npm
$su apt-get -y install jq git subversion groovy podman mariadb-server mariadb-client geany geany-plugins #docker.io

# multimedia
$su apt-get -y install flac opus-tools vorbis-tools wavpack mpv ffmpeg sox shntool lsdvd libbluray-bdj

# extra tools
$su apt-get -y install moc lynx w3m newsboat rtorrent amule youtube-dl
$su apt-get -y install pcmanfm detox scrot mc hdparm lshw
$su apt-get -y install mcomix qpdf zathura zathura-pdf-poppler zathura-djvu zathura-ps zathura-cb mupdf mupdf-tools

# forensic tools
$su apt-get -y install foremost testdisk sleuthkit scalpel guymager

# images
$su apt-get -y install feh geeqie gimp imagemagick

# net
$su apt-get -y install curl axel tigervnc-viewer openconnect network-manager network-manager-openconnect samba x11vnc

# tools
$su apt-get -y install ntfs-3g rsync clamav gparted rdesktop libreoffice keepassxc zbar-tools cabextract arj unrar-free p7zip-full unace unzip zip tar xarchiver galculator libxml2-utils aapt

# emulators
$su apt-get -y install qemu qemu-kvm qemu-system-x86 qemu-utils

echo "installing packages... DONE"
