#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

# wine
$su dpkg --add-architecture i386
$su apt-get update
$su apt-get -y --fix-missing install wine32 wine64
$su apt-get -y --fix-missing install wine32:i386
$su apt-get -y --fix-missing install libgl1-mesa-dri libglx-mesa0 mesa-vulkan-drivers
$su apt-get -y --fix-missing install libgl1-mesa-dri:i386 mesa-vulkan-drivers:i386 libfreetype6:i386
