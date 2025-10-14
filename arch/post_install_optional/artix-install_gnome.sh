#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su pacman -Syu --noconfirm
$su pacman -S gnome gnome-tweaks gdm gdm-dinit \
  networkmanager networkmanager-dinit networkmanager-openconnect \
  gnome-photos gnome-screenshot gnome-usage \
  arc-gtk-theme eog file-roller gucharmap \
  xorg xorg-drivers

$su pacman -Rsnd connman connman-dinit

$su dinitctl enable NetworkManager
$su dinitctl enable gdm
