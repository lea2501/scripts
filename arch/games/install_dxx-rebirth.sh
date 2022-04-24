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

application=dxx-rebirth
repository=https://github.com/dxx-rebirth/dxx-rebirth.git
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
else
  cd $application || return
  git pull
fi

cd ~/src/ || return
cd dxx-rebirth || return
scons sdl2=1 builddir_prefix=build/
