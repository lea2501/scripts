#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su pacman -Sy bluez bluez-utils
$su pacman -Sy blueman
lsmod | grep btusb
#$su nano /etc/bluetooth/main.conf
$su rfkill unblock bluetooth
$su systemctl start bluetooth.service
$su systemctl enable bluetooth.service
$su rfkill list