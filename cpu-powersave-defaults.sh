#!/bin/bash
# cpu-powersave-default.sh - Set CPU to powersave governor and sets default min and max frequency values

echo "Setting all CPU cores to powersave and default values..."

for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq; do
    if [ -f "$cpu" ]; then
        minfreq=$(cat "${cpu%scaling_min_freq}cpuinfo_min_freq")
        maxfreq=$(cat "${cpu%scaling_min_freq}cpuinfo_max_freq")
        echo "Fijando $cpu min=$minfreq max=$maxfreq"
        echo $minfreq | sudo tee $cpu > /dev/null
        echo $maxfreq | sudo tee "${cpu%scaling_min_freq}scaling_max_freq" > /dev/null
        # Set governor to powersave
        echo powersave | sudo tee "${cpu%scaling_min_freq}scaling_governor" > /dev/null
    fi
done

echo "All CPU cores set to powersave with default frequency values"
