#!/bin/bash
# set_night_filter.sh: instala y configura Redshift para reducir luz azul

# fail if any commands fails
#set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

set -e

echo "Instalando Redshift..."
$su apt install -y redshift-gtk

echo "Agregando Redshift al inicio automático..."
mkdir -p ~/.config/autostart
cp /usr/share/applications/redshift-gtk.desktop ~/.config/autostart/

echo "Redshift se iniciará automáticamente con XFCE."

# Crear configuración si no existe
CONFIG_DIR="$HOME/.config"
REDSHIFT_CONF="$CONFIG_DIR/redshift.conf"

if [ ! -f "$REDSHIFT_CONF" ]; then
    echo "Creando archivo de configuración de redshift en $REDSHIFT_CONF"
    mkdir -p "$CONFIG_DIR"
    cat > "$REDSHIFT_CONF" <<EOF
[redshift]
temp-day=6500
temp-night=3700
transition=1
brightness-day=1.0
brightness-night=0.9
gamma=0.8

[manual]
lat=-34.6
lon=-58.4
EOF
fi

echo "Redshift configurado."
