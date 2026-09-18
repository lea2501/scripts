#!/bin/sh

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

echo "Getting scripts from github..."
mkdir -p /tmp/repos && cd /tmp/repos || exit 1
git clone https://github.com/lea2501/scripts.git
cd || exit 1
echo ""
printf '\033[33;5m These scripts install and configure all the needed applications and settings. \033[0m\n'
printf '\033[33;5m But you have to pay attention to the prompts and, preferably, read them before launching to know what they do \033[0m\n'
echo ""
echo "Getting scripts from github... DONE"
