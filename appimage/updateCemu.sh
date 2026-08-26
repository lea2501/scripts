#!/bin/bash

set -euo pipefail

readonly REPOSITORY="cemu-project/Cemu"
readonly API_URL="https://api.github.com/repos/${REPOSITORY}/releases/latest"
readonly APPLICATIONS_DIR="${HOME}/Applications"
readonly DESTINATION="${APPLICATIONS_DIR}/Cemu.AppImage"

for command_name in curl jq sha256sum; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        echo "[ERROR] Falta el comando requerido: $command_name" >&2
        exit 1
    fi
done

mkdir -p "$APPLICATIONS_DIR"
temporary_dir=$(mktemp -d "${APPLICATIONS_DIR}/.cemu-update.XXXXXX")
trap 'rm -rf -- "$temporary_dir"' EXIT

echo "Consultando la última versión oficial de Cemu..."
release_json=$(curl --fail --silent --show-error --location "$API_URL")

asset_json=$(jq -cer '
    .assets[]
    | select(.name | test("^Cemu-[0-9.]+-x86_64[.]AppImage$"))
    | select(.browser_download_url | startswith("https://github.com/cemu-project/Cemu/releases/download/"))
    | select(.uploader.login == "Exzap" or .uploader.login == "github-actions[bot]")
    | select(.digest | startswith("sha256:"))
' <<< "$release_json" | head -n 1)

asset_name=$(jq -r '.name' <<< "$asset_json")
download_url=$(jq -r '.browser_download_url' <<< "$asset_json")
expected_sha256=$(jq -r '.digest | sub("^sha256:"; "")' <<< "$asset_json")
downloaded_file="${temporary_dir}/${asset_name}"

echo "Descargando ${asset_name} desde cemu-project/Cemu..."
curl --fail --show-error --location "$download_url" --output "$downloaded_file"

echo "Verificando SHA-256 publicado por GitHub..."
printf '%s  %s\n' "$expected_sha256" "$downloaded_file" | sha256sum --check --status || {
    echo "[ERROR] El checksum no coincide. No se reemplazó Cemu.AppImage." >&2
    exit 1
}

chmod 0755 "$downloaded_file"
mv -- "$downloaded_file" "$DESTINATION"
printf '%s  %s\n' "$expected_sha256" "$(basename "$DESTINATION")" \
    > "${DESTINATION}.sha256"

echo "[OK] Cemu instalado y verificado en: $DESTINATION"
