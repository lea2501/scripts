#!/bin/bash

# fail if any commands fails
set -e
# debug log
set -x

#https://jmeter.apache.org/download_jmeter

mkdir -p ~/bin
cd ~/bin || return
export JMETER_VERSION="5.4.1"
export JMETER_HOME=$HOME/bin/apache-jmeter-${JMETER_VERSION}
export JMETER_BIN="${JMETER_HOME}"/bin
export JMETER_DOWNLOAD_URL="https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz"

sudo apt-get update
sudo apt-get install -qq -y curl unzip
mkdir -p /tmp/dependencies
cd /tmp/dependencies || return
curl -L "${JMETER_DOWNLOAD_URL}" > /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz
tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C "$HOME"/bin/
rm -rf /tmp/dependencies
ln -s "$JMETER_BIN"/jmeter "$HOME"/bin/
