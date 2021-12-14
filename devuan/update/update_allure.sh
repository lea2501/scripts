#!/bin/bash

echo "installing allure..."
mkdir -p ~/bin
cd ~/bin || return

github_api_response=$(curl -s "https://api.github.com/repos/allure-framework/allure2/releases/latest")
download_url=$(echo $github_api_response | jq -r ".assets[] | select(.name | test(\"tgz\")) | .browser_download_url")
echo $download_url
download_filename=$(echo ${github_api_response} | jq -r ".assets[] | select(.name | test(\"tgz\")) | .name")
echo $download_filename

curl -O -L "$download_url"
tar -xzvf $download_filename
directory_name=$(basename $download_filename .tgz)

rm -f ~/bin/allure
ln -s ~/bin/$directory_name/bin/allure ~/bin/
allure --version

cd - || return
echo "installing allure... DONE"
