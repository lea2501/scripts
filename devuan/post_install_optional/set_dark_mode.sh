#!/bin/bash
set -e

# Apply Adwaita-dark theme (ships with GNOME/GTK, no extra packages needed)

xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
xfconf-query -c xfwm4 -p /general/theme -s "Adwaita-dark"
xfconf-query -c xsettings -p /Net/IconThemeName -s "Adwaita"

echo "Done. Adwaita-dark applied."
