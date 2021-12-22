#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

function show_usage() {
  printf "Usage: $0 [options [parameters]]\n"
  printf "Example: %s --system archlinux --runtime \"10 minutes\" --interval 60 --stress yes" "$0"
  printf "\n\n"
  printf "Mandatory options:\n"
  printf " --system                 (archlinux | artix | devuan | macos | openbsd) (Mandatory)\n"
  printf "\n"
  printf "Options:\n"
  printf " --runtime                [script duration, expressed: 'N minutes', 'N seconds', etc.] (Optional, default: '5 minutes')\n"
  printf " --interval               [script output interval in seconds: (Optional, default: '60')\n"
  printf " --stress                 [set stress or idle execution] (Optional, default: 'no')\n"
  printf "\n"
  printf " -h|--help, Print help\n"
  printf "\n"
  printf " It will automatically save a report to '\$HOME/[system]-report-[date].log'"
  printf "\n"

  exit
}

temp_command_archlinux() {
  sensors | grep "Tctl:" | awk '{print $2}'
}
temp_command_artix() {
  sensors | grep "Core 0" | awk '{print $3}'
}
temp_command_devuan() {
  sensors | grep "Core 3" | awk '{print $3}'
}
top_command_archlinux() {
  top -b -d2 -n2 | grep "Cpu" | tail -n 1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
}
top_command_artix() {
  top -b -d2 -n2 | grep "Cpu" | tail -n 1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print $1"%"}'
}
top_command_devuan() {
  top -b -d2 -n2 | grep "Cpu" | tail -n 1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
}
date_command() {
  date '+%Y-%m-%d_%H-%M'
}

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  show_usage
fi
if [[ -z $1 ]]; then
  show_usage
fi

while [ ! -z "$1" ]; do
  case "$1" in
  --system)
    shift
    echo "operating system: $1"
    system=$1
    ;;
  --runtime)
    shift
    echo "script duration: $1"
    runtime=$1
    ;;
  --interval)
    shift
    echo "script output interval: $1"
    interval=$1
    ;;
  --stress)
    shift
    echo "stress run: $1"
    stress_run=$1
    ;;
  *)
    show_usage
    ;;
  esac
  shift
done

### Configuration
if [[ -z $system ]]; then
  show_usage
fi
if [[ -z $runtime ]]; then
  runtime="300"
fi
if [[ -z $interval ]]; then
  interval="60"
fi
if [[ -z $stress_run ]]; then
  stress_run="no"
fi
end_time=$(date -ud "$runtime seconds" +%s)
report_path=$HOME/$system-report-$(date_command).log

### check parameter values
systems=(archlinux artix devuan macos openbsd)
if [[ " "${systems[@]}" " != *" $system "* ]]; then
  echo "$system: not recognized. Valid systems are:"
  echo "${systems[@]/%/,}"
  exit 1
fi
options=(yes no)
if [[ " "${options[@]}" " != *" $stress_run "* ]]; then
  echo "$stress_run: not recognized. Valid '--stress_run' options are:"
  echo "${options[@]/%/,}"
  exit 1
fi

### Start stress test
if [ "$stress_run" = "yes" ]; then
  #for i in $(seq "$(getconf _NPROCESSORS_ONLN)"); do yes > /dev/null & done
  stress --cpu `nproc` --vm `nproc` --vm-bytes 1GB --io `nproc` --hdd `nproc` --hdd-bytes 1GB --timeout $runtime > /dev/null &
fi

### Monitoring
echo "=============================="
while [[ $(date -u +%s) -le $end_time ]]
do
  sleep $interval
  case "$system" in
    archlinux)
      echo "CPU Usage: $(top_command_archlinux) | CPU Temp: $(temp_command_archlinux)" | tee -a "$report_path"
      ;;
    artix)
      echo "CPU Usage: $(top_command_artix) | CPU Temp: $(temp_command_artix)" | tee -a "$report_path"
      ;;
    devuan)
      echo "CPU Usage: $(top_command_devuan) | CPU Temp: $(temp_command_devuan)" | tee -a "$report_path"
      ;;
    macos)
      echo ""
      ;;
    openbsd)
      echo ""
      ;;
  esac
done
echo "=============================="

### Stop stress test
#if [ "$stress_run" = "yes" ]; then
#  killall yes
#fi

### Show report message
echo "Saved report to file $report_path"

### Clean temporary files
rm -rf stress.*
