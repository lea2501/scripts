#!/bin/ksh

doas pkg_add curl

cd || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/openbsd/.Xresources"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/openbsd/.Xdefaults"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/openbsd/.profile"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/openbsd/.xsession"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/openbsd/.kshrc"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/openbsd/.tmux.conf"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/openbsd/.cwmrc"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/openbsd/.vimrc"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/openbsd/.rtorrent.rc"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/openbsd/.picom.conf"
mkdir -p "$HOME"/.prboom-plus/ && cd "$HOME"/.prboom-plus/ || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.prboom-plus/prboom-plus.cfg"
cd || return
mkdir -p "$HOME"/.dosbox/ && cd "$HOME"/.dosbox/ || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.dosbox/dosbox-0.74-3.conf"
cd || return
mkdir -p "$HOME"/.config/gzdoom/ && cd "$HOME"/.config/gzdoom/ || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/gzdoom/gzdoom.ini"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/gzdoom/gzdoom_chex.ini"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/gzdoom/gzdoom_chex_mouseonly.ini"
cd || return
mkdir -p "$HOME"/.config/i3/ && cd "$HOME"/.config/i3/ || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/i3/config"
cd || return
mkdir -p "$HOME"/.config/i3status/ && cd "$HOME"/.config/i3status/ || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/i3status/config"
cd || return
mkdir -p "$HOME"/.config/mc/ && cd "$HOME"/.config/mc/ || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/mc/hotlist"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/mc/ini"
cd || return
mkdir -p "$HOME"/.config/mpv/ && cd "$HOME"/.config/mpv/ || return
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/mpv/input.conf"
curl -OL "https://notabug.org/lea2501/dotfiles/raw/main/.config/mpv/mpv.conf"
cd || return
mkdir -p "$HOME"/.config/geany/colorschemes/ && cd "$HOME"/.config/geany/colorschemes/ || return
curl -OL "https://raw.github.com/geany/geany-themes/master/colorschemes/bespin.conf"
cd || return
print "Get backup dotfiles from github... DONE"
