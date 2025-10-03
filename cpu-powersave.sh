#!/bin/bash
# CPU always set to powersave - universal Intel/AMD, no systemd no GRUB

for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    # if file exists, write powersave
    if [ -f "$cpu" ]; then
        echo powersave > "$cpu"
    fi
done

echo "DONE! All CPU cores set to powersave"
