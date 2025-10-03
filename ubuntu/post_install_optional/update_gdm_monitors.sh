#!/bin/sh

# Variables
SRC="$HOME/.config/monitors.xml"
DEST="/var/lib/gdm3/.config/monitors.xml"
BACKUP="/var/lib/gdm3/.config/monitors.xml.bak"

# Detect session type (Wayland or Xorg)
SESSION_ID="$(loginctl | grep $(whoami) | awk '{print $1}')"
SESSION_TYPE="$(loginctl show-session "$SESSION_ID" -p Type | cut -d= -f2)"

# Check if source file exists
if [ ! -f "$SRC" ]; then
    echo "Error: Source file $SRC not found."
    exit 1
fi

# Check if GDM is active
if ! systemctl is-active --quiet gdm3; then
    echo "Warning: gdm3 service is not active."
fi

# Display session type
echo "Current display server: $SESSION_TYPE"

# Backup existing monitors.xml if present
if [ -f "$DEST" ]; then
    echo "Creating backup of current GDM monitors.xml..."
    sudo cp "$DEST" "$BACKUP"
    sudo chown gdm:gdm "$BACKUP"
fi

# Copy new monitors.xml
echo "Copying new monitors.xml configuration..."
sudo cp "$SRC" "$DEST"
sudo chown gdm:gdm "$DEST"

# Ask whether to restart GDM
printf "Do you want to restart GDM now to apply changes? [y/N]: "
read ans
case "$ans" in
    y|Y)
        echo "Restarting GDM..."
        sudo systemctl restart gdm3
        ;;
    *)
        echo "GDM was not restarted. Please reboot or restart it manually."
        ;;
esac

echo "Done."
