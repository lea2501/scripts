#!/bin/ksh

doas pkg_add cmake gmake ninja sdl2 zmusic openal bzip2 jpeg libvpx

#application=ZMusic
#repository=https://github.com/coelckers/ZMusic.git
#export compile=
#mkdir -p ~/src
#cd ~/src || return
#if [ ! -d $application ]; then
#  git clone $repository
#  cd $application || return
#  export compile=true
#else
#  cd $application || return
#  #git pull
#  pwd
#  git fetch
#  LOCAL=$(git rev-parse HEAD)
#  REMOTE=$(git rev-parse @{u})
#  if [ ! $LOCAL = $REMOTE ]; then
#    pwd
#    echo "Need to pull"
#    git pull
#    export compile=true
#  fi
#fi
#
#if [ "$compile" = "true" ]; then
#  cd ~/src/$application || return
#  mkdir -pv build
#  cd build || return
#  cmake -DCMAKE_BUILD_TYPE=Release ..
#  cmake --build .
#  doas gmake install
#fi

application=Raze
repository=https://github.com/ZDoom/Raze.git
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
  export compile=true
else
  cd $application || return
  #git pull
  pwd
  git fetch
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse @{u})
  if [ ! $LOCAL = $REMOTE ]; then
    pwd
    echo "Need to pull"
    git pull
    export compile=true
  fi
fi

if [ "$compile" = "true" ]; then
  cd ~/src/$application || return
  mkdir -p build
  cd build || return
  cmake .. -DNO_GTK=ON -DDYN_OPENAL=NO -DHAVE_STDINT_H=1 -DNO_OPENMP=ON -DNO_FMOD=ON
  gmake
fi
