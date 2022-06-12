#!/bin/sh

# fail if any commands fails
set -e
# debug log
#set -x

dir=user.js
repo="https://github.com/arkenfox/${dir}.git"
mkdir -p ~/src
cd ~/src || return
if [ ! -d "$dir" ]; then
  git clone $repo
  cd "$dir" || return
else
  cd "$dir" || return
  git pull
fi

# apply custom settings
cp -v user.js user.js.bak
sed -i 's/\/\/ user_pref("media.peerconnection.enabled", false);/ user_pref("media.peerconnection.enabled", false);/g' user.js
sed -i 's/\/\/ user_pref("media.navigator.enabled", false);/ user_pref("media.navigator.enabled", false);/g' user.js
sed -i 's/\/\/ user_pref("extensions.pocket.enabled", false);/ user_pref("extensions.pocket.enabled", false);/g' user.js

cp -rv user.js ~/.mozilla/firefox/*default*/

mv -v user.js user.js.new
mv -v user.js.bak user.js