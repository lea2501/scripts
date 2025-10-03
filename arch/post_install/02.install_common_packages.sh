#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su pacman -Syu --noconfirm

cd || return
# system
$su pacman -S \
    pacman-contrib base-devel arch-install-scripts devtools inetutils net-tools \
    tmux vi vim nano firejail lsof bash-completion htop findutils bc detox man less \
    brightnessctl upower usbutils acpi lm_sensors ntp \
    udftools exfatprogs dos2unix udisks2 \
    picom xclip xosd scrot slock dmenu \
    terminus-font ttf-bitstream-vera ttf-dejavu ttf-inconsolata ttf-liberation ttf-opensans gnu-free-fonts \
    pipewire pipewire-alsa pipewire-pulse pipewire-libcamera wireplumber \
    cmake jdk11-openjdk jdk17-openjdk maven gradle python python-pip \
    jq git intellij-idea-community-edition podman android-tools \
    flac faac mac opus-tools vorbis-tools wavpack mpv ffmpeg sox libdvdcss lsdvd cuetools \
    wmname avidemux-qt lynx newsboat rtorrent amule aria2 yt-dlp \
    mc hdparm lshw fdupes \
    qpdf zathura zathura-pdf-mupdf mupdf mupdf-tools \
    foremost testdisk sleuthkit \
    feh geeqie gimp imagemagick optipng \
    curl wget axel rsync tigervnc filezilla openconnect openbsd-netcat clamav freerdp \
    ntfs-3g gparted libreoffice-fresh libreoffice-fresh-es keepassxc galculator zbar \
    cabextract arj unrar p7zip unarj unace unzip zip tar xarchiver libxml2 \
    qemu-base qemu-system-x86 qemu-system-x86-firmware
#$su pacman -S networkmanager-openconnect
#$su pacman -S moc autocutsel
#$su pacman -S virtualbox virtualbox-guest-utils libvirt virtualbox-host-dkms
#$su pacman -S vagrant plugin install vagrant-vbguest
