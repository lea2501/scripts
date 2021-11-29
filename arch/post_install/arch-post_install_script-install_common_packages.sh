#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Updating system repositories and packages..."
$su pacman -Syu --noconfirm
echo "Updating system repositories and packages... DONE"

echo "installing common packages..."
cd || return
# system
$su pacman -S --noconfirm pacman-contrib base-devel tmux vi vim nano udisks2 brightnessctl dos2unix exfatprogs picom firejail
$su pacman -S --noconfirm xclip autocutsel xosd usbutils udftools bash-completion htop findutils acpi lm_sensors ntp alsa-plugins alsa-utils
$su pacman -S --noconfirm terminus-font ttf-bitstream-vera ttf-dejavu ttf-inconsolata ttf-liberation ttf-opensans gnu-free-fonts

# pulseaudio
$su pacman -S --noconfirm pulseaudio pavucontrol pulseaudio-alsa

# devel
$su pacman -S --noconfirm cmake jre-openjdk jdk-openjdk jdk8-openjdk jdk11-openjdk maven gradle npm
$su pacman -S --noconfirm jq git subversion groovy intellij-idea-community-edition kotlin docker mariadb mariadb-clients geany geany-plugins android-tools

# multimedia
$su pacman -S --noconfirm flac faac mac opus-tools vorbis-tools wavpack mpv ffmpeg sox shntool libdvdcss lsdvd

# extra tools
$su pacman -S --noconfirm wmname moc avidemux-qt lynx w3m newsboat rtorrent amule aria2 youtube-dl
$su pacman -S --noconfirm dmenu pcmanfm detox scrot slock mc hdparm lshw
$su pacman -S --noconfirm mcomix qpdf zathura zathura-pdf-mupdf mupdf mupdf-tools

# forensic tools
$su pacman -S --noconfirm foremost testdisk sleuthkit

# images
$su pacman -S --noconfirm feh geeqie gimp imagemagick

# net
$su pacman -S --noconfirm curl wget axel tigervnc filezilla openconnect networkmanager-openconnect samba

# tools
$su pacman -S --noconfirm ntfs-3g rsync clamav gparted freerdp rdesktop libreoffice-fresh libreoffice-fresh-es keepassxc galculator pass pass-otp zbar
$su pacman -S --noconfirm cabextract arj unrar p7zip unarj unace unzip zip tar xarchiver libxml2

# emulators
$su pacman -S --noconfirm qemu qemu-arch-extra
#$su pacman -S --noconfirm virtualbox virtualbox-guest-utils libvirt virtualbox-host-dkms
#vagrant plugin install vagrant-vbguest

echo "installing common packages... DONE"