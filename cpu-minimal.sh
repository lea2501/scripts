#!/bin/bash
# cpu-minimal.sh - Force all CPU cores to the absolute minimum frequency

echo "Detecting minimal frequencies per CPU core..."

for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq; do
    if [ -f "$cpu" ]; then
        minfreq=$(cat "${cpu%scaling_min_freq}cpuinfo_min_freq")
        echo "Fijando $cpu a $minfreq Hz"
        echo $minfreq | sudo tee $cpu > /dev/null
        # Set maximum to minimum value
        maxfile="${cpu%scaling_min_freq}scaling_max_freq"
        echo $minfreq | sudo tee $maxfile > /dev/null
    fi
done

echo "All CPU cores set to minimal possible frequency"
