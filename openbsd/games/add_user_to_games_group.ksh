#!/bin/ksh

print -n "Enter user name: ";read -r username; print ""
doas usermod -G games $username
