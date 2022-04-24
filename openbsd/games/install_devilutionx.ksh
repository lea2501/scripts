#!/bin/ksh

doas pkg_add cmake sdl2 libsodium libpng bzip2 gmake

application=devilutionX
repository=https://github.com/diasurgical/devilutionX.git
mkdir -p ~/src
cd ~/src || return
if [[ ! -d $application ]]; then
  git clone $repository
  cd $application || return
else
  cd $application || return
  git pull
fi

cd ~/src/$application || return
cmake -S. -Bbuild -DCMAKE_MAKE_PROGRAM=gmake -DCMAKE_BUILD_TYPE=Release
cmake --build build -j $(sysctl -n hw.ncpuonline)
