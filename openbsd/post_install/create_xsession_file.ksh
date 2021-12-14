#!/bin/ksh

{
    print "export ENV=\$HOME/.kshrc"
    print "xsetroot -solid grey &"
    print "xterm -bg black -fg white +sb &"
    print "cwm"
} >>$HOME/.xsession
print "Create $HOME/.xinitrc file... DONE"