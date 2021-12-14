#!/bin/ksh

mkdir -p "$HOME"/src
print "Create $HOME/src directory... DONE"
cd "$HOME"/src || return
git clone git@github.com:lea2501/dotfiles.git
git clone git@github.com:lea2501/scripts.git
print "Clone Github repos... DONE"