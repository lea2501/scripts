#!/bin/sh
# Hardened + Minimal Firefox setup (Cheru edition)
# Combina arkenfox/user.js con ajustes personalizados y minimalistas
# Compatible con Debian, Devuan y OpenBSD.

set -e  # Fail fast
#set -x  # Debug mode

repo="https://github.com/arkenfox/user.js.git"
srcdir=~/src
userjsdir="$srcdir/user.js"

# ------------------------------------------------------------------------------
# Create two Firefox profiles if they don't exist yet
# ------------------------------------------------------------------------------
create_profiles() {
  echo "Checking Firefox profiles..."

  # Detect existing profiles
  profiles_ini="${HOME}/.mozilla/firefox/profiles.ini"
  if [ ! -f "$profiles_ini" ]; then
    mkdir -p "${HOME}/.mozilla/firefox"
    echo "[General]" > "$profiles_ini"
    echo "StartWithLastProfile=1" >> "$profiles_ini"
  fi

  if ! grep -q 'Name=default' "$profiles_ini" 2>/dev/null; then
    echo "Creating profile: default"
    firefox --CreateProfile "default ${HOME}/.mozilla/firefox/default-profile" >/dev/null
  fi

  if ! grep -q 'Name=nojs' "$profiles_ini" 2>/dev/null; then
    echo "Creating profile: nojs"
    firefox --CreateProfile "nojs ${HOME}/.mozilla/firefox/nojs-profile" >/dev/null
  fi
}

# ------------------------------------------------------------------------------
# Apply user.js to all matching profiles
# ------------------------------------------------------------------------------
apply_to_profiles() {
  echo "Applying custom user.js to all detected Firefox profiles..."

  for dir in ~/.mozilla/firefox/*.default* ~/.mozilla/firefox/*-profile; do
    [ -d "$dir" ] || continue
    cp -v user.js.new "$dir/user.js"
    echo "Applied to: $dir"
  done

  for dir in ~/snap/firefox/common/.mozilla/firefox/*.default*; do
    [ -d "$dir" ] || continue
    cp -v user.js.new "$dir/user.js"
    echo "Applied to: $dir"
  done

  rm -f user.js.new
}

remove_last_used_search_engine() {
  rm ~/.mozilla/firefox/*/search.json.mozlz4 2>/dev/null || true
}

# ------------------------------------------------------------------------------
# Merge Cheru's custom settings with arkenfox/user.js
# ------------------------------------------------------------------------------
apply_custom_settings() {
  # apply custom settings
  cp -v user.js user.js.new

  {
    echo ''
    echo '/************************************************************************/'
    echo '/*** CHERU CUSTOM SETTINGS (ARKENFOX-SAFE) ******************************/'
    echo '/************************************************************************/'
    echo ''

    echo '/** HABITS & PRIVACY (NON-CONFLICTING) ***/'
    echo 'user_pref("browser.privatebrowsing.autostart", true);'
    echo 'user_pref("browser.formfill.enable", false);'
    echo 'user_pref("signon.rememberSignons", false);'
    echo 'user_pref("signon.autofillForms", false);'
    echo ''

    echo '/** UI & UX ***/'
    echo 'user_pref("browser.startup.homepage", "about:blank");'
    echo 'user_pref("browser.newtabpage.enabled", false);'
    echo 'user_pref("browser.urlbar.trimURLs", false);'
    echo 'user_pref("layout.spellcheckDefault", 0);'
    echo 'user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);'
    echo ''

    echo '/** DEBLOATING (SAFE) ***/'
    echo 'user_pref("extensions.pocket.enabled", false);'
    echo 'user_pref("browser.discovery.enabled", false);'
    echo 'user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);'
    echo 'user_pref("browser.messaging-system.whatsNewPanel.enabled", false);'
    echo 'user_pref("browser.shell.checkDefaultBrowser", false);'
    echo ''

    echo '/** SEARCH (ARKENFOX COMPATIBLE) ***/'
    echo 'user_pref("browser.search.defaultenginename", "DuckDuckGo");'
    echo 'user_pref("browser.search.defaultenginename.private", "DuckDuckGo");'
    echo 'user_pref("browser.search.hiddenOneOffs", "Google,Bing,Yahoo,Amazon.com,eBay");'
    echo 'user_pref("browser.search.suggest.enabled", false);'
    echo ''

    echo '/** URLBAR SUGGESTIONS ***/'
    echo 'user_pref("browser.urlbar.suggest.bookmark", false);'
    echo 'user_pref("browser.urlbar.suggest.history", false);'
    echo 'user_pref("browser.urlbar.suggest.openpage", false);'
    echo 'user_pref("browser.urlbar.suggest.engines", false);'
    echo 'user_pref("browser.urlbar.suggest.quickactions", false);'
    echo 'user_pref("browser.urlbar.suggest.topsites", false);'
    echo 'user_pref("browser.urlbar.suggest.recentsearches", false);'
    echo 'user_pref("browser.urlbar.quicksuggest.enabled", false);'
    echo ''

    echo '/** SIDEBAR ***/'
    echo 'user_pref("sidebar.revamp", false);'
    echo ''

    echo '/** OPTIONAL / REMINDERS ***/'
    echo '# user_pref("javascript.options.wasm", false);'
    echo '# user_pref("network.trr.mode", 3);'
    echo ''

    echo '/************************************************************************/'
    echo '/*** END CHERU CUSTOM SETTINGS *****************************************/'
    echo '/************************************************************************/'
  } >> user.js.new
}

# ------------------------------------------------------------------------------
# Apply additional tweaks for NoJS profile only
# ------------------------------------------------------------------------------
apply_nojs_profile_tweaks() {
  nojs_dir="${HOME}/.mozilla/firefox/nojs-profile"
  if [ -d "$nojs_dir" ]; then
    echo "Applying NoJS-specific tweaks..."
    {
      echo ''
      echo '/*** NOJS PROFILE ADDITIONS ***/'
      echo 'user_pref("javascript.enabled", false);'
      echo 'user_pref("permissions.default.image", 2);'
      echo 'user_pref("permissions.default.stylesheet", 2);'
      echo '/*** END NOJS PROFILE ***/'
    } >> "$nojs_dir/user.js"
  fi
}

# ------------------------------------------------------------------------------
# Main logic
# ------------------------------------------------------------------------------
mkdir -p "$srcdir"
cd "$srcdir"

create_profiles

if [ ! -d "$userjsdir" ]; then
  echo "Cloning arkenfox/user.js..."
  git clone "$repo"
  cd "$userjsdir"
  remove_last_used_search_engine
  apply_custom_settings
  apply_to_profiles
  apply_nojs_profile_tweaks
else
  cd "$userjsdir"
  echo "Checking for updates..."
  git fetch origin
  local_rev=$(git rev-parse HEAD)
  remote_rev=$(git rev-parse origin/HEAD)

  if [ "$local_rev" != "$remote_rev" ]; then
    echo "Updating arkenfox repository..."
    git pull
    remove_last_used_search_engine
    apply_custom_settings
    apply_to_profiles
    apply_nojs_profile_tweaks
  else
    echo "No updates needed."
  fi
fi
