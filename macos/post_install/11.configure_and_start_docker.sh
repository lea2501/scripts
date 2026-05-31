#!/bin/bash
set -e

# Post-install Docker configuration

echo "Open Docker from Applications and start the daemon..."
echo "In Preferences > Resources > Memory, set needed amount (4-6GB for Selenium)."
read -rp "Press enter to continue after Docker is running..."
