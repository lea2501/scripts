#!/usr/bin/env bash
set -euo pipefail
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get update -qq
$su apt-get install -qq -y curl jq tar

repository="Gentleman-Programming/engram"
install_dir="$HOME/bin"
version_file="$install_dir/.engram_version"

mkdir -p "$install_dir"

# Get latest release (e.g. v3.7.2)
release_json=$(curl -fsSL "https://api.github.com/repos/${repository}/releases/latest")
LATEST_VERSION=$(echo "$release_json" | jq -r '.tag_name')

# Read current version if available
CURRENT_VERSION=""
[ -f "$version_file" ] && CURRENT_VERSION=$(cat "$version_file")

echo "Current version: ${CURRENT_VERSION:-none}"
echo "Latest version:  $LATEST_VERSION"

if [ "$LATEST_VERSION" = "$CURRENT_VERSION" ] && [ -x "$install_dir/engram" ]; then
  echo "You already have the latest version ($LATEST_VERSION)."
  exit 0
fi

# Download new binary for linux amd64
asset="engram_${LATEST_VERSION#v}_linux_amd64.tar.gz"
url=$(echo "$release_json" \
  | jq -r --arg name "$asset" '.assets[] | select(.name == $name) | .browser_download_url')
checksums_url=$(echo "$release_json" \
  | jq -r '.assets[] | select(.name == "checksums.txt") | .browser_download_url')

if [ -z "$url" ]; then
  echo "Asset $asset not found in release $LATEST_VERSION." >&2
  exit 1
fi

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

echo "Downloading $url ..."
curl -fL -o "$tmp_dir/$asset" "$url"

# Verify checksum
if [ -n "$checksums_url" ]; then
  curl -fsSL -o "$tmp_dir/checksums.txt" "$checksums_url"
  (cd "$tmp_dir" && grep " $asset\$" checksums.txt | sha256sum -c -)
fi

tar -xzf "$tmp_dir/$asset" -C "$tmp_dir" engram
chmod +x "$tmp_dir/engram"
mv "$tmp_dir/engram" "$install_dir/engram"

# Save new version tag
echo "$LATEST_VERSION" > "$version_file"

echo "engram updated to version $LATEST_VERSION."
