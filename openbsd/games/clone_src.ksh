#!/bin/ksh

mkdir -p ~/src
cd ~/src || return
if [[ ! -d "$1" ]]; then
  git clone "$2"
  cd "$1" || return
else
  cd "$1" || return
  git pull
fi
