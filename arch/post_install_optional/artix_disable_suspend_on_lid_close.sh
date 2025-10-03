#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su cp /etc/elogind/logind.conf /etc/elogind/logind.conf.bak
$su cat /etc/elogind/logind.conf | $su sed -e "s/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/" | $su tee /etc/elogind/logind.conf.edited
$su mv /etc/elogind/logind.conf.edited /etc/elogind/logind.conf
