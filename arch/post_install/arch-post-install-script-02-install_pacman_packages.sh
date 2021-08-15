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

cd || return

# system
echo \
  'pacman-contrib
base-devel
tmux
vi
vim
nano
udisks2
brightnessctl
dos2unix
exfatprogs
picom
terminus-font
xclip
autocutsel
xosd
ttf-bitstream-vera ttf-dejavu ttf-inconsolata ttf-liberation ttf-opensans
gnu-free-fonts
usbutils
udftools
bash-completion
htop
findutils
acpi
lm_sensors
ntp
alsa-plugins alsa-utils' >packages.txt

# pulseaudio
echo \
  'pulseaudio pavucontrol pulseaudio-alsa' >>packages.txt

# devel
echo \
  'cmake
jre-openjdk
jdk-openjdk
jdk8-openjdk
jdk11-openjdk
maven
gradle
npm
jq
git
subversion
groovy
intellij-idea-community-edition
kotlin
docker
mariadb mariadb-clients
geany geany-plugins
android-tools' >>packages.txt

# multimedia
echo \
  'flac faac mac opus-tools vorbis-tools wavpack
mpv
ffmpeg
sox
shntool
libdvdcss
lsdvd
vlc' >>packages.txt

# extra tools
echo \
  'wmname
moc
avidemux-qt
lynx
w3m
newsboat
rtorrent
amule
aria2
youtube-dl
dmenu
pcmanfm
detox
scrot
slock
mc
hdparm lshw
mcomix
qpdf
zathura zathura-pdf-mupdf
mupdf mupdf-tools' >>packages.txt

# forensic tools
echo \
  'foremost
testdisk
sleuthkit' >>packages.txt

# images
echo \
  'feh
geeqie
gimp
imagemagick' >>packages.txt

# net
echo \
  'curl
wget
axel
tigervnc
filezilla
openconnect
networkmanager-openconnect
samba' >>packages.txt

# tools
echo \
  'ntfs-3g
rsync
clamav
gparted
freerdp
rdesktop
libreoffice-fresh libreoffice-fresh-es
keepassxc
cabextract arj unrar p7zip unarj unace unzip zip tar
xarchiver
galculator' >>packages.txt

# emulators
echo \
  'qemu qemu-arch-extra' >>packages.txt

#sudo pacman -Sy --noconfirm --needed
#  virtualbox virtualbox-guest-utils libvirt virtualbox-host-dkms
#  vagrant plugin install vagrant-vbguest

sudo pacman -Sy --noconfirm --needed $(cat packages.txt)
#rm packages.txt

echo "installing packages... DONE"
