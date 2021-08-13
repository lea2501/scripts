#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

cloneRepo() {
  mkdir -p ~/src
  cd ~/src || return
  if [ ! -d "$1" ]; then
    git clone "$2"
    cd "$1" || return
  else
    cd "$1" || return
    git pull
  fi
}

download() {
  mkdir -p ~/bin
  cd ~/bin || return
  curl -o "$1" -L "$2"
}

# postman
download "postman-linux-x64.tar.gz" "https://dl.pstmn.io/download/latest/linux64"
sudo tar -xzf postman-linux-x64.tar.gz -C /opt
sudo ln -s /opt/Postman/Postman /usr/bin/postman
echo "[Desktop Entry]<br>Encoding=UTF-8<br>Name=Postman<br>Exec=/opt/Postman/app/Postman %U<br>Icon=/opt/Postman/app/resources/app/assets/icon.png<br>Terminal=false<br>Type=Application<br>Categories=Development;" > ~/.local/share/applications/Postman.desktop

# jmeter
export JMETER_VERSION="5.4.1"
export JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
export JMETER_BIN	"${JMETER_HOME}"/bin
export JMETER_DOWNLOAD_URL https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

sudo apt-get update && \
sudo apt-get install -qq -y curl unzip && \
mkdir -p /tmp/dependencies && \
curl -L --silent "${JMETER_DOWNLOAD_URL}" > /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz && \
mkdir -p /opt && \
tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt && \
rm -rf /tmp/dependencies

# Set global PATH such that "jmeter" command is found
{
  echo "export PATH=$PATH:$JMETER_BIN"
}>>~/.bashrc
source ~/.bashrc

# Allure
sudo apt install -y allure

# SchemaGuru
cd ~/bin || return
curl -O -L "$(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | jq -r ".assets[0].browser_download_url")"
unzip schema_guru_0.6.2.zip
