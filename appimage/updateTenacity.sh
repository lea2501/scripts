#!/bin/bash

appimage_url="https://codeberg.org/tenacityteam/tenacity/releases"

cd || exit
mkdir -p ~/Applications
cd ~/Applications || exit

# Buscar la última AppImage en la página de releases
DOWNLOAD_URL=$(curl -s "$appimage_url" \
  | grep -o 'https://codeberg.org/tenacityteam/tenacity/releases/download[^"]*\.AppImage' \
  | head -n 1)

if [ -z "$DOWNLOAD_URL" ]; then
  echo "No se encontró AppImage en $appimage_url"
  exit 1
fi

echo "Descargando: $DOWNLOAD_URL"
curl -L -O "$DOWNLOAD_URL"

chmod +x ./*.AppImage

cd - || exit
