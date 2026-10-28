#!/usr/bin/env bash
set -euo pipefail

# Install/update the official Debian package (including its dependencies).
if [ -z "${su+x}" ]; then
  su="sudo"
fi

for cmd in curl jq; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    $su apt-get update -qq
    $su apt-get install -qq -y curl jq
    break
  fi
done

arch=$(dpkg --print-architecture)
tmpdir=$(mktemp -d /tmp/openidea-update.XXXXXXXX)
trap 'rm -rf -- "$tmpdir"' EXIT

curl --fail --silent --show-error --location --retry 3 \
  https://api.github.com/repos/l0ng-ai/openidea/releases/latest \
  -o "$tmpdir/release.json"
asset=$(jq -cer --arg suffix "_${arch}.deb" \
  '[.assets[] | select(.name | endswith($suffix))] |
   if length == 1 then .[0] else error("No unique DEB for this architecture") end' \
  "$tmpdir/release.json")
url=$(jq -r '.browser_download_url' <<< "$asset")
package="$tmpdir/openidea.deb"
echo "Downloading OpenIDEA $(jq -r '.tag_name' "$tmpdir/release.json") ($arch)..."
curl --fail --show-error --location --retry 3 "$url" -o "$package"

digest=$(jq -r '.digest // empty' <<< "$asset")
if [[ "$digest" == sha256:* ]]; then
  printf '%s  %s\n' "${digest#sha256:}" "$package" | sha256sum --check -
fi

name=$(dpkg-deb -f "$package" Package)
version=$(dpkg-deb -f "$package" Version)
installed=$(dpkg-query -W -f='${Status} ${Version}' "$name" 2>/dev/null || true)
if [[ "$installed" == "install ok installed "* ]]; then
  current=${installed#install ok installed }
  if dpkg --compare-versions "$current" ge "$version"; then
    echo "OpenIDEA $current is already installed. Nothing to do."
    exit 0
  fi
fi

# Let apt's unprivileged download user read the local package.
chmod 755 "$tmpdir"
chmod 644 "$package"
$su apt-get update -qq
$su apt-get install -y "$package"
echo "OpenIDEA updated to $version."
