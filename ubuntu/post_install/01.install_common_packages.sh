#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt update
$su apt full-upgrade -y

cd || return
# system
$su apt-get -y --fix-missing install \
    build-essential tmux vim nano udisks2 brightnessctl brightness-udev dos2unix exfatprogs renameutils bsdmainutils firejail manpages lsof \
    xclip autocutsel xosd-bin picom suckless-tools \
    ttf-bitstream-vera fonts-dejavu fonts-inconsolata fonts-liberation \
    usbutils udftools bash-completion htop findutils acpi lm-sensors ntp alsa-tools alsa-utils xdotool tree \
    cmake openjdk-17-jdk openjdk-11-jdk openjdk-11-jdk-headless openjdk-11-jre maven gradle npm python3 python3-pip meson ninja-build python3 python3-pip \
    jq git subversion groovy podman mariadb-server mariadb-client geany geany-plugins \
    flac opus-tools vorbis-tools wavpack mpv ffmpeg sox shntool lsdvd \
    moc lynx newsboat rtorrent amule yt-dlp \
    pcmanfm detox scrot mc hdparm lshw \
    mcomix qpdf zathura zathura-pdf-poppler zathura-djvu zathura-ps zathura-cb mupdf mupdf-tools \
    foremost testdisk sleuthkit scalpel guymager \
    feh geeqie gimp imagemagick \
    curl axel rsync tigervnc-viewer openconnect network-manager network-manager-openconnect network-manager-openconnect-gnome x11vnc rdesktop clamav \
    ntfs-3g gparted libreoffice keepassxc zbar-tools cabextract arj unrar-free p7zip-full unace unzip zip tar xarchiver galculator libxml2-utils aapt \
    qemu qemu-kvm qemu-system-x86 qemu-utils
