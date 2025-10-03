#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
      export su="sudo"
fi

$su apt update
$su apt full-upgrade -y

cd || return
# system
$su apt-get -y --fix-missing install linux-cpupowe

$su cpupower frequency-info
$su cpupower frequency-set -g powersave
$su cpupower set -b 15
$su cpupower frequency-info
