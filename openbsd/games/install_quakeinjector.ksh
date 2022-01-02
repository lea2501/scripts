#!/bin/ksh

cd ~/games || return
mkdir -p quakeinjector
cd ~/games/quakeinjector || return
mkdir -p bin
mkdir -p downloads
cd ~/games/quakeinjector/bin || return
curl -O -L $(curl -s https://api.github.com/repos/hrehfeld/QuakeInjector/releases/latest | jq -r ".assets[] | select(.name | test(\"quakeinjector\")) | .browser_download_url")
unzip quakeinjector*.zip