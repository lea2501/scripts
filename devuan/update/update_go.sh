#!/bin/bash
set -e

INSTALL_DIR="/usr/local"
PROFILE_FILE="$HOME/.bashrc"

echo ">>> Buscando la última versión de Go..."
LATEST=$(curl -s https://go.dev/dl/?mode=json | grep -oP '"version": "go\K[0-9.]+(?=")' | head -n1)

if [ -z "$LATEST" ]; then
    echo "No pude obtener la versión. ¿Tenés curl y grep instalados?"
    exit 1
fi

echo ">>> Última versión encontrada: $LATEST"

echo ">>> Descargando Go $LATEST ..."
wget -q https://go.dev/dl/go${LATEST}.linux-amd64.tar.gz -O /tmp/go.tar.gz

echo ">>> Eliminando instalaciones anteriores ..."
sudo rm -rf ${INSTALL_DIR}/go

echo ">>> Instalando en ${INSTALL_DIR} ..."
sudo tar -C ${INSTALL_DIR} -xzf /tmp/go.tar.gz
rm /tmp/go.tar.gz

# Configurar PATH si no está ya
if ! grep -q "/usr/local/go/bin" "$PROFILE_FILE"; then
    echo 'export PATH=$PATH:/usr/local/go/bin' >> "$PROFILE_FILE"
    echo 'export GOPATH=$HOME/go' >> "$PROFILE_FILE"
    echo 'export PATH=$PATH:$GOPATH/bin' >> "$PROFILE_FILE"
fi

echo ">>> Instalación completa. Cerrá y abrí la terminal o corré: source $PROFILE_FILE"
echo ">>> Probá con: go version"
