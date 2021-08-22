#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

############ Script

options=(y n)

# Add arch linux support
echo "Adding Arch Linux packages support..."
sudo pacman -Syu artix-archlinux-support
  {
    echo "#[testing]"
    echo "#Include = /etc/pacman.d/mirrorlist"
    echo ""
    echo "[extra]"
    echo "Include = /etc/pacman.d/mirrorlist"
    echo ""
    echo "#[community-testing]"
    echo "#Include = /etc/pacman.d/mirrorlist"
    echo ""
    echo "[community]"
    echo "Include = /etc/pacman.d/mirrorlist"
    echo ""
    echo "#[multilib-testing]"
    echo "#Include = /etc/pacman.d/mirrorlist"
    echo ""
    echo "[multilib]"
    echo "Include = /etc/pacman.d/mirrorlist"
  } | sudo tee -a /etc/pacman.conf
sudo pacman-key --populate archlinux
echo "Adding arch linux packages support... DONE"
