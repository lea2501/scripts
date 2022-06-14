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
sed -i 's/\/\/ user_pref("privacy.query_stripping.enabled", true);/ user_pref("privacy.query_stripping.enabled", true);/g' user.js
sed -i 's/\/\/ user_pref("privacy.trackingprotection.enabled", true);/ user_pref("privacy.trackingprotection.enabled", true);/g' user.js
sed -i 's/\/\/ user_pref("media.peerconnection.enabled", false);/ user_pref("media.peerconnection.enabled", false);/g' user.js
sed -i 's/\/\/ user_pref("browser.safebrowsing.malware.enabled", false);/ user_pref("browser.safebrowsing.malware.enabled", false);/g' user.js
sed -i 's/\/\/ user_pref("browser.safebrowsing.phishing.enabled", false);/ user_pref("browser.safebrowsing.phishing.enabled", false);/g' user.js
sed -i 's/\/\/ user_pref("javascript.options.wasm", false);/ user_pref("javascript.options.wasm", false);/g' user.js

# Encrypted DNS - https://github.com/curl/curl/wiki/DNS-over-HTTPS#publicly-available-servers
sed -i 's/\/\/ user_pref("network.trr.mode", 5);/ user_pref("network.trr.mode", 3);/g' user.js
echo ' user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");' >> user.js

cp -rv user.js ~/.mozilla/firefox/*default*/

mv -v user.js user.js.new
mv -v user.js.bak user.js