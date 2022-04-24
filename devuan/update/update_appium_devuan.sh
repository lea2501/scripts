#!/bin/bash

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

cd || return
$su apt-get -y --fix-missing install npm cmake
$su npm install -g appium --unsafe-perm=true --allow-root
$su npm install -g appium-doctor
#$su npm install -g opencv4nodejs --unsafe-perm=true --allow-root
npm install wd
cd - || return
