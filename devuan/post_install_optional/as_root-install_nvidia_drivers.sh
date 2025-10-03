#!/bin/sh
set -e

# Verificar root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script debe ejecutarse como root." >&2
    exit 1
fi

echo "==> Detectando GPU NVIDIA..."
if ! lspci | grep -iq nvidia; then
    echo "No se detectó hardware NVIDIA. Abortando." >&2
    exit 1
fi

echo "==> Habilitando repositorios contrib y non-free-firmware..."
sed -i 's/ main$/ main contrib non-free non-free-firmware/g;
        s/ main non-free-firmware/ main contrib non-free non-free-firmware/g' /etc/apt/sources.list

echo "==> Actualizando lista de paquetes..."
apt-get update -y

echo "==> Instalando driver NVIDIA..."
apt-get install -y --fix-missing nvidia-driver firmware-misc-nonfree

echo "==> Bloqueando nouveau..."
printf "blacklist nouveau\noptions nouveau modeset=0\n" > /etc/modprobe.d/blacklist-nouveau.conf
#update-initramfs -u

echo "==> Instalación completa. Reiniciá el sistema para aplicar cambios."