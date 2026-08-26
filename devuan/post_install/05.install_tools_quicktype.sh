#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

# quicktype: Generate JSON Schema from JSON, and types for many languages
# https://github.com/glideapps/quicktype
# Replaces deprecated schema-guru

# Instalar el runtime minimalista sin arrastrar el paquete npm de Debian.
$su apt-get -y --fix-missing --no-install-recommends install nodejs node-corepack
PNPM_VERSION="10.34.0"
COREPACK_ENABLE_DOWNLOAD_PROMPT=0 corepack "pnpm@$PNPM_VERSION" --version >/dev/null

# Mantener Quicktype aislado del sistema y publicar solamente su ejecutable.
QUICKTYPE_DIR="$HOME/.local/share/quicktype"
mkdir -p "$QUICKTYPE_DIR" "$HOME/bin"
corepack "pnpm@$PNPM_VERSION" --dir "$QUICKTYPE_DIR" add quicktype
ln -sfn "$QUICKTYPE_DIR/node_modules/.bin/quicktype" "$HOME/bin/quicktype"
export PATH="$HOME/bin:$PATH"

echo ""
echo "Usage examples:"
echo "  quicktype --lang schema --src input.json -o schema.json"
echo "  quicktype --lang java --src input.json -o MyTypes.java"
echo "  cat input.json | quicktype --lang schema"
