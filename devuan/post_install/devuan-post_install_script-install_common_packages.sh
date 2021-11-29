#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Updating system repositories and packages..."
sudo apt update
sudo apt full-upgrade -y
echo "Updating system repositories and packages... DONE"
echo "installing packages..."
cd || return
# system
sudo apt-get -y install build-essential tmux vim nano udisks2 suckless-tools brightnessctl brightness-udev dos2unix exfat-utils xclip autocutsel xosd-bin picom renameutils bsdmainutils firejail
sudo apt-get -y install ttf-bitstream-vera fonts-dejavu fonts-inconsolata fonts-liberation
sudo apt-get -y install usbutils udftools bash-completion htop findutils acpi cpufreqd lm-sensors ntp alsa-tools alsa-utils pass xdotool tree

# pulseaudio
sudo apt-get -y install pulseaudio pavucontrol

# devel
sudo apt-get -y install cmake openjdk-11-jdk openjdk-11-jdk-headless openjdk-11-jre maven gradle npm
sudo apt-get -y install jq git subversion groovy docker.io mariadb-server mariadb-client geany geany-plugins

# multimedia
sudo apt-get -y install flac opus-tools vorbis-tools wavpack mpv ffmpeg sox shntool lsdvd libbluray-bdj

# extra tools
sudo apt-get -y install moc lynx w3m newsboat rtorrent amule youtube-dl
sudo apt-get -y install pcmanfm detox scrot mc hdparm lshw
sudo apt-get -y install mcomix qpdf zathura zathura-pdf-poppler zathura-djvu zathura-ps zathura-cb mupdf mupdf-tools

# forensic tools
sudo apt-get -y install foremost testdisk sleuthkit scalpel guymager

# images
sudo apt-get -y install feh geeqie gimp imagemagick

# net
sudo apt-get -y install curl axel tigervnc-viewer openconnect network-manager network-manager-openconnect samba x11vnc

# tools
sudo apt-get -y install ntfs-3g rsync clamav gparted rdesktop libreoffice keepassxc pass pass-extension-otp zbar cabextract arj unrar-free p7zip-full unace unzip zip tar xarchiver galculator libxml2-utils aapt

# emulators
sudo apt-get -y install qemu qemu-kvm qemu-system-x86 qemu-utils

echo "installing packages... DONE"