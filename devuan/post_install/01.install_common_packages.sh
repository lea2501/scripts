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
    build-essential tmux vim nano udisks2 brightnessctl brightness-udev dos2unix exfatprogs renameutils bsdmainutils firejail manpages bc lsof libfuse2 \
    xclip autocutsel xosd-bin picom suckless-tools \
    ttf-bitstream-vera fonts-dejavu fonts-inconsolata fonts-liberation \
    pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-libcamera wireplumber \
    usbutils udftools bash-completion htop findutils acpi lm-sensors ntpsec xdotool tree linux-cpupower \
    cmake openjdk-21-jdk maven gradle python3 python3-pip meson ninja-build \
    jq git podman \
    flac opus-tools vorbis-tools wavpack mpv ffmpeg sox shntool lsdvd libbluray-bdj \
    moc lynx rtorrent amule \
    detox scrot mc hdparm lshw \
    mcomix qpdf zathura zathura-pdf-poppler zathura-djvu zathura-ps zathura-cb mupdf mupdf-tools \
    foremost testdisk sleuthkit scalpel guymager \
    feh geeqie gimp imagemagick \
    curl axel rsync tigervnc-viewer openconnect x11vnc clamav \
    ntfs-3g gparted libreoffice keepassxc zbar-tools cabextract arj unrar-free p7zip-full unace unzip zip tar xarchiver galculator libxml2-utils aapt \
    qemu-system qemu-system-x86 qemu-utils
