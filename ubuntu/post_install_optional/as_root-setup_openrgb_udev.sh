#!/bin/sh

# Define variables
TMPFILE="/tmp/60-openrgb.rules"
DESTDIR="/etc/udev/rules.d"
RULEFILE="$DESTDIR/60-openrgb.rules"

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "Error: You must run this script as root (use sudo)."
    exit 1
fi

# Step 1: Download the udev rule
echo "Downloading OpenRGB udev rule..."
wget -q -O "$TMPFILE" https://openrgb.org/releases/release_0.9/60-openrgb.rules

# Check if the download was successful
if [ ! -s "$TMPFILE" ]; then
    echo "Error: The file could not be downloaded or is empty."
    exit 1
fi

# Step 2: Check if the rule already exists and back it up if necessary
if [ -f "$RULEFILE" ]; then
    echo "Rule already exists. Backing up the old rule..."
    mv "$RULEFILE" "$RULEFILE.bak"
    echo "Backup saved as $RULEFILE.bak"
fi

# Install the rule
echo "Installing the udev rule to $DESTDIR..."
cp "$TMPFILE" "$DESTDIR/"

# Step 3: Load the i2c-dev module
echo "Loading the i2c-dev module..."
modprobe i2c-dev

# Step 4: Load the correct I2C module for your system (AMD or Intel)
echo "Checking system architecture and loading the correct I2C module..."
if lscpu | grep -iq "amd"; then
    modprobe i2c-piix4
    echo "AMD system detected. Loaded i2c-piix4."
else
    modprobe i2c-i801
    echo "Intel system detected. Loaded i2c-i801."
fi

# Step 5: Verify that the modules were loaded correctly
echo "Verifying that the I2C modules are loaded..."
lsmod | grep i2c

# Step 6: Add modules to /etc/modules to load them automatically
echo "Adding i2c-dev and the system-specific I2C module to /etc/modules for automatic loading..."
if lscpu | grep -iq "amd"; then
    echo -e "i2c-dev\ni2c-piix4" >> /etc/modules
else
    echo -e "i2c-dev\ni2c-i801" >> /etc/modules
fi

# Step 7: Reload udev rules
echo "Reloading udev rules..."
udevadm control --reload
udevadm trigger

# Step 8: Clean up
echo "Removing temporary file..."
rm -f "$TMPFILE"

echo "All steps completed. The OpenRGB udev rule is installed and the necessary I2C modules are loaded."
echo "Please reboot your system to apply the changes."
