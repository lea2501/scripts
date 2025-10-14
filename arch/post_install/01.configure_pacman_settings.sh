#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su cp /etc/pacman.conf /etc/pacman.conf.bak
$su cat /etc/pacman.conf | $su sed -e "s/ILoveCandy/#ILoveCandy/" | $su tee /etc/pacman.conf.edited
$su mv /etc/pacman.conf.edited /etc/pacman.conf
$su cat /etc/pacman.conf | $su sed -e "s/#VerbosePkgLists/VerbosePkgLists/" | $su tee /etc/pacman.conf.edited
$su mv /etc/pacman.conf.edited /etc/pacman.conf
$su cat /etc/pacman.conf | $su sed -e "s/#ParallelDownloads/ParallelDownloads/" | $su tee /etc/pacman.conf.edited
$su mv /etc/pacman.conf.edited /etc/pacman.conf
