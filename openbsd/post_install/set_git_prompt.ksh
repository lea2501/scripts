#!/bin/ksh

mkdir -p ~/src
cd ~/src || return
git clone https://github.com/rkitover/sh-prompt-simple
cd sh-prompt-simple || return
. prompt.sh