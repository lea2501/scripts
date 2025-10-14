#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get update -qq
$su apt-get install -qq -y curl

mkdir -p ~/bin
mkdir -p ~/Downloads
cd ~/Downloads || return
filename=chromedriver-linux64.zip
latest_release=$(curl -L "https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_STABLE")
latest_release_url="https://storage.googleapis.com/chrome-for-testing-public/${latest_release}/linux64/${filename}"
curl -OL "${latest_release_url}"
unzip -u ${filename}
mv chromedriver-linux64/chromedriver $HOME/bin/
