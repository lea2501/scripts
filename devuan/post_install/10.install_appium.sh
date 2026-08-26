#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

cd || return
$su apt-get -y --fix-missing install jq
$su apt-get -y --fix-missing --no-install-recommends install nodejs node-corepack cmake
$su apt-get -y --fix-missing install node-opencv

# Preparar pnpm mediante Corepack sin instalar el paquete npm de Debian.
PNPM_VERSION="10.34.0"
COREPACK_ENABLE_DOWNLOAD_PROMPT=0 corepack "pnpm@$PNPM_VERSION" --version >/dev/null

# Mantener Appium y sus dependencias aislados del sistema y del directorio home.
APPIUM_DIR="$HOME/.local/share/appium"
mkdir -p "$APPIUM_DIR" "$HOME/bin"
corepack "pnpm@$PNPM_VERSION" --dir "$APPIUM_DIR" add appium wd
ln -sfn "$APPIUM_DIR/node_modules/.bin/appium" "$HOME/bin/appium"
export PATH="$HOME/bin:$PATH"

appium driver list
appium driver install uiautomator2
appium driver install xcuitest

# appium-inspector (appium-desktop is deprecated and archived since 2023)
cd || return
mkdir -p ~/Applications
cd ~/Applications || return
curl -O -L "$(curl -s https://api.github.com/repos/appium/appium-inspector/releases/latest | jq -r ".assets[] | select(.name | test(\"linux-x86_64.AppImage\")) | .browser_download_url")"
chmod +x ./*.AppImage
cd - || return
