#!/usr/bin/env bash
set -euo pipefail
# debug log
#set -x

if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get update -qq
$su apt-get install -qq -y curl jq

cd || exit 1
mkdir -p ~/Applications
cd ~/Applications || exit 1

# File to remember last installed version
VERSION_FILE=".yt-dlp_version"

# Get latest tag (e.g. 2025.10.10)
LATEST_VERSION=$(curl -s https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest \
  | jq -r '.tag_name')

# Read current version if available
CURRENT_VERSION=""
[ -f "$VERSION_FILE" ] && CURRENT_VERSION=$(cat "$VERSION_FILE")

echo "Current version: ${CURRENT_VERSION:-none}"
echo "Latest version:  $LATEST_VERSION"

if [ "$LATEST_VERSION" = "$CURRENT_VERSION" ]; then
  echo "You already have the latest version ($LATEST_VERSION)."
  exit 0
fi

# Download new binary for x86_64
url=$(curl -s https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest \
  | jq -r '.assets[] | select(.name | test("yt-dlp_linux$")) | .browser_download_url')

echo "Downloading $url ..."
curl -L -o yt-dlp_linux_x86_64 "$url"
chmod +x yt-dlp_linux_x86_64

# Save new version tag
echo "$LATEST_VERSION" > "$VERSION_FILE"

echo "yt-dlp updated to version $LATEST_VERSION."
cd - || exit 1
