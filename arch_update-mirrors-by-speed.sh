#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script
echo "Creating backup of existing mirrorlist..."
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
echo "Creating backup of existing mirrorlist... DONE"

echo "Getting worldwide mirrorlist and sorting them by speed..."
echo -e "\033[33;5m THIS WILL TAKE SEVERAL MINUTES... \033[0m"
curl -s "https://archlinux.org/mirrorlist/?protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > ~/mirrorlist.new
sudo cp ~/mirrorlist.new /etc/pacman.d/mirrorlist
echo "Getting worldwide mirrorlist and sorting them by speed... DONE"
