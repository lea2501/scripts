#!/bin/bash

# fail if any commands fails
#set -e
# debug log
#set -x

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
startpipewire_source="$script_dir/../../linux/desktop/startpipewire"

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
	cp "$startpipewire_source" /usr/local/bin/
fi
