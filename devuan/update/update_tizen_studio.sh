#!/bin/bash

# Install or update the latest Tizen SDK/Studio for Linux (x86_64).
# The SDK itself and user data stay in separate directories, so updates keep
# workspaces, certificates and package-manager settings intact.
set -euo pipefail

INSTALL_DIR="${TIZEN_INSTALL_DIR:-$HOME/tizen-studio}"
DATA_DIR="${TIZEN_DATA_DIR:-$HOME/tizen-studio-data}"
INSTALLER_URL="${TIZEN_INSTALLER_URL:-https://download.tizen.org/sdk/Installer/Latest/Baseline_Tizen_Studio_ubuntu-64.bin}"
PACKAGE_MANAGER="$INSTALL_DIR/package-manager/package-manager-cli.bin"
DOWNLOAD_FILE=""

cleanup() {
  if [ -n "$DOWNLOAD_FILE" ] && [ -f "$DOWNLOAD_FILE" ]; then
    rm -f -- "$DOWNLOAD_FILE"
  fi
}
trap cleanup EXIT INT TERM

case "$(uname -m)" in
  x86_64|amd64) ;;
  *)
    echo "Tizen Studio for Linux is only distributed for x86_64." >&2
    exit 1
    ;;
esac

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required. Install it with: sudo apt-get install curl" >&2
  exit 1
fi

if [ -x "$PACKAGE_MANAGER" ]; then
  echo "Updating Tizen Studio in $INSTALL_DIR ..."
  "$PACKAGE_MANAGER" update --accept-license --no-java-check --latest
else
  if [ -e "$INSTALL_DIR" ]; then
    echo "$INSTALL_DIR exists, but it is not a valid Tizen Studio installation." >&2
    echo "Move it away or set TIZEN_INSTALL_DIR to another directory." >&2
    exit 1
  fi

  DOWNLOAD_FILE=$(mktemp "${TMPDIR:-/tmp}/tizen-studio-installer.XXXXXX.bin")
  echo "Downloading the latest official Tizen Studio installer ..."
  curl --fail --location --retry 3 --continue-at - \
    --output "$DOWNLOAD_FILE" "$INSTALLER_URL"

  chmod +x "$DOWNLOAD_FILE"
  echo "Installing Tizen Studio in $INSTALL_DIR ..."
  "$DOWNLOAD_FILE" --accept-license --no-java-check "$INSTALL_DIR"
fi

mkdir -p "$HOME/bin" "$DATA_DIR"

if [ -x "$INSTALL_DIR/tools/ide/bin/tizen" ]; then
  ln -sfn "$INSTALL_DIR/tools/ide/bin/tizen" "$HOME/bin/tizen"
fi

if [ -x "$INSTALL_DIR/tools/sdb" ]; then
  ln -sfn "$INSTALL_DIR/tools/sdb" "$HOME/bin/sdb"
fi

if [ -x "$INSTALL_DIR/ide/TizenStudio" ]; then
  ln -sfn "$INSTALL_DIR/ide/TizenStudio" "$HOME/bin/tizen-studio"
fi

echo
echo "Tizen Studio is ready in $INSTALL_DIR"
echo "User data: $DATA_DIR"
echo "Commands were linked in $HOME/bin (when provided by the installation)."
