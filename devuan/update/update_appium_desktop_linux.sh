#!/usr/bin/env bash
set -euo pipefail

# Set superuser command if not defined
if [ -z "${su+x}" ]; then
  su="sudo"
fi

# Ensure curl and jq are installed
$su apt-get update -qq
$su apt-get install -qq -y curl jq

cd || exit 1
mkdir -p ~/Applications
cd ~/Applications || exit 1

# Function to download the latest AppImage for x86_64 only
download_latest_appimage() {
  local repo="$1"
  echo "Checking latest release for $repo..."

  curl -s "https://api.github.com/repos/${repo}/releases/latest" \
    | jq -r '.assets[] | select(.name | test("x86_64\\.AppImage$")) | .browser_download_url' \
    | while read -r url; do
        [ -z "$url" ] && continue
        filename=$(basename "$url")
        if [ -f "$filename" ]; then
          echo "Skipping $filename (already exists)"
        else
          echo "Downloading $filename..."
          curl -LO "$url"
        fi
      done
}

# Download Appium Desktop (x86_64 only)
download_latest_appimage "appium/appium-desktop"

# Download Appium Inspector (x86_64 only)
download_latest_appimage "appium/appium-inspector"

chmod +x ./*.AppImage
cd - || exit 1

echo "All done."
