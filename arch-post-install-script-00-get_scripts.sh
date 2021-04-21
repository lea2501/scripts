#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

echo "Getting scripts from github..."
mkdir -p ~/script && cd ~/script || return
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/arch-post-install-script-01-set_basic_config.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/arch-post-install-script-02-install_pacman_packages.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/arch-post-install-script-03-install_aur_packages.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/arch-post-install-script-04-clone_repositories.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/arch-post-install-script-05-configure_applications.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/arch-post-install-script-games-packages.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/arch-post-install-script-removeAskingSudoPassword.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/aur_update.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/startdwm"

curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/macos-install-script-01-set_basic_config.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/macos-install-script-02-install_packages.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/macos-install-script-03-clone_repositories.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/macos-install-script-04-configure_applications.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/macos-install-script-install_android_tools.sh"
chmod +x ./*.sh
cd || return
echo "Getting scripts from github... DONE"
