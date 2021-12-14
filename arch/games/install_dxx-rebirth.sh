#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su pacman -S --noconfirm scons sdl sdl_image sdl_mixer physfs

./clone_src.sh dxx-rebirth https://github.com/dxx-rebirth/dxx-rebirth.git
cd ~/src/ || return
cd dxx-rebirth || return
scons sdl2=1 builddir_prefix=build/
echo "Installing dxx-rebirth... DONE"