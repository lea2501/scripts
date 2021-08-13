#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Configuring standard pacman settings..."
sudo cp /etc/pacman.conf /etc/pacman.conf.bak
sudo cat /etc/pacman.conf | sudo sed -e "s/ILoveCandy/#ILoveCandy/" | sudo tee /etc/pacman.conf.edited
sudo mv /etc/pacman.conf.edited /etc/pacman.conf
sudo cat /etc/pacman.conf | sudo sed -e "s/#VerbosePkgLists/VerbosePkgLists/" | sudo tee /etc/pacman.conf.edited
sudo mv /etc/pacman.conf.edited /etc/pacman.conf
sudo cat /etc/pacman.conf | sudo sed -e "s/#ParallelDownloads/ParallelDownloads/" | sudo tee /etc/pacman.conf.edited
sudo mv /etc/pacman.conf.edited /etc/pacman.conf
echo "Configuring standard pacman settings... DONE"
