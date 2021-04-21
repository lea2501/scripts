#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

# shellcheck disable=SC2116
username=$(echo "$USER")
read -rp "Create .xinit file in user home directory?: (y|n)" createXinitFile
read -rp "Remove asking for sudo password?: (y|n)" removeAskingSudoPassword
read -rp "Configure pacman settings?: (y|n)" configurePacmanSettings

if [[ $(pacman -Qs xorg-server) ]]; then
  echo "Installing xorg package..."
  sudo pacman -Sy --noconfirm xorg
  echo "Installing xorg package... DONE"
fi
if [[ $(pacman -Qs xorg-xinit) ]]; then
  echo "Installing xorg-xinit package..."
  sudo pacman -Sy --noconfirm xorg-xinit
  echo "Installing xorg-xinit package... DONE"
fi

# Setup system
if [ "$createXinitFile" = "y" ]; then
  echo "Creating ~/.xinitrc file..."
  cp /etc/X11/xinit/xinitrc ~/.xinitrc
  echo "Creating ~/.xinitrc file... DONE"
fi

if [ "$removeAskingSudoPassword" = "y" ]; then
  echo "Removing asking for sudo password for user..."
  echo "${username} ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo
  echo "Removing asking for sudo password for user... DONE"
fi

# Configure pacman
if [ "$configurePacmanSettings" = "y" ]; then
  echo "Configuring standard pacman settings..."
  sudo cp /etc/pacman.conf /etc/pacman.conf.bak
  sudo cat /etc/pacman.conf | sudo sed -e "s/ILoveCandy/#ILoveCandy/" | sudo tee /etc/pacman.conf.edited
  sudo mv /etc/pacman.conf.edited /etc/pacman.conf
  sudo cat /etc/pacman.conf | sudo sed -e "s/#VerbosePkgLists/VerbosePkgLists/" | sudo tee /etc/pacman.conf.edited
  sudo mv /etc/pacman.conf.edited /etc/pacman.conf
  echo "Configuring standard pacman settings... DONE"
fi
