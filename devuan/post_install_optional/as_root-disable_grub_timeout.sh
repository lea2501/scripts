#!/bin/sh

set -e

GRUB_FILE="/etc/default/grub"
BACKUP_FILE="/etc/default/grub.bak.$(date +%F_%H-%M-%S)"

echo "Configurando GRUB para arranque directo sin menú..."
echo "Haciendo backup de $GRUB_FILE en $BACKUP_FILE"
cp "$GRUB_FILE" "$BACKUP_FILE"

# Clave-valor a asegurar en el archivo
set_grub_var() {
    VAR="$1"
    VALUE="$2"

    if grep -q "^$VAR=" "$GRUB_FILE"; then
        sed -i "s|^$VAR=.*|$VAR=$VALUE|" "$GRUB_FILE"
    else
        echo "$VAR=$VALUE" >> "$GRUB_FILE"
    fi
}

# Aplicar configuraciones
set_grub_var GRUB_TIMEOUT 0
set_grub_var GRUB_TIMEOUT_STYLE hidden
set_grub_var GRUB_DEFAULT 0
set_grub_var GRUB_GFXPAYLOAD_LINUX text
set_grub_var GRUB_CMDLINE_LINUX_DEFAULT '"quiet video=HDMI-1:d"'

echo "Actualizando GRUB..."
update-grub

echo "GRUB configurado para arranque directo sin demora."
