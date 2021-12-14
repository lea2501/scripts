#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Open Docker from Finder > Applications and start Docker daemon..."
echo "  Also, in 'Preferences' > 'Resources' > 'Memory' set needed Memory amount"
echo "  (Selenium jobs limit is between 4Gb and 6Gb each)"
read -p "Press enter to continue"
echo "Open Docker from Finder > Applications and start Docker daemon... DONE"

# setup docker
echo "Setup docker for normal user usage..."
sudo groupadd docker || true
sudo gpasswd -a $USER docker || true
echo "Setup docker for normal user usage... DONE"