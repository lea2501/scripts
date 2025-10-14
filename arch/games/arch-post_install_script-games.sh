#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

options=(Y y N n)

# Section: games
read -rp "install games?: (y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_games.sh
fi

# Section: external games
read -rp "install external games?: (y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_frogcomposband.sh
  ./install_quakeinjector.sh
  ./install_prboom-plus.sh
fi

# Section: Add user to games group
read -rp "Add user to games group?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./add_user_to_games_group.sh
fi
