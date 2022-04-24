#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# tools
paru -S postman-bin jmeter jmeter-plugins-manager allure-commandline

# schema guru
mkdir -p ~/bin && cd ~/bin || return
#curl -OL "$(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | grep "tag_name" | awk '{print "https://github.com/snowplow/schema-guru/archive/" substr($2, 2, length($2)-3) ".zip"}')"
curl -O -L $(curl -s https://api.github.com/repos/snowplow/schema-guru/releases/latest | jq -r ".assets[0].browser_download_url")
unzip schema_guru_0.6.2.zip
