#!/bin/bash

# Install or update the latest Tizen SDK for Linux (x86_64).
# The official Latest installer provides the Baseline SDK and CLI tools.
# https://download.tizen.org/sdk/Installer/Latest/
# Run as your normal user; sudo is only used for apt dependencies.
set -euo pipefail

# Set superuser command if not defined (same convention as other updaters).
if [ -z "${su+x}" ]; then
  su="sudo"
fi

INSTALL_DIR="${TIZEN_INSTALL_DIR:-$HOME/tizen-studio}"
INSTALLER_URL="${TIZEN_INSTALLER_URL:-https://download.tizen.org/sdk/Installer/Latest/Baseline_Tizen_Studio_ubuntu-64.bin}"
PACKAGE_MANAGER="$INSTALL_DIR/package-manager/package-manager-cli.bin"
DOWNLOAD_FILE=""

cleanup() {
  if [ -n "$DOWNLOAD_FILE" ] && [ -f "$DOWNLOAD_FILE" ]; then
    rm -f -- "$DOWNLOAD_FILE"
  fi
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

if [ "$EUID" -eq 0 ]; then
  echo "Run this script as your normal user, without sudo." >&2
  exit 1
fi

case "$(uname -m)" in
  x86_64|amd64) ;;
  *)
    echo "Tizen Studio for Linux is only distributed for x86_64." >&2
    exit 1
    ;;
esac

if ! command -v curl >/dev/null 2>&1; then
  $su apt-get update -qq
  $su apt-get install -qq -y curl ca-certificates
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

if [ ! -x "$INSTALL_DIR/tools/ide/bin/tizen" ]; then
  echo "The installation did not provide the Tizen Web CLI." >&2
  echo "Use $PACKAGE_MANAGER show-pkgs to check available Web CLI packages." >&2
  exit 1
fi

mkdir -p "$HOME/bin"

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
echo "Commands were linked in $HOME/bin (when provided by the installation)."
echo 'Ensure $HOME/bin is in your PATH, or run ~/bin/tizen directly.'
echo
echo "Build FlowStg (requires a configured signing profile):"
echo '  cd ~/repos/flow-frontends/tizenstudio'
echo '  ~/bin/tizen build-web -- FlowStg'
echo '  ~/bin/tizen package -t wgt -s "MiPerfil" -- FlowStg/.buildResult'
echo
echo "Samsung TV and certificate extensions can be managed with:"
echo "  $PACKAGE_MANAGER extra --list"
echo "  $PACKAGE_MANAGER show-pkgs"
