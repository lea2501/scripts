#!/bin/ksh

doas pkg_add cmake sdl2 libsodium libpng bzip2 gmake

application=devilutionX
repository=https://github.com/diasurgical/devilutionX.git
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
  export compile=true
else
  cd $application || return
  git fetch
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse @{u})
  if [ ! $LOCAL = $REMOTE ]; then
    echo "Need to pull"
    git pull
    export compile=true
  fi
fi

if [ "$compile" = "true" ]; then
  cd ~/src/$application || return
  cmake -S. -Bbuild -DCMAKE_MAKE_PROGRAM=gmake -DCMAKE_BUILD_TYPE=Release
  cmake --build build -j $(sysctl -n hw.ncpuonline)
fi
