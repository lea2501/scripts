#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Creating user aliases in ~/.bash_aliases file..."
cd || return

{
  echo "alias syncthing='syncthing -no-browser'"
  echo "alias getBatt='upower -i /org/freedesktop/UPower/devices/battery_BAT0'"
  echo "alias getBattBrief='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E \"state|time\ to\ |percentage\"'"
  echo "alias getBattPercent=\"upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep 'percentage' | awk '{print \$2}'\"":
  echo "alias getVulnerabilities='grep -RHe \"^\" /sys/devices/system/cpu/vulnerabilities'"
  echo "alias getAudioMaster=\"amixer sget Master | grep 'Right:' | awk -F'[][]' '{print \$2}'\""
  echo "alias dim=\"echo \$(tput cols)x\$(tput lines)\""
  echo "alias systemstats='echo \"== Disks ==\" && df -h && echo \"== Memory ==\" && free -h && echo \"== CPU ==\" && cat /proc/cpuinfo | grep \"cpu MHz\" && echo \"== TEMP ==\" && sensors | grep \"°C\"'"
} >>~/.bash_aliases

{
  echo "if [ -f ~/.bash_aliases ]; then"
  echo "  . ~/.bash_aliases"
  echo "fi"
} >>~/.bashrc

source ~/.bashrc
echo "Creating user aliases in ~/.bash_aliases file... DONE"