#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

# wine
$su dpkg --add-architecture i386
$su apt-get update
$su apt-get -y --fix-missing install lutris wine32 wine64 lgogdownloader