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
    echo '/*** CHERU CUSTOM SETTINGS **********************************************/'
    echo '/************************************************************************/'
    echo ''

    echo '/** PRIVACY & SECURITY ***/'
    echo 'user_pref("media.peerconnection.enabled", false);'
    echo 'user_pref("media.navigator.enabled", false);'
    echo 'user_pref("privacy.query_stripping.enabled", true);'
    echo 'user_pref("privacy.trackingprotection.enabled", true);'
    echo 'user_pref("browser.safebrowsing.malware.enabled", false);'
    echo 'user_pref("browser.safebrowsing.phishing.enabled", false);'
    echo 'user_pref("security.fileuri.strict_origin_policy", false);'
    echo 'user_pref("media.autoplay.enabled", false);'
    echo 'user_pref("network.dnsCacheExpiration", 0);'
    echo 'user_pref("browser.privatebrowsing.autostart", true);'
    echo 'user_pref("browser.formfill.enable", false);'
    echo 'user_pref("places.history.enabled", false);'
    echo ''

    echo '/** DEBLOATING & CLEANUP ***/'
    echo 'user_pref("extensions.pocket.enabled", false);'
    echo 'user_pref("identity.fxaccounts.enabled", false);'
    echo 'user_pref("browser.newtabpage.activity-stream.enabled", false);'
    echo 'user_pref("browser.tabs.firefox-view", false);'
    echo 'user_pref("browser.tabs.firefox-view-next", false);'
    echo 'user_pref("extensions.screenshots.disabled", true);'
    echo 'user_pref("browser.discovery.enabled", false);'
    echo 'user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);'
    echo 'user_pref("browser.messaging-system.whatsNewPanel.enabled", false);'
    echo 'user_pref("browser.shell.checkDefaultBrowser", false);'
    echo 'user_pref("browser.urlbar.suggest.topsites", false);'
    echo ''

    echo '/** TELEMETRY & DATA COLLECTION ***/'
    echo 'user_pref("toolkit.telemetry.enabled", false);'
    echo 'user_pref("toolkit.telemetry.unified", false);'
    echo 'user_pref("toolkit.telemetry.archive.enabled", false);'
    echo 'user_pref("toolkit.telemetry.updatePing.enabled", false);'
    echo 'user_pref("toolkit.telemetry.newProfilePing.enabled", false);'
    echo 'user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);'
    echo 'user_pref("toolkit.telemetry.bhrPing.enabled", false);'
    echo 'user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);'
    echo 'user_pref("datareporting.healthreport.uploadEnabled", false);'
    echo 'user_pref("datareporting.policy.dataSubmissionEnabled", false);'
    echo 'user_pref("datareporting.policy.dataSubmissionPolicyBypassNotification", true);'
    echo 'user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);'
    echo 'user_pref("toolkit.telemetry.server", "");'
    echo 'user_pref("browser.ping-centre.telemetry", false);'
    echo 'user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);'
    echo 'user_pref("browser.newtabpage.activity-stream.telemetry", false);'
    echo 'user_pref("app.shield.optoutstudies.enabled", false);'
    echo 'user_pref("app.normandy.enabled", false);'
    echo 'user_pref("app.normandy.api_url", "");'
    echo ''

    echo '/** PERFORMANCE ***/'
    echo 'user_pref("layers.acceleration.force-enabled", true);'
    echo 'user_pref("gfx.webrender.enabled", true);'
    echo ''

    echo '/** VISUALS & UI ***/'
    echo 'user_pref("browser.display.background_color", "#323232");'
    echo 'user_pref("browser.startup.homepage", "about:blank");'
    echo 'user_pref("browser.theme.content-theme", 0);'
    echo 'user_pref("browser.theme.toolbar-theme", 0);'
    echo 'user_pref("layout.css.prefers-color-scheme.content-override", 0);'
    echo ''

    echo '/** SPELLCHECK ***/'
    echo 'user_pref("layout.spellcheckDefault", 0);'
    echo ''

    echo '/** PICTURE-IN-PICTURE ***/'
    echo 'user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);'
    echo ''

    echo '/** PASSWORDS ***/'
    echo 'user_pref("signon.rememberSignons", false);'
    echo 'user_pref("signon.autofillForms", false);'
    echo ''

    echo '/** SEARCH SETTINGS ***/'
    echo 'user_pref("keyword.enabled", false);'                     # Desactiva búsquedas automáticas en la barra de direcciones
    echo 'user_pref("browser.search.defaultenginename", "DuckDuckGo");'
    echo 'user_pref("browser.search.defaultenginename.private", "DuckDuckGo");'
    echo 'user_pref("browser.search.defaultengine", "DuckDuckGo");'
    echo 'user_pref("browser.search.defaultengine.private", "DuckDuckGo");'
    echo 'user_pref("browser.urlbar.placeholderName", "DuckDuckGo");'
    echo 'user_pref("browser.urlbar.placeholderName.private", "DuckDuckGo");'
    echo 'user_pref("browser.search.hiddenOneOffs", "Google,Bing,Yahoo,Amazon.com,eBay");'
    echo 'user_pref("browser.search.update", false);'
    echo 'user_pref("browser.search.suggest.enabled", false);'
    echo 'user_pref("browser.urlbar.suggest.searches", false);'
    echo 'user_pref("browser.urlbar.suggest.history", false);'
    echo 'user_pref("browser.urlbar.suggest.bookmark", false);'
    echo 'user_pref("browser.urlbar.suggest.openpage", false);'
    echo 'user_pref("browser.urlbar.suggest.engines", false);'
    echo 'user_pref("browser.urlbar.suggest.quickactions", false);'
    echo 'user_pref("browser.urlbar.suggest.topsites", false);'
    echo 'user_pref("browser.urlbar.suggest.recentsearches", false);'
    echo 'user_pref("browser.urlbar.quicksuggest.enabled", false);'
    echo 'user_pref("browser.urlbar.recentsearches.featureGate", false);'
    echo 'user_pref("browser.urlbar.trimURLs", false);'             # Mantiene el "http://" visible (más explícito)
    echo ''

    echo '/** ADDRESS BAR ***/'
    echo 'user_pref("browser.urlbar.quickactions.enabled", false);'
    echo 'user_pref("browser.urlbar.quickactions.showPrefs", false);'
    echo ''

    echo '/** FIREFOX HOME CONTENT ***/'
    echo 'user_pref("browser.newtabpage.activity-stream.showSearch", false);'
    echo 'user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);'
    echo 'user_pref("browser.newtabpage.activity-stream.showSponsored", false);'
    echo 'user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);'
    echo 'user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);'
    echo 'user_pref("browser.newtabpage.activity-stream.showTopSites", false);'
    echo ''

    echo '/** SIDEBAR ***/'
    echo 'user_pref("sidebar.revamp", false);'
    echo 'user_pref("sidebar.main.tools", "");'
    echo 'user_pref("sidebar.visibility", "");'
    echo ''

    echo '/** OPTIONAL: DISABLE WEBASSEMBLY ***/'
    echo '#user_pref("javascript.options.wasm", false);'
    echo ''

    echo '/** OPTIONAL: DNS over HTTPS (commented out) ***/'
    echo '#user_pref("network.trr.mode", 3);'
    echo '#user_pref("network.trr.uri", "https://dns.quad9.net/dns-query");'
    echo ''

    echo '/************************************************************************/'
    echo '/*** END CUSTOM SETTINGS ***********************************************/'
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
