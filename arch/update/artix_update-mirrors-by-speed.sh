#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su pacman -S pacman-contrib

arch_file=/etc/pacman.d/mirrorlist-arch.backup
artix_file=/etc/pacman.d/mirrorlist.backup
if [ -f "$artix_file" ]; then
    echo "Mirrorlist $artix_file backup file exists."
else
    echo "Mirrorlist $artix_file backup file does not exists. Creating backup"
    $su cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
fi
if [ -f "$arch_file" ]; then
    echo "Mirrorlist $arch_file backup file exists."
else
    echo "Mirrorlist $arch_file backup file does not exists. Creating backup"
    $su cp /etc/pacman.d/mirrorlist-arch /etc/pacman.d/mirrorlist-arch.backup
fi

echo -e "\033[33;5m THIS WILL TAKE SEVERAL MINUTES... \033[0m"
curl -s "https://gitea.artixlinux.org/packagesA/artix-mirrorlist/raw/branch/master/trunk/mirrorlist" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > ~/mirrorlist.new
$su cp ~/mirrorlist.new /etc/pacman.d/mirrorlist

echo -e "\033[33;5m THIS WILL TAKE SEVERAL MINUTES... \033[0m"
curl -s "https://archlinux.org/mirrorlist/?protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > ~/mirrorlist-arch.new
$su cp ~/mirrorlist-arch.new /etc/pacman.d/mirrorlist-arch