#!/bin/ksh

cd || return
mkdir -p "$HOME"/bin
print "PATH=\$HOME/bin/:\$HOME/src/scripts/:\$PATH" >>"$HOME"/.xsession