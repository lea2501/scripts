#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

cd || return

{
  echo "alias aur_update='for dir in ~/aur/*; do (cd \"\$dir\" && pwd && git pull); done'"
  echo "alias syncthing='syncthing -no-browser'"
  echo "alias getBatt='upower -i /org/freedesktop/UPower/devices/battery_BAT0'"
  echo "alias getBattBrief='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E \"state|time\ to\ |percentage\"'"
  echo "alias getBattPercent=\"upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep 'percentage' | awk '{print \$2}'\"":
  echo "alias getVulnerabilities='grep -RHe \"^\" /sys/devices/system/cpu/vulnerabilities'"
  echo "alias getAudioMaster=\"amixer sget Master | grep 'Right:' | awk -F'[][]' '{print \$2}'\""
  echo "alias dim=\"echo \$(tput cols)x\$(tput lines)\""
  echo "alias systemstats='echo \"== Disks ==\" && df -h && echo \"== Memory ==\" && free -h && echo \"== CPU ==\" && cat /proc/cpuinfo | grep \"cpu MHz\" && echo \"== TEMP ==\" && sensors | grep \"°C\"'"
  echo "alias youtube-dl_getlist='sed -i \"s/invidious.sethforprivacy.com/www.youtube.com/g\" ~/Downloads/youtube-dl.txt && yt-dlp -vci -N 1 -o \"video-\$(date \"+%Y%m%d\")-%(title)s-%(id)s.%(ext)s\" -a ~/Downloads/youtube-dl.txt && rm ~/Downloads/youtube-dl.txt'"
} >>~/.bash_aliases

{
  echo ""
  echo "# bash aliases"
  echo "if [ -f ~/.bash_aliases ]; then"
  echo "  . ~/.bash_aliases"
  echo "fi"
} >>~/.bashrc

source ~/.bashrc
