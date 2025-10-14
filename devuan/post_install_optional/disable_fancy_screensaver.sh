#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

echo "Desactivando screensavers visuales..."
$su apt-get install -y psmisc

# Eliminar xscreensaver si está instalado
if dpkg -l | grep -q xscreensaver; then
    echo "Eliminando xscreensaver..."
    $su apt-get remove --purge -y xscreensaver xscreensaver-data
fi

# Eliminar xfce4-screensaver si está instalado
if dpkg -l | grep -q xfce4-screensaver; then
    echo "Eliminando xfce4-screensaver..."
    $su apt-get remove --purge -y xfce4-screensaver
fi

# Detener cualquier proceso viejo
pkill xscreensaver 2>/dev/null
pkill xfce4-screensaver 2>/dev/null

# Configurar XFCE para que apague pantalla sin screensaver
echo "Configurando apagado de pantalla sin animaciones..."

# Crea las propiedades si no existen, y luego las configura
xfconf-query -c xfce4-power-manager --property /xfce4-power-manager/blank-on-ac --create --type int --set 5
xfconf-query -c xfce4-power-manager --property /xfce4-power-manager/blank-on-battery --create --type int --set 5

# Opcional: asegurarse de que no se active un screensaver visual
xfconf-query -c xfce4-session --property /general/LockCommand --create --type string --set ""

# Opcional: configurar slock para bloqueo de pantalla
$su apt-get -y --fix-missing install suckless-tools
xfconf-query -c xfce4-session -p /general/LockCommand --create --type string --set slock
echo "Listo: ahora el menú usará 'slock' para bloquear la pantalla."

echo "Listo: la pantalla se apagará tras 5 minutos sin mostrar animaciones."