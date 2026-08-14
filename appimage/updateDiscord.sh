#!/bin/bash
set -e
set -x 

appimage="srevinsaju/discord-appimage"

cd ~ || exit
mkdir -p Applications
cd Applications || exit

# Get latest release URL
DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/$appimage/releases/latest" \
  | grep browser_download_url \
  | grep AppImage \
  | head -n 1 \
  | cut -d '"' -f 4)

# Extract filename
FILENAME=$(basename "$DOWNLOAD_URL")

echo "Latest available version: $FILENAME"

# If file already exists, skip download
if [[ -f "$FILENAME" ]]; then
  echo "Already up to date, nothing to do"
  exit 0
fi

echo "Downloading new version..."

TMP_FILE=$(mktemp)

curl -L "$DOWNLOAD_URL" -o "$TMP_FILE"
chmod +x "$TMP_FILE"

mv "$TMP_FILE" "$FILENAME"

# Extract AppImage and fix known AppRun issues
rm -rf Discord-extracted
./"$FILENAME" --appimage-extract
mv squashfs-root Discord-extracted

# Fix old AppRun versions that reference wrong binary name
sed -i 's|BIN="$APPDIR/Discord"|BIN="$APPDIR/discord"|' Discord-extracted/AppRun 2>/dev/null || true

chmod +x Discord-extracted/AppRun
# Make whichever binary exists executable
chmod +x Discord-extracted/Discord Discord-extracted/discord 2>/dev/null || true

# Update symlink to point to the corrected AppRun
ln -sf Discord-extracted/AppRun Discord.AppImage

echo "Updated to $FILENAME"
