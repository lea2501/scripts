#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get -y --fix-missing install curl
cd || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/.xinitrc"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/.Xresources"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/.Xdefaults"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/.bashrc"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/.bash_profile"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/.bash_aliases"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/.tmux.conf"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/.cwmrc"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/.vimrc"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/.rtorrent.rc"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/.xbindkeysrc"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/devuan/.picom.conf"
mkdir -p ~/.prboom-plus/ && cd ~/.prboom-plus/ || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.prboom-plus/prboom-plus.cfg"
cd || return
mkdir -p "$HOME"/.dosbox/ && cd "$HOME"/.dosbox/ || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.dosbox/dosbox-0.74-3.conf"
cd || return
mkdir -p ~/.config/gzdoom/ && cd ~/.config/gzdoom/ || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/gzdoom/gzdoom.ini"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/gzdoom/gzdoom_chex.ini"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/gzdoom/gzdoom_chex_mouseonly.ini"
cd || return
mkdir -p ~/.config/i3/ && cd ~/.config/i3/ || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/i3/config"
cd || return
mkdir -p ~/.config/i3status/ && cd ~/.config/i3status/ || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/i3status/config"
cd || return
mkdir -p ~/.config/mc/ && cd ~/.config/mc/ || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/mc/hotlist"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/mc/ini"
cd || return
mkdir -p ~/.config/mpv/ && cd ~/.config/mpv/ || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/mpv/input.conf"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/mpv/mpv.conf"
cd || return
mkdir -p ~/.config/geany/colorschemes/ && cd ~/.config/geany/colorschemes/ || return
curl -OL "https://raw.github.com/geany/geany-themes/master/colorschemes/bespin.conf"
cd || return
