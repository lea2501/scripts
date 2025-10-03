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

$su apt-get update -qq
$su apt-get install -qq -y curl

mkdir -p ~/bin
cd ~/bin || return
export JMETER_VERSION=$(curl --silent "https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=jmeter" | grep "pkgver=" | sed 's/pkgver=//')
export JMETER_HOME=$HOME/bin/apache-jmeter-${JMETER_VERSION}
export JMETER_BIN="${JMETER_HOME}"/bin
export JMETER_DOWNLOAD_URL="https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz"

# Remove previous file
rm -rf apache-jmeter-*.tgz
# Download new version
curl -OL "${JMETER_DOWNLOAD_URL}"
# Remove previous directory
rm -rf apache-jmeter-"${JMETER_VERSION}"
# Remove previous symlink
rm -f jmeter
# Extract new version
tar -xzf apache-jmeter-"${JMETER_VERSION}".tgz
# Create new symlink
ln -s "$JMETER_BIN"/jmeter "$HOME"/bin/

# SchemaGuru
mkdir -p ~/bin
cd ~/bin || return
curl -O -L "$(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | jq -r ".assets[0].browser_download_url")"
unzip schema_guru_0.6.2.zip
