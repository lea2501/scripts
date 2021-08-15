#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

# pacman packages
echo "Updating system repositories and packages..."
sudo apt update
sudo apt full-upgrade -y
echo "Updating system repositories and packages... DONE"

# Arch Repository
echo "installing packages..."

cd || return

# system
echo \
  'build-essential
tmux
vim
nano
udisks2
suckless-tools
brightnessctl-udev
dos2unix
exfat-utils
xclip autocutsel
xosd-bin
ttf-bitstream-vera ttf-dejavu fonts-inconsolata fonts-liberation
usbutils
udftools
bash-completion
htop
findutils
acpi cpufreqd
lm-sensors
ntp
alsa-tools alsa-utils
pass xdotool
tree' >packages.txt

# pulseaudio
echo \
  'pulseaudio pavucontrol pulseaudio-alsa' >>packages.txt

# devel
echo \
  'cmake
openjdk-11-jdk
openjdk-11-jre
maven
gradle
npm
jq
git
subversion
groovy
docker.io
mariadb-server mariadb-client
geany geany-plugins
adb android-sdk android-sdk-build-tools android-sdk-platform-tools fastboot' >>packages.txt

# multimedia
echo \
  'flac faac opus-tools vorbis-tools wavpack
mpv
ffmpeg
sox
shntool
lsdvd' >>packages.txt

# extra tools
echo \
  'moc
lynx
w3m
newsboat
rtorrent
amule
youtube-dl
pcmanfm
detox
scrot
mc
hdparm lshw
mcomix
qpdf
zathura zathura-pdf-poppler zathura-djvu zathura-ps zathura-cb
mupdf mupdf-tools' >>packages.txt

# forensic tools
echo \
  'foremost
testdisk
sleuthkit
scalpel
guymager' >>packages.txt

# images
echo \
  'feh
geeqie
gimp
imagemagick' >>packages.txt

# net
echo \
  'curl
axel
tigervnc-viewer
openconnect
network-manager network-manager-openconnect
samba' >>packages.txt

# tools
echo \
  'ntfs-3g
rsync
clamav
gparted
rdesktop
libreoffice libreoffice-es
keepassxc
cabextract arj unrar-free p7zip-full unace unzip zip tar
xarchiver
galculator' >>packages.txt

# emulators
echo \
  'qemu qemu-kvm qemu-system-x86 qemu-utils' >>packages.txt

sudo apt install -y $(cat packages.txt)
#rm packages.txt

echo "installing packages... DONE"
