#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

# Add arch linux support
echo "Adding Arch Linux packages support..."
$su pacman -Syu artix-archlinux-support
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
  } | $su tee -a /etc/pacman.conf
$su pacman-key --populate archlinux
echo "Adding arch linux packages support... DONE"
