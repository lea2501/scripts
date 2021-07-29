#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

# shellcheck disable=SC2116
username=$(echo "$USER")
options=(y n)
read -rp "Did you already installed sudo package?: (y|N)" installedSudo
if [[ " "${options[@]}" " != *" $installedSudo "* ]]; then
  echo "$installedSudo: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Create .xinit file in user home directory?: (y|N)" createXinitFile
if [[ " "${options[@]}" " != *" $createXinitFile "* ]]; then
  echo "$createXinitFile: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Get dotfiles backups from Github?: (y|N)" getGithubDotfilesBackup
if [[ " "${options[@]}" " != *" $getGithubDotfilesBackup "* ]]; then
  echo "$getGithubDotfilesBackup: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Remove asking for sudo password?: (Y|n)" removeAskingSudoPassword
if [[ " "${options[@]}" " != *" $removeAskingSudoPassword "* ]]; then
  echo "$removeAskingSudoPassword: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Disable login manager?: (Y|n)" disableLoginManager
if [[ " "${options[@]}" " != *" $disableLoginManager "* ]]; then
  echo "$disableLoginManager: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi

# Setup system
if [ "$installedSudo" = "n" ]; then
  echo "First, install the sudo package with the following command:"
  echo "    $ su -"
  echo "    # apt install sudo"
  echo ""
  echo "Please, install sudo and rerun the script..."
  exit 1
fi

if [ "$createXinitFile" = "y" ]; then
  echo "Installing xorg packages..."
  echo ""
  sudo apt install -y xorg
  echo "Installing xorg packages... DONE"

  echo "Creating ~/.xinitrc file..."
  cp /etc/X11/xinit/xinitrc ~/.xinitrc
  echo "Creating ~/.xinitrc file... DONE"
fi

if [ "$getGithubDotfilesBackup" = "y" ]; then
  echo "Getting backup dotfiles from github..."
  cd || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.xinitrc"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.Xresources"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.Xdefaults"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.tmux.conf"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.vimrc"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.xbindkeysrc"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.picom.conf"
  mkdir -p ~/.prboom-plus/ && cd ~/.prboom-plus/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.prboom-plus/prboom-plus.cfg"
  cd || return
  mkdir -p ~/.config/gzdoom/ && cd ~/.config/gzdoom/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/gzdoom/gzdoom.ini"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/gzdoom/gzdoom_chex.ini"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/gzdoom/gzdoom_chex_mouseonly.ini"
  cd || return
  mkdir -p ~/.config/i3/ && cd ~/.config/i3/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/i3/config"
  cd || return
  mkdir -p ~/.config/i3status/ && cd ~/.config/i3status/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/i3status/config"
  cd || return
  mkdir -p ~/.config/mc/ && cd ~/.config/mc/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mc/hotlist"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mc/ini"
  cd || return
  mkdir -p ~/.config/mpv/ && cd ~/.config/mpv/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mpv/input.conf"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mpv/mpv.conf"
  cd || return
  mkdir -p ~/.config/geany/colorschemes/ && cd ~/.config/geany/colorschemes/ || return
  curl -OL "https://raw.github.com/geany/geany-themes/master/colorschemes/bespin.conf"
  cd || return
  echo "Getting backup dotfiles from github... DONE"
fi

if [ "$removeAskingSudoPassword" = "y" ]; then
  echo "Removing asking for sudo password for user..."
  echo "${username} ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo
  echo "Removing asking for sudo password for user... DONE"
fi

# Disable login manager
if [ "$disableLoginManager" = "y" ]; then
  echo "Disabling login manager..."
  read -rp "Enter used init sistem name (systemd|openrc|runit)" init_system
  read -rp "Enter used login manager name (lightdm|sddm|slim|xdm)" login_manager
  if [ "$init_system" = "systemd" ]; then
    sudo systemctl disable $login_manager
  fi
  if [ "$init_system" = "openrc" ]; then
    sudo rc-update del $login_manager
  fi
  if [ "$init_system" = "runit" ]; then
    sudo rm /var/service/$login_manager
  fi
  echo "Disabling login manager... DONE"
fi