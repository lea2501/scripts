#!/bin/bash

set -euo pipefail

readonly REPOSITORY="hrydgard/ppsspp"
readonly API_URL="https://api.github.com/repos/${REPOSITORY}/releases/latest"
readonly TRUSTED_DOWNLOAD_PREFIX="https://github.com/hrydgard/ppsspp/releases/download/"
readonly APPLICATIONS_DIR="${HOME}/Applications"
readonly DESTINATION="${APPLICATIONS_DIR}/PPSSPP.AppImage"

for command_name in curl jq sha256sum stat od tr; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        echo "[ERROR] Falta el comando requerido: $command_name" >&2
        exit 1
    fi
done

if [[ "$(uname -m)" != "x86_64" ]]; then
    echo "[ERROR] Este instalador está preparado para Linux x86_64." >&2
    exit 1
fi

mkdir -p "$APPLICATIONS_DIR"
temporary_dir=$(mktemp -d "${APPLICATIONS_DIR}/.ppsspp-update.XXXXXX")
trap 'rm -rf -- "$temporary_dir"' EXIT

echo "Consultando la última versión oficial de PPSSPP para Linux x86_64..."
release_json=$(curl --fail --silent --show-error --location "$API_URL")

asset_json=$(jq -cer \
    --arg prefix "$TRUSTED_DOWNLOAD_PREFIX" '
    .assets[]
    | select(.name | test("^PPSSPP-v[0-9.]+-anylinux-x86_64[.]AppImage$"))
    | select(.browser_download_url | startswith($prefix))
    | select(.uploader.login == "github-actions[bot]")
    | select(.digest | startswith("sha256:"))
' <<< "$release_json" | head -n 1)

asset_name=$(jq -r '.name' <<< "$asset_json")
download_url=$(jq -r '.browser_download_url' <<< "$asset_json")
expected_size=$(jq -r '.size' <<< "$asset_json")
expected_sha256=$(jq -r '.digest | sub("^sha256:"; "")' <<< "$asset_json")
downloaded_file="${temporary_dir}/${asset_name}"

echo "Descargando ${asset_name} desde hrydgard/ppsspp..."
curl --fail --show-error --location "$download_url" --output "$downloaded_file"

actual_size=$(stat --format='%s' "$downloaded_file")
if [[ "$actual_size" != "$expected_size" ]]; then
    echo "[ERROR] El tamaño descargado no coincide con el publicado por PPSSPP." >&2
    exit 1
fi

echo "Verificando SHA-256 publicado por GitHub..."
printf '%s  %s\n' "$expected_sha256" "$downloaded_file" | sha256sum --check --status || {
    echo "[ERROR] El checksum no coincide. No se reemplazó PPSSPP.AppImage." >&2
    exit 1
}

# Una AppImage tipo 2 es un ELF con la marca hexadecimal 41 49 02 en offset 8.
appimage_magic=$(od -An -tx1 -j8 -N3 "$downloaded_file" | tr -d ' \n')
if [[ "$appimage_magic" != "414902" ]]; then
    echo "[ERROR] El archivo descargado no tiene una cabecera AppImage válida." >&2
    exit 1
fi

chmod 0755 "$downloaded_file"
mv -- "$downloaded_file" "$DESTINATION"
printf '%s  %s\n' "$expected_sha256" "$(basename "$DESTINATION")" \
    > "${DESTINATION}.sha256"

echo "[OK] PPSSPP instalado y verificado en: $DESTINATION"
