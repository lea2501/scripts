#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su pacman -S nvidia nvidia-utils xorg-xrandr
paru -S envycontrol

options=(integrated hybrid nvidia)
read -rp "Set nvidia optimus configuration: (integrated|hybrid|nvidia)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
case "$option" in
  *integrated*)
    $su envycontrol --switch integrated
    ;;
  *hybrid*)
    $su envycontrol --switch hybrid
    ;;
  *nvidia*)
    $su envycontrol --switch nvidia
    ;;
esac

$su