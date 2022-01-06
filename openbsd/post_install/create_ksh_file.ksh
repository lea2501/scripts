#!/bin/ksh

# fail if any commands fails
set -e
# debug log
#set -x

cd || return

{
    print "export PS1='$HOSTNAME (${PWD##*/}) $ '"
} >>$HOME/.kshrc

{
    print "alias syncthing='syncthing -no-browser'"
    print "alias ls='ls -lahF'"
} >>$HOME/.kshrc

#source ~/.bashrc