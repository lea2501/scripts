#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get -y --fix-missing install adb
$su apt-get -y --fix-missing install android-sdk
$su apt-get -y --fix-missing install android-sdk-platform-tools
$su apt-get -y --fix-missing install android-sdk-build-tools
$su apt-get -y --fix-missing install fastboot

# Bloque a agregar a .bashrc
ANDROID_BLOCK="
# android path
export ANDROID_HOME=/usr/lib/android-sdk/
export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools
"

# Si no está ya en .bashrc, agregarlo
if ! grep -Fxq "# android path" ~/.bashrc; then
    {
        echo ""
        echo "$ANDROID_BLOCK"
    } >> ~/.bashrc
    echo "Android agregado a ~/.bashrc"
else
    echo "Android ya presente en ~/.bashrc"
fi

# Recargar configuración actual
. ~/.bashrc