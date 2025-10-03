#!/bin/bash
# cpu-current.sh - Shows the current frecuency of all CPU cores

echo "CPU core frequency:"

for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq; do
    core=$(basename $(dirname $cpu))
    freq=$(cat $cpu)
    echo "$core : $freq Hz"
done
