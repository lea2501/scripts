#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Creating ~/repos directory..."
mkdir -p ~/repos
echo "Creating ~/repos directory... DONE"
echo "Cloning Flow Factory repos..."
cd ~/repos || return
git clone -b develop git@bitbucket.org:tecoflowfactory/flow-android.git
git clone -b develop git@bitbucket.org:tecoflowfactory/flow-android-tv.git
git clone -b releases git@bitbucket.org:tecoflowfactory/flow-android-core-library.git
git clone -b develop git@bitbucket.org:tecoflowfactory/flow-smart-tv.git
git clone -b develop git@bitbucket.org:tecoflowfactory/webclient.git
git clone -b develop git@bitbucket.org:tecoflowfactory/ios.git
git clone -b develop git@bitbucket.org:tecoflowfactory/flow-iot.git
git clone -b develop git@bitbucket.org:tecoflowfactory/iot-web.git
echo "Cloning Flow Factory repos... DONE"