#!/bin/sh
set -eu

# Evita que XFCE abra el selector de configuración al conectar un monitor.

if ! command -v xfconf-query >/dev/null 2>&1; then
    echo "Error: xfconf-query no está instalado." >&2
    exit 1
fi

xfconf-query \
    --channel displays \
    --property /Notify \
    --create \
    --type int \
    --set 0

echo "Listo. XFCE ya no mostrará el selector al conectar un monitor."
