#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [[ -z $su ]]; then
  export su="sudo"
fi

$su pacman -S tlp acpi_call

$su sed -i 's/#CPU_SCALING_GOVERNOR_ON_AC=powersave/CPU_SCALING_GOVERNOR_ON_AC=powersave/g' /etc/tlp.conf
$su sed -i 's/#CPU_SCALING_GOVERNOR_ON_BAT=powersave/CPU_SCALING_GOVERNOR_ON_BAT=powersave/g' /etc/tlp.conf

$su sed -i 's/#CPU_MIN_PERF_ON_AC=0/CPU_MIN_PERF_ON_AC=0/g' /etc/tlp.conf
$su sed -i 's/#CPU_MAX_PERF_ON_AC=100/CPU_MAX_PERF_ON_AC=50/g' /etc/tlp.conf
$su sed -i 's/#CPU_MIN_PERF_ON_BAT=0/CPU_MIN_PERF_ON_BAT=0/g' /etc/tlp.conf
$su sed -i 's/#CPU_MAX_PERF_ON_BAT=30/CPU_MAX_PERF_ON_BAT=30/g' /etc/tlp.conf

$su sed -i 's/#CPU_BOOST_ON_AC=1/CPU_BOOST_ON_AC=0/g' /etc/tlp.conf
$su sed -i 's/#CPU_BOOST_ON_BAT=0/CPU_BOOST_ON_BAT=0/g' /etc/tlp.conf

$su sed -i 's/#USB_AUTOSUSPEND=1/USB_AUTOSUSPEND=0/g' /etc/tlp.conf

$su tlp start
