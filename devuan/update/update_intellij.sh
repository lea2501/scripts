#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

set -euo pipefail

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

# Ensure curl is installed
if ! command -v curl &>/dev/null; then
  $su apt-get update -qq
  $su apt-get install -qq -y curl
fi

mkdir -p ~/bin
cd ~/bin || exit 1

# Get latest stable version of IntelliJ IDEA Community (ideaIC)
INTELLIJ_VERSION=$(curl -s https://data.services.jetbrains.com/products/releases?code=IIC\&latest=true\&type=release \
  | grep -oP '"version"\s*:\s*"\K[0-9.]+(?=")' | head -n1)

# Build download URL
INTELLIJ_DOWNLOAD_URL="https://download-cf.jetbrains.com/idea/ideaIC-${INTELLIJ_VERSION}.tar.gz"

# Get installed version (if any)
if [ -L idea ]; then
  CURRENT_VERSION=$(readlink idea | grep -oP 'ideaIC-\K[0-9.]+(?=/)')
else
  CURRENT_VERSION=""
fi

echo "Installed version: ${CURRENT_VERSION:-none}"
echo "Latest version: $INTELLIJ_VERSION"

# Compare versions
if [ "$INTELLIJ_VERSION" = "$CURRENT_VERSION" ]; then
  echo "You already have the latest version (${INTELLIJ_VERSION}). Nothing to do."
  exit 0
fi

echo "Downloading IntelliJ IDEA Community $INTELLIJ_VERSION..."

# Clean up previous versions and files
rm -rf ideaIC-*           # remove all old extracted versions
rm -rf ideaIC-"${INTELLIJ_VERSION}.tar.gz"

# Download and extract
curl -L "$INTELLIJ_DOWNLOAD_URL" -o "ideaIC-${INTELLIJ_VERSION}.tar.gz"
tar -xzf "ideaIC-${INTELLIJ_VERSION}.tar.gz"
mv idea-IC-* "ideaIC-${INTELLIJ_VERSION}"

# Update symlink
rm -f idea
ln -s "ideaIC-${INTELLIJ_VERSION}/bin/idea" idea

echo "IntelliJ updated to version $INTELLIJ_VERSION"
