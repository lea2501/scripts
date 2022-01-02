#!/bin/ksh

print "export LC_CTYPE=en_US.UTF-8" >>"$HOME"/.profile
print "export GTK_IM_MODULE=xim # without this GTK apps will use their own compose key settings" >>"$HOME"/.profile
print "export LESSCHARSET=utf-8 # not strictly necessary, but for when you view Unicode files in less" >>"$HOME"/.profile