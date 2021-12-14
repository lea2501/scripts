#!/bin/ksh

cd || return
mkdir -p "$HOME"/bin
print "PATH=\$PATH:$HOME/bin/" >>"$HOME"/.profile
source "$HOME"/.profile
print "Create user 'bin' directory... DONE"