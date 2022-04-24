#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "In a web browser, create or access your personal Github account (Optional):"
echo "  1) In a new tab, open https://github.com in a web browser."
echo "  2) Access with your personal Github credentials or create a new one."
echo "  3) Access to https://github.com/settings/keys and leave it open"
echo ""
echo -e "\033[33;5m Don't close Github page when finished... \033[0m"
echo ""
read -rp "Press enter when finish to create ssh keys..."

echo "Generating ssh key in $HOME/.ssh/id_rsa.pub file..."
cat /dev/zero | ssh-keygen -q -N ""
echo "Generating ssh key in $HOME/.ssh/id_rsa.pub file... DONE"

#echo "Copying content of '~/.ssh/id_rsa.pub' file to the clipboard..."
#xclip -sel c <~/.ssh/id_rsa.pub
#echo "Copying content of '~/.ssh/id_rsa.pub' file to the clipboard... DONE"
#echo ""
#echo -e "\033[33;5m If you copy other thing to the clipboard, here is your ssh public key, ready to copy again... \033[0m"
#echo ""
cat ~/.ssh/id_rsa.pub
echo ""

echo "Add SSH keys to Github account (Optional):"
echo "  1) Access ssh-keys settings in https://github.com/settings/keys"
echo "  2) Paste the key copied from ~/.ssh/id_rsa.pub and press 'Add key' button."
echo ""
