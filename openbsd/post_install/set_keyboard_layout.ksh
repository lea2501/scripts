#!/bin/ksh

cd || return
print "setxkbmap -layout latam -variant deadtilde" >>"$HOME"/.profile
print "Set keyboard layout... DONE"