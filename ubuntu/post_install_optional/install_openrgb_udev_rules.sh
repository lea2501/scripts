#!/bin/sh

# Define variables
TMPFILE="/tmp/60-openrgb.rules"
DESTDIR="/etc/udev/rules.d"
RULEFILE="$DESTDIR/60-openrgb.rules"

# Download the udev rule
echo "Downloading OpenRGB udev rule..."
wget -q -O "$TMPFILE" https://openrgb.org/releases/release_0.9/60-openrgb.rules

# Check if the download was successful
if [ ! -s "$TMPFILE" ]; then
    echo "Error: The file could not be downloaded or is empty."
    exit 1
fi

# Check if the rule already exists
if [ -f "$RULEFILE" ]; then
    echo "Rule already exists. Backing up the old rule..."
    sudo mv "$RULEFILE" "$RULEFILE.bak"
    echo "Backup saved as $RULEFILE.bak"
fi

# Install the rule
echo "Installing the udev rule to $DESTDIR..."
sudo cp "$TMPFILE" "$DESTDIR/"

# Reload udev rules
echo "Reloading udev rules..."
sudo udevadm control --reload
sudo udevadm trigger

# Clean up
echo "Removing temporary file..."
rm -f "$TMPFILE"

echo "Done: OpenRGB udev rule has been installed."
