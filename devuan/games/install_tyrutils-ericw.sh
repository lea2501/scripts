#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get install -y libembree-dev libtbb-dev cmake build-essential g++
$su apt-get install -y qtbase5-dev python3-sphinx python3-venv python3-pip

python3 -m venv ~/.venvs/quake
source ~/.venvs/quake/bin/activate
pip install furo

application=ericw-tools
repository="https://github.com/ericwa/ericw-tools"
export compile=
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone --recursive $repository
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
  ./build-linux-64.sh
fi
