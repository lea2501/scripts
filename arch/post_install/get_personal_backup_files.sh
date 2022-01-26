#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Getting backup dotfiles from github..."
cd || return
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/arch/.xinitrc"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/arch/.Xresources"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/arch/.Xdefaults"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/arch/.bashrc"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/arch/.bash_profile"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/arch/.bash_aliases"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/arch/.tmux.conf"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/arch/.cwmrc"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/arch/.vimrc"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/arch/.rtorrent.rc"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/arch/.xbindkeysrc"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/arch/.picom.conf"
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