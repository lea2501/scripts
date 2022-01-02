#!/bin/ksh

{
    print "export ENV=\$HOME/.kshrc"
    print ". ~/source/repos/sh-prompt-simple/prompt.sh"
    print "xsetroot -solid grey &"
    print "xterm -bg black -fg white +sb &"
    print "cwm"
} >>$HOME/.xsession