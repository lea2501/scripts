#!/bin/sh
set -e

# Ruta al archivo
CONF_DIR="/etc/X11/xorg.conf.d"
CONF_FILE="$CONF_DIR/10-monitor.conf"

# Si ya existe, salir
if [ -f "$CONF_FILE" ]; then
    echo "El archivo ya existe: $CONF_FILE"
    exit 0
fi

# Detectar la salida de pantalla con xrandr
OUTPUT=$(xrandr --listmonitors | grep "0:" | sed 's/.* \([^ ]*\)/\1/')
if [ -z "$OUTPUT" ]; then
    echo "No se encontró una pantalla activa. Abortando." >&2
    exit 1
fi

# Usar la resolución que querés (puedes personalizarla)
RESOLUTION="1920x1200"

# Crear el directorio si no existe
sudo mkdir -p "$CONF_DIR"

# Crear el archivo de configuración
sudo bash -c "cat > $CONF_FILE" <<EOF
Section "Monitor"
    Identifier "$OUTPUT"
    Option "PreferredMode" "$RESOLUTION"
EndSection

Section "Screen"
    Identifier "Screen0"
    Device "Device0"
    Monitor "$OUTPUT"
    DefaultDepth 24
    SubSection "Display"
        Modes "$RESOLUTION"
    EndSubSection
EndSection
EOF

echo "Archivo de configuración Xorg creado exitosamente en $CONF_FILE"
echo "Por favor, reinicia el sistema o Xorg para aplicar la nueva resolución."
