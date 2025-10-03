#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

echo "Instalando paquetes necesarios para Bluetooth..."
$su apt install -y bluetooth bluez blueman rfkill

echo "Desbloqueando Bluetooth si está bloqueado por RF-kill..."
$su rfkill unblock bluetooth

echo "Habilitando y arrancando el servicio bluetoothd con sysvinit..."
$su service bluetooth start
$su update-rc.d bluetooth defaults

echo "Bluetooth activo. Abrí Blueman desde el menú para gestionar dispositivos."