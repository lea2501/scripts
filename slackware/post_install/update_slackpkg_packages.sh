#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# update and upgrade system
slackpkg update gpg
slackpkg update
slackpkg upgrade-all

read -rp "Enter kernel version if updated (leave empty if not updated): " kernel_version
if [[ -z $kernel_version ]]; then
  mkinitrd -c -k "$kernel_version" -f ext2 -r /dev/sda1 -o /boot/initrd.gz
fi