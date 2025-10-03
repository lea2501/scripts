#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

ZONENAME="America/Argentina/Buenos_Aires"

# Verificar que exista la zona horaria
if [ ! -f "/usr/share/zoneinfo/$ZONENAME" ]; then
  echo "Zona horaria $ZONENAME no encontrada en /usr/share/zoneinfo." >&2
  exit 1
fi

echo "==> Configurando zona horaria a $ZONENAME ..."
$su ln -sf "/usr/share/zoneinfo/$ZONENAME" /etc/localtime

echo "==> Ajustando reloj de hardware para que use hora UTC ..."
$su hwclock --systohc --utc

echo "==> Activando sincronización NTP ..."
$su timedatectl set-ntp true

echo "==> Configuración completada. Hora actual:"
date