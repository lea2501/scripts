#!/bin/bash

# Fail on errors
set -euo pipefail

# Debug
# set -x

# Set superuser command if not defined
if [ -z "${su+x}" ]; then
  su="sudo"
fi

# Ensure required tools are installed
for cmd in curl grep tar file find; do
  if ! command -v "$cmd" &>/dev/null; then
    $su apt-get update -qq
    $su apt-get install -qq -y curl grep tar file findutils
    break
  fi
done

mkdir -p ~/bin
cd ~/bin || exit 1

# Get latest stable PyCharm Community version
PYCHARM_VERSION=$(
  curl -s "https://data.services.jetbrains.com/products/releases?code=PCC&latest=true&type=release" \
    | grep -oP '"version"\s*:\s*"\K[0-9.]+' \
    | head -n1
)

if [ -z "$PYCHARM_VERSION" ]; then
  echo "Could not determine latest PyCharm version"
  exit 1
fi

# Download URL
PYCHARM_DOWNLOAD_URL="https://download.jetbrains.com/python/pycharm-${PYCHARM_VERSION}.tar.gz"

# Detect installed version
CURRENT_VERSION=""

if [ -L pycharm ]; then
  LINK_TARGET=$(readlink pycharm || true)

  CURRENT_VERSION=$(
    echo "$LINK_TARGET" \
      | grep -oP 'pycharm-\K[0-9.]+' \
      || true
  )
fi

echo "Installed version: ${CURRENT_VERSION:-none}"
echo "Latest version: $PYCHARM_VERSION"

# Compare versions
if [ "$PYCHARM_VERSION" = "$CURRENT_VERSION" ]; then
  echo "You already have the latest version (${PYCHARM_VERSION}). Nothing to do."
  exit 0
fi

echo "Downloading PyCharm $PYCHARM_VERSION..."

ARCHIVE="/tmp/pycharm.tar.gz"
INSTALL_DIR="pycharm-${PYCHARM_VERSION}"

# Cleanup previous download
rm -f "$ARCHIVE"

# Download
curl -fL "$PYCHARM_DOWNLOAD_URL" -o "$ARCHIVE"

# Validate download
if ! file "$ARCHIVE" | grep -qi 'gzip compressed'; then
  echo "Downloaded file is not a valid gzip archive."
  echo
  echo "Response content:"
  cat "$ARCHIVE"
  exit 1
fi

# Remove previous installs
rm -rf pycharm-*

# Extract
tar -xzf "$ARCHIVE"

# Find extracted directory automatically
EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "pycharm-*" | head -n1)

if [ -z "$EXTRACTED_DIR" ]; then
  echo "Could not find extracted PyCharm directory"
  exit 1
fi

# Remove leading ./ if present
EXTRACTED_DIR="${EXTRACTED_DIR#./}"

# Normalize directory name if needed
if [ "$EXTRACTED_DIR" != "$INSTALL_DIR" ]; then
  mv "$EXTRACTED_DIR" "$INSTALL_DIR"
fi

# Update symlink
rm -f pycharm
ln -s "$INSTALL_DIR/bin/pycharm" pycharm

echo
echo "PyCharm updated to version $PYCHARM_VERSION"
echo "Run it with: ~/bin/pycharm"
