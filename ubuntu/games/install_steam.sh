#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get update && $su apt-get upgrade
$su apt-get install -y software-properties-common apt-transport-https wget
$su dpkg --add-architecture i386
$su apt-get install -y steam-installer

#cd || return
#wget -O- http://repo.steampowered.com/steam/archive/stable/steam.gpg | sudo gpg --dearmor | sudo tee /usr/share/keyrings/steam.gpg
#echo deb [arch=amd64 signed-by=/usr/share/keyrings/steam.gpg] http://repo.steampowered.com/steam/ stable steam | $su tee /etc/apt/sources.list.d/steam.list
#$su apt-get update
#$su apt-get install libgl1-mesa-dri:amd64 libgl1-mesa-dri:i386 libgl1-mesa-glx:amd64 libgl1-mesa-glx:i386 steam-launcher
