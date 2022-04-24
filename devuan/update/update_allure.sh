#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su apt-get update -qq
$su apt-get install -qq -y curl

mkdir -p ~/bin
cd ~/bin || return

github_api_response=$(curl -s "https://api.github.com/repos/allure-framework/allure2/releases/latest")
download_url=$(echo $github_api_response | jq -r ".assets[] | select(.name | test(\"tgz\")) | .browser_download_url")
echo $download_url
download_filename=$(echo ${github_api_response} | jq -r ".assets[] | select(.name | test(\"tgz\")) | .name")
echo $download_filename

# Remove previous file
rm -rf allure-*.tgz
# Download new version
curl -O -L "$download_url"
# Remove previous directory
rm -rf allure-*/
# Remove previous symlink
rm -f allure
# Extract new version
tar -xzvf $download_filename
directory_name=$(basename $download_filename .tgz)
# Create new symlink
ln -s ~/bin/$directory_name/bin/allure ~/bin/
allure --version
