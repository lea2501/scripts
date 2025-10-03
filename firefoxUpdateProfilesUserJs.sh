#!/bin/sh

# fail if any commands fails
set -e
# debug log
#set -x

apply_to_profiles() {
  if [ -n "$(ls ~/.mozilla/firefox/*.default* 2>/dev/null)" ];then
    for dir in ~/.mozilla/firefox/*.default*; do
      cp -v user.js.new "$dir"/user.js
      echo "Custom settings applied for profile in ${dir}."
    done
  fi

  if [ -n "$(ls ~/snap/firefox/common/.mozilla/firefox/*.default* 2>/dev/null)" ];then
    for dir in ~/snap/firefox/common/.mozilla/firefox/*.default*; do
      cp -v user.js.new "$dir"/user.js

      echo "Custom settings applied for profile in ${dir}."
    done
  fi

  rm -f user.js.new
}

apply_custom_settings() {
  # apply custom settings
  cp -v user.js user.js.new

  {
    echo ''
    echo '/** CUSTOM SETTINGS ***/'
    echo ''
    echo 'user_pref("media.peerconnection.enabled", false);'
    echo 'user_pref("media.navigator.enabled", false);'
    echo 'user_pref("extensions.pocket.enabled", false);'
    echo 'user_pref("privacy.query_stripping.enabled", true);'
    echo 'user_pref("privacy.trackingprotection.enabled", true);'
    echo 'user_pref("browser.safebrowsing.malware.enabled", false);'
    echo 'user_pref("browser.safebrowsing.phishing.enabled", false);'
    echo 'user_pref("javascript.options.wasm", false);'
    echo 'user_pref("browser.display.background_color", "#323232"'
    echo 'user_pref("browser.startup.homepage", "about:blank");'
    echo 'user_pref("security.fileuri.strict_origin_policy", false);'
    echo 'user_pref("media.autoplay.enabled", false);'
    echo 'user_pref("network.dnsCacheExpiration", 0);'
    echo ''
    echo '/** PERFORMANCE SETTINGS ***/'
    echo ''
    echo 'user_pref("layers.acceleration.force-enabled", true);'
    echo 'user_pref("gfx.webrender.enabled", true);'
  }>>user.js.new

  # Encrypted DNS - https://github.com/curl/curl/wiki/DNS-over-HTTPS#publicly-available-servers
  #{
  #  echo 'user_pref("network.trr.mode", 3);'
  #  echo 'user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");'
  #}>>user.js.new

}

dir=user.js
repo="https://github.com/arkenfox/${dir}.git"
mkdir -p ~/src
cd ~/src || return
if [ ! -d "$dir" ]; then
  git clone $repo
  cd "$dir" || return
  apply_custom_settings
  apply_to_profiles
else
  cd "$dir" || return
  git fetch
  LOCAL=$(git rev-parse HEAD)
  REMOTE=$(git rev-parse @{u})
  if [ ! $LOCAL = $REMOTE ]; then
    pwd
    echo "Need to pull"
    git pull
    apply_custom_settings
    apply_to_profiles
  else
    echo "no update needed"
  fi
fi
