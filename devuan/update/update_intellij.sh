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

# Get latest stable IntelliJ IDEA version
INTELLIJ_VERSION=$(
  curl -s "https://data.services.jetbrains.com/products/releases?code=IIU&latest=true&type=release" \
    | grep -oP '"version"\s*:\s*"\K[0-9.]+' \
    | head -n1
)

if [ -z "$INTELLIJ_VERSION" ]; then
  echo "Could not determine latest IntelliJ version"
  exit 1
fi

# Download URL
INTELLIJ_DOWNLOAD_URL="https://download.jetbrains.com/idea/ideaIU-${INTELLIJ_VERSION}.tar.gz"

# Detect installed version (supports old IC and new IU installs)
CURRENT_VERSION=""

if [ -L idea ]; then
  LINK_TARGET=$(readlink idea || true)

  CURRENT_VERSION=$(
    echo "$LINK_TARGET" \
      | grep -oP '(idea(IC|IU)-)\K[0-9.]+' \
      || true
  )
fi

echo "Installed version: ${CURRENT_VERSION:-none}"
echo "Latest version: $INTELLIJ_VERSION"

# Compare versions
if [ "$INTELLIJ_VERSION" = "$CURRENT_VERSION" ]; then
  echo "You already have the latest version (${INTELLIJ_VERSION}). Nothing to do."
  exit 0
fi

echo "Downloading IntelliJ IDEA $INTELLIJ_VERSION..."

ARCHIVE="/tmp/intellij.tar.gz"
INSTALL_DIR="ideaIU-${INTELLIJ_VERSION}"

# Cleanup previous download
rm -f "$ARCHIVE"

# Download
curl -fL "$INTELLIJ_DOWNLOAD_URL" -o "$ARCHIVE"

# Validate download
if ! file "$ARCHIVE" | grep -qi 'gzip compressed'; then
  echo "Downloaded file is not a valid gzip archive."
  echo
  echo "Response content:"
  cat "$ARCHIVE"
  exit 1
fi

# Remove previous installs
rm -rf ideaIC-*
rm -rf ideaIU-*
rm -rf idea-IC-*
rm -rf idea-IU-*

# Extract
tar -xzf "$ARCHIVE"

# Find extracted directory automatically
EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "idea-*" | head -n1)

if [ -z "$EXTRACTED_DIR" ]; then
  echo "Could not find extracted IntelliJ directory"
  exit 1
fi

# Remove leading ./ if present
EXTRACTED_DIR="${EXTRACTED_DIR#./}"

# Normalize directory name
mv "$EXTRACTED_DIR" "$INSTALL_DIR"

# Update symlink
rm -f idea
ln -s "$INSTALL_DIR/bin/idea" idea

echo
echo "IntelliJ updated to version $INTELLIJ_VERSION"
echo "Run it with: ~/bin/idea"
