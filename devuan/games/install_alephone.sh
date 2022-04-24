#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

mkdir -p ~/bin
cd ~/bin || return
curl -OL "$(curl -s https://api.github.com/repos/Aleph-One-Marathon/alephone/releases/latest | jq -r ".assets[] | select(.name | test(\"tar.bz2\")) | .browser_download_url" | head -n 1)"
tar -zxvf AlephOne-*.tar.gz

#mkdir -p ~/src
#cd ~/src
#git clone https://github.com/Aleph-One-Marathon/alephone.git
#cd alephone
#./autogen.sh
#make

mkdir -p ~/games/alephone
cd ~/games/alephone
curl -s https://api.github.com/repos/Aleph-One-Marathon/alephone/releases/latest | jq -r ".assets[] | select(.name | test(\"Data.zip\")) | .browser_download_url" | xargs -n1 curl -OL

unzip Marathon-*-Data.zip -d marathon
mv marathon/Marathon/* marathon/
rm -rf marathon/Marathon

unzip Marathon2-*-Data.zip -d marathon2
mv marathon2/Marathon\ 2/* marathon2/
rm -rf marathon2/Marathon\ 2

unzip MarathonInfinity-*-Data.zip -d infinity
mv infinity/Marathon\ Infinity/* infinity/
rm -rf infinity/Marathon\ Infinity

curl -OL "http://files3.bungie.org/trilogy/MarathonRED.zip"
unzip MarathonRED.zip -d marathon_red
mv marathon_red/Marathon\ RED/* marathon_red/
rm -rf marathon_red/Marathon\ RED

curl -OL "http://files5.bungie.org/marathon/marathonRubiconX.zip"
unzip marathonRubiconX.zip -d rubicon_x/
mv rubicon_x/Rubicon\ X\ ƒ/* rubicon_x/
rm -rf rubicon_x/__MACOSX/ rubicon_x/Rubicon\ X\ ƒ/

curl -o "Marathon_Phoenix.zip" -L "http://simplici7y.com/items/marathon-phoenix-2/download"
unzip Marathon_Phoenix.zip -d phoenix/
mv phoenix/Marathon\ Phoenix/* phoenix/
rm -rf phoenix/Marathon\ Phoenix/

curl -OL "http://eternal.bungie.org/files/_releases/EternalXv121.zip"
unzip EternalXv121.zip -d eternal/
mv eternal/Eternal\ 1.2.1/* eternal/
rm -rf eternal/__MACOSX/ eternal/Eternal\ 1.2.1/

curl -OL "http://files3.bungie.org/trilogy/MarathonEvil.zip"
unzip MarathonEvil.zip -d evil/
mv evil/Marathon\ EVIL/* evil/
rm -rf evil/Marathon\ EVIL/

curl -o "AOPID_v1.2.zip" -L "https://simplici7y.com/items/aleph-one-pathways-into-darkness/download"
unzip AOPID_v1.2.zip -d pathways_into_darkness/
mv pathways_into_darkness/AOPID_v1.2/
rm -rf pathways_into_darkness/AOPID_v1.2/
