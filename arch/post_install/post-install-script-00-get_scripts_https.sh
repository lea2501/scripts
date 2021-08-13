#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

echo "Getting scripts from github..."
mkdir -p ~/src && cd ~/src || return
git clone https://github.com/lea2501/scripts.git
cd || return
echo ""
echo -e "\033[33;5m These scripts install and configure all the needed applications and settings. \033[0m"
echo -e "\033[33;5m But you have to pay attention to the prompts and, preferably, read them before launching to know what they do \033[0m"
echo ""
echo "Getting scripts from github... DONE"
