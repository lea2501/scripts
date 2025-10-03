#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi
if [[ -z $init ]]; then
  export init="dinit"
fi

if [[ "$init" == "dinit" ]]; then
  #$su pacman -S docker docker-openrc
  #$su rc-update add docker default
  #$su rc-service docker start
  $su pacman -S docker docker-dinit
  $su dinitctl enable docker
  $su dinitctl start docker
fi
$su groupadd docker
$su gpasswd -a $USER docker