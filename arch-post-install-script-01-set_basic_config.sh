#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

# shellcheck disable=SC2116
username=$(echo "$USER")
options=(y n)
read -rp "Create .xinit file in user home directory?: (y|n)" createXinitFile
if [[ " "${options[@]}" " != *" $createXinitFile "* ]]; then
  echo "$createXinitFile: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Get dotfiles backups from Github?: (y|n)" getGithubDotfilesBackup
if [[ " "${options[@]}" " != *" $getGithubDotfilesBackup "* ]]; then
  echo "$getGithubDotfilesBackup: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Remove asking for sudo password?: (y|n)" removeAskingSudoPassword
if [[ " "${options[@]}" " != *" $removeAskingSudoPassword "* ]]; then
  echo "$removeAskingSudoPassword: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Configure pacman settings?: (y|n)" configurePacmanSettings
if [[ " "${options[@]}" " != *" $configurePacmanSettings "* ]]; then
  echo "$configurePacmanSettings: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi

# Setup system
if [ "$createXinitFile" = "y" ]; then
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

  echo "Creating ~/.xinitrc file..."
  cp /etc/X11/xinit/xinitrc ~/.xinitrc
  echo "Creating ~/.xinitrc file... DONE"
fi

if [ "$getGithubDotfilesBackup" = "y" ]; then
  echo "Getting backup dotfiles from github..."
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.xinitrc" -o .xinitrc.bak.0
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.Xresources" -o .Xresources.bak.0
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.Xdefaults" -o .Xdefaults.bak.0
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.tmux.conf" -o .tmux.conf.bak.0
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.vimrc" -o .vimrc.bak.0
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.xbindkeysrc" -o .xbindkeysrc.bak.0
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.picom.conf" -o .picom.conf.bak.0
  mkdir -p ~/.prboom-plus/ && cd ~/.prboom-plus/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.prboom-plus/prboom-plus.cfg" -o prboom-plus.cfg
  cd || return
  mkdir -p ~/.config/gzdoom/ && cd ~/.config/gzdoom/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/gzdoom/gzdoom.ini" -o gzdoom.ini
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/gzdoom/gzdoom_chex.ini" -o gzdoom_chex.ini
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/gzdoom/gzdoom_chex_mouseonly.ini" -o gzdoom_chex_mouseonly.ini
  cd || return
  mkdir -p ~/.config/i3/ && cd ~/.config/i3/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/i3/config" -o config.bak.0
  cd || return
  mkdir -p ~/.config/i3status/ && cd ~/.config/i3status/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/i3status/config" -o config.bak.0
  cd || return
  mkdir -p ~/.config/mc/ && cd ~/.config/mc/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mc/hotlist" -o hotlist.bak.0
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mc/ini" -o ini.bak.0
  cd || return
  mkdir -p ~/.config/mpv/ && cd ~/.config/mpv/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mpv/input.conf" -o input.conf.bak.0
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mpv/mpv.conf" -o mpv.conf.bak.0
  cd || return
  echo "Getting backup dotfiles from github... DONE"
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
