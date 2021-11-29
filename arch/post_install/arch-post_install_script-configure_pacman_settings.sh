#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Configuring standard pacman settings..."
$su cp /etc/pacman.conf /etc/pacman.conf.bak
$su cat /etc/pacman.conf | $su sed -e "s/ILoveCandy/#ILoveCandy/" | $su tee /etc/pacman.conf.edited
$su mv /etc/pacman.conf.edited /etc/pacman.conf
$su cat /etc/pacman.conf | $su sed -e "s/#VerbosePkgLists/VerbosePkgLists/" | $su tee /etc/pacman.conf.edited
$su mv /etc/pacman.conf.edited /etc/pacman.conf
$su cat /etc/pacman.conf | $su sed -e "s/#ParallelDownloads/ParallelDownloads/" | $su tee /etc/pacman.conf.edited
$su mv /etc/pacman.conf.edited /etc/pacman.conf
echo "Configuring standard pacman settings... DONE"