#!/usr/bin/env bash
# Install or update the stable RustDesk client from its official GitHub release.
set -euo pipefail

case "${1:-}" in
  '') ;;
  -h|--help)
    echo "Usage: ${0##*/}"
    echo "Install or update RustDesk using the latest stable official .deb."
    exit 0
    ;;
  *) echo "Unknown argument: $1" >&2; exit 1 ;;
esac

# Like the other Devuan scripts, allow su='' when already running as root.
if [[ ${EUID} -eq 0 ]]; then
  privileges=()
else
  read -r -a privileges <<< "${su-sudo}"
fi

case "$(dpkg --print-architecture)" in
  amd64) asset_arch=x86_64 ;;
  arm64) asset_arch=aarch64 ;;
  armhf) asset_arch=armv7-sciter ;;
  *) echo "Unsupported architecture: $(dpkg --print-architecture)" >&2; exit 1 ;;
esac

missing=()
command -v curl >/dev/null || missing+=(curl)
command -v jq >/dev/null || missing+=(jq)
[[ -s /etc/ssl/certs/ca-certificates.crt ]] || missing+=(ca-certificates)
if (( ${#missing[@]} )); then
  "${privileges[@]}" apt-get update
  "${privileges[@]}" apt-get install -y "${missing[@]}"
fi

workdir=$(mktemp -d /tmp/rustdesk-update.XXXXXXXX)
trap 'rm -rf -- "$workdir"' EXIT

echo "Checking the latest stable RustDesk release..."
curl --fail --show-error --silent --location --retry 3 \
  https://api.github.com/repos/rustdesk/rustdesk/releases/latest \
  -o "$workdir/release.json"

version=$(jq -er '.tag_name | ltrimstr("v")' "$workdir/release.json")
asset_name="rustdesk-${version}-${asset_arch}.deb"
url=$(jq -er --arg name "$asset_name" \
  '.assets[] | select(.name == $name) | .browser_download_url' \
  "$workdir/release.json") || {
  echo "No official package found for $asset_name." >&2
  exit 1
}

installed=$(dpkg-query -W -f='${Status} ${Version}' rustdesk 2>/dev/null || true)
if [[ $installed == "install ok installed "* ]]; then
  installed_version=${installed#install ok installed }
  if dpkg --compare-versions "$installed_version" ge "$version"; then
    echo "RustDesk $installed_version is already installed (latest: $version)."
    exit 0
  fi
fi

echo "Downloading $asset_name..."
package="$workdir/$asset_name"
curl --fail --show-error --location --retry 3 "$url" -o "$package"

digest=$(jq -r --arg name "$asset_name" \
  '.assets[] | select(.name == $name) | .digest // empty' "$workdir/release.json")
if [[ $digest == sha256:* ]]; then
  printf '%s  %s\n' "${digest#sha256:}" "$package" | sha256sum --check --status
fi

[[ $(dpkg-deb -f "$package" Package) == rustdesk ]] || {
  echo "The downloaded package is not RustDesk." >&2
  exit 1
}

# Let APT resolve dependencies; no systemd commands are needed by this script.
# Permit APT's _apt user to read the temporary package.
chmod 755 "$workdir"
chmod 644 "$package"
"${privileges[@]}" apt-get install -y "$package"
echo "RustDesk installed: $(dpkg-query -W -f='${Version}' rustdesk)"
