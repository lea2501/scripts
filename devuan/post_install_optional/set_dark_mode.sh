#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

echo "Instalando motores GTK2 necesarios para temas oscuros..."
$su apt install -y gtk2-engines-murrine gtk2-engines-pixbuf

echo "Instalando temas oscuros e íconos..."
$su apt install -y arc-theme numix-gtk-theme papirus-icon-theme adwaita-qt

echo "Aplicando tema oscuro (Arc-Dark) e íconos (Papirus-Dark)..."
xfconf-query -c xsettings -p /Net/ThemeName -s "Arc-Dark"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
xfconf-query -c xfwm4 -p /general/theme -s "Arc-Dark"