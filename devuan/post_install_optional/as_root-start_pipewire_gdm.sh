#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

if [ ! -f /etc/xdg/autostart/pipewire.desktop ]; then
  {
    echo "[Desktop Entry]"
    echo "Type=Application"
    echo "Name=Pipewire"
    echo "Exec=/usr/local/bin/startpipewire"
  }>/etc/xdg/autostart/pipewire.desktop

  cat /etc/xdg/autostart/pipewire.desktop
fi

if [ ! -f /usr/local/bin/startpipewire ]; then
	cp startpipewire /usr/local/bin/
fi
