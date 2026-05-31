#!/bin/bash
set -e

# Remove XFCE bottom panel and configure top panel

# Remove panel-2 (bottom dock)
xfconf-query -c xfce4-panel -p /panels/panel-2 -rR 2>/dev/null || true
xfconf-query -c xfce4-panel -p /panels -n -t int -s 1 --force-array

# Reset panel-1 plugins
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -rR 2>/dev/null || true

# Panel-1 settings
xfconf-query -c xfce4-panel -p /panels/panel-1/position -n -t string -s "p=6;x=0;y=0"
xfconf-query -c xfce4-panel -p /panels/panel-1/position-locked -n -t bool -s true
xfconf-query -c xfce4-panel -p /panels/panel-1/length -n -t int -s 100
xfconf-query -c xfce4-panel -p /panels/panel-1/size -n -t int -s 26

# Plugin layout: menu | tasklist | separator(expand,transparent) | pager | separator | systray | pulseaudio | power | clock | actions
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -n -a \
  -t int -s 1 -t int -s 2 -t int -s 3 -t int -s 4 -t int -s 5 \
  -t int -s 6 -t int -s 7 -t int -s 8 -t int -s 9 -t int -s 10

# 1: Applications menu
xfconf-query -c xfce4-panel -p /plugins/plugin-1 -n -t string -s "applicationsmenu"
# 2: Tasklist (flat buttons)
xfconf-query -c xfce4-panel -p /plugins/plugin-2 -n -t string -s "tasklist"
xfconf-query -c xfce4-panel -p /plugins/plugin-2/flat-buttons -n -t bool -s true
# 3: Separator (expand + transparent)
xfconf-query -c xfce4-panel -p /plugins/plugin-3 -n -t string -s "separator"
xfconf-query -c xfce4-panel -p /plugins/plugin-3/expand -n -t bool -s true
xfconf-query -c xfce4-panel -p /plugins/plugin-3/style -n -t uint -s 0
# 4: Workspace switcher
xfconf-query -c xfce4-panel -p /plugins/plugin-4 -n -t string -s "pager"
# 5: Separator (normal)
xfconf-query -c xfce4-panel -p /plugins/plugin-5 -n -t string -s "separator"
# 6: Systray
xfconf-query -c xfce4-panel -p /plugins/plugin-6 -n -t string -s "systray"
# 7: PulseAudio
xfconf-query -c xfce4-panel -p /plugins/plugin-7 -n -t string -s "pulseaudio"
# 8: Power manager
xfconf-query -c xfce4-panel -p /plugins/plugin-8 -n -t string -s "power-manager-plugin"
# 9: Clock
xfconf-query -c xfce4-panel -p /plugins/plugin-9 -n -t string -s "clock"
# 10: Actions (shutdown, suspend, etc)
xfconf-query -c xfce4-panel -p /plugins/plugin-10 -n -t string -s "actions"

# 4 workspaces
xfconf-query -c xfwm4 -p /general/workspace_count -n -t int -s 4

xfce4-panel -r

echo "Done. Bottom panel removed, top panel configured."
