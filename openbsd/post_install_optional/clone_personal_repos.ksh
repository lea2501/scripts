#!/bin/ksh

mkdir -p "$HOME"/src
print "Create $HOME/src directory... DONE"
cd ~/src || return
git clone git@notabug.org:lea2501/scripts.git
git clone git@notabug.org:lea2501/guides.git
git clone git@notabug.org:lea2501/dotfiles.git
git clone git@notabug.org:lea2501/quake-random-map-sh.git
git clone git@notabug.org:lea2501/doom-random-map-sh.git
