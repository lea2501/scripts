#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

cd || return

{
  echo "alias syncthing='syncthing -no-browser'"
  echo "alias dim=\"echo \$(tput cols)x\$(tput lines)\""
} >>~/.bash_aliases

{
  echo ""
  echo "# bash aliases"
  echo "if [ -f ~/.bash_aliases ]; then"
  echo "  . ~/.bash_aliases"
  echo "fi"
} >>~/.bashrc

source ~/.bashrc
