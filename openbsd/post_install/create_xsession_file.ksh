#!/bin/ksh

{
    print "export ENV=\$HOME/.kshrc"
    print "PATH=\$HOME/bin/:\$HOME/src/scripts/:\$PATH"
    print "xsetroot -solid grey &"
    print "#xterm -bg black -fg white +sb &"
    print "cwm"
} >>$HOME/.xsession