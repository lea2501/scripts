#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

#https://jmeter.apache.org/download_jmeter

mkdir -p ~/bin
cd ~/bin || return
export JMETER_VERSION=$(curl --silent "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=jmeter" | grep "pkgver=" | sed 's/pkgver=//')
export JMETER_HOME=$HOME/bin/apache-jmeter-${JMETER_VERSION}
export JMETER_BIN="${JMETER_HOME}"/bin
export JMETER_DOWNLOAD_URL="https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz"

$su apt-get update
$su apt-get install -qq -y curl unzip
mkdir -p /tmp/dependencies
cd /tmp/dependencies || return
curl -L "${JMETER_DOWNLOAD_URL}" > /tmp/dependencies/apache-jmeter-"${JMETER_VERSION}".tgz
tar -xzf /tmp/dependencies/apache-jmeter-"${JMETER_VERSION}".tgz -C "$HOME"/bin/
rm -rf /tmp/dependencies
ln -s "$JMETER_BIN"/jmeter "$HOME"/bin/
