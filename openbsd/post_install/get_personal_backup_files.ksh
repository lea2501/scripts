#!/bin/ksh

doas pkg_add curl

cd || return
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.xinitrc"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.Xresources"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.Xdefaults"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.tmux.conf"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.vimrc"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.xbindkeysrc"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.picom.conf"
mkdir -p "$HOME"/.prboom-plus/ && cd "$HOME"/.prboom-plus/ || return
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.prboom-plus/prboom-plus.cfg"
cd || return
mkdir -p "$HOME"/.config/gzdoom/ && cd "$HOME"/.config/gzdoom/ || return
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/gzdoom/gzdoom.ini"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/gzdoom/gzdoom_chex.ini"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/gzdoom/gzdoom_chex_mouseonly.ini"
cd || return
mkdir -p "$HOME"/.config/i3/ && cd "$HOME"/.config/i3/ || return
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/i3/config"
cd || return
mkdir -p "$HOME"/.config/i3status/ && cd "$HOME"/.config/i3status/ || return
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/i3status/config"
cd || return
mkdir -p "$HOME"/.config/mc/ && cd "$HOME"/.config/mc/ || return
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mc/hotlist"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mc/ini"
cd || return
mkdir -p "$HOME"/.config/mpv/ && cd "$HOME"/.config/mpv/ || return
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mpv/input.conf"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mpv/mpv.conf"
cd || return
mkdir -p "$HOME"/.config/geany/colorschemes/ && cd "$HOME"/.config/geany/colorschemes/ || return
curl -OL "https://raw.github.com/geany/geany-themes/master/colorschemes/bespin.conf"
cd || return
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.cwmrc-linux"
curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.cwmrc-openbsd"
cd || return
print "Get backup dotfiles from github... DONE"