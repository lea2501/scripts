#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su pacman -S pacman-contrib

FILE=/etc/pacman.d/mirrorlist.backup
if [ -f "$FILE" ]; then
    echo "Mirrorlist $FILE backup file exists."
else
    echo "Mirrorlist $FILE backup file does not exists. Creating backup"
    $su cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
fi

echo -e "\033[33;5m THIS WILL TAKE SEVERAL MINUTES... \033[0m"
curl -s "https://archlinux.org/mirrorlist/?protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > ~/mirrorlist.new
$su cp ~/mirrorlist.new /etc/pacman.d/mirrorlist
