#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

echo "Installing external packages 'testing tools'..."
# postman
#mkdir -p ~/bin
#cd ~/bin || return
#curl -o "Postman-linux-x64.tar.gz" -L "https://dl.pstmn.io/download/latest/linux64"
#$su tar -xzf postman-linux-x64.tar.gz -C /opt
#$su ln -s /opt/Postman/Postman /usr/bin/postman
#echo "[Desktop Entry]<br>Encoding=UTF-8<br>Name=Postman<br>Exec=/opt/Postman/app/Postman %U<br>Icon=/opt/Postman/app/resources/app/assets/icon.png<br>Terminal=false<br>Type=Application<br>Categories=Development;" > ~/.local/share/applications/Postman.desktop

# postman
mkdir -p ~/bin
cd ~/bin || return
curl -o "Postman-linux-x64.tar.gz" -L "https://dl.pstmn.io/download/latest/linux64"
tar -xzvf Postman-linux-x64.tar.gz
ln -s Postman/app/Postman postman

# jmeter
mkdir -p ~/bin
cd ~/bin || return
export JMETER_VERSION="5.4.3"
export JMETER_HOME=$HOME/bin/apache-jmeter-${JMETER_VERSION}
export JMETER_BIN="${JMETER_HOME}"/bin
export JMETER_DOWNLOAD_URL=https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

$su apt-get update && \
$su apt-get install -qq -y curl unzip && \
mkdir -p /tmp/dependencies && \
curl -L --silent "${JMETER_DOWNLOAD_URL}" > /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz && \
tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C "$HOME"/bin/ && \
rm -rf /tmp/dependencies
ln -s "$JMETER_BIN"/jmeter "$HOME"/bin/

# Allure
$su apt-get -y install allure

# SchemaGuru
mkdir -p ~/bin
cd ~/bin || return
curl -O -L "$(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | jq -r ".assets[0].browser_download_url")"
unzip schema_guru_0.6.2.zip
echo "Installing external packages 'testing tools'... DONE"