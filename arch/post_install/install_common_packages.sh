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
$su pacman -Syu --noconfirm
echo "Updating system repositories and packages... DONE"

echo "installing common packages..."
cd || return
# system
$su pacman -S pacman-contrib base-devel arch-install-scripts devtools tmux vi vim nano udisks2 brightnessctl dos2unix exfatprogs picom firejail upower lsof
$su pacman -S xclip autocutsel xosd usbutils udftools bash-completion htop findutils acpi lm_sensors ntp alsa-plugins alsa-utils
$su pacman -S terminus-font ttf-bitstream-vera ttf-dejavu ttf-inconsolata ttf-liberation ttf-opensans gnu-free-fonts

# pulseaudio
$su pacman -S pulseaudio pavucontrol

# devel
$su pacman -S cmake jre-openjdk jdk-openjdk jdk8-openjdk jdk11-openjdk jdk17-openjdk maven gradle npm
$su pacman -S jq git subversion groovy intellij-idea-community-edition kotlin docker mariadb mariadb-clients geany geany-plugins android-tools

# multimedia
$su pacman -S flac faac mac opus-tools vorbis-tools wavpack mpv ffmpeg sox libdvdcss lsdvd

# extra tools
$su pacman -S wmname moc avidemux-qt lynx w3m newsboat rtorrent amule aria2 youtube-dl
$su pacman -S dmenu pcmanfm detox scrot slock mc hdparm lshw fdupes
$su pacman -S qpdf zathura zathura-pdf-mupdf mupdf mupdf-tools

# forensic tools
$su pacman -S foremost testdisk sleuthkit

# images
$su pacman -S feh geeqie gimp imagemagick

# net
$su pacman -S curl wget axel tigervnc filezilla openconnect networkmanager-openconnect samba

# tools
$su pacman -S ntfs-3g rsync clamav gparted freerdp rdesktop libreoffice-fresh libreoffice-fresh-es keepassxc galculator zbar
$su pacman -S cabextract arj unrar p7zip unarj unace unzip zip tar xarchiver libxml2

# emulators
$su pacman -S qemu qemu-arch-extra
#$su pacman -S virtualbox virtualbox-guest-utils libvirt virtualbox-host-dkms
#$su pacman -S vagrant plugin install vagrant-vbguest

echo "installing common packages... DONE"
