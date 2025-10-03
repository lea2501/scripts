#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

#$su pacman -S tlp tlp-openrc
#$su rc-update add tlp default
#$su rc-service tlp start

$su pacman -S tlp tlp-dinit
$su dinitctl enable tlp
$su dinitctl start tlp
