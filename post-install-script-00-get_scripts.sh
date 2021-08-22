#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

echo "Getting scripts from github..."
mkdir -p /tmp/scripts && cd /tmp/scripts || return
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/arch/post_install/arch-post_install_script.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/arch/games/arch-post_install_script-games.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/arch/update/arch_update-mirrors-by-speed.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/arch/update/aur_update.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/devuan/post_install/devuan-post_install_script.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/devuan/games/devuan-post_install_script-games.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/macos/post_install/macos-post_install_script.sh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/openbsd/post_install/openbsd-post_install_script-00-ROOT-remove_doas_password.ksh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/openbsd/post_install/openbsd-post_install_script.ksh"
curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/openbsd/games/openbsd-post_install_script-games.ksh"

curl -OL "https://raw.githubusercontent.com/lea2501/scripts/main/startdwm"
chmod +x ./*.sh
cd || return
echo ""
echo -e "\033[33;5m These scripts install and configure all the needed applications and settings. \033[0m"
echo -e "\033[33;5m But you have to pay attention to the prompts and, preferably, read them before launching to know what they do \033[0m"
echo ""
echo "Getting scripts from github... DONE"
