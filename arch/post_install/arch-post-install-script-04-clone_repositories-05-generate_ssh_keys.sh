#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Create or access Gitlab account:"
echo "  1) Open http://10.200.172.71 in a web browser."
echo "  2) Access with your Gitlab credentials or create a new one."
echo "  3) Ask another member of the automation team to give you access to the Gitlab automation group."
echo "  4) Access to http://10.200.172.71/profile/keys and leave it open"
echo ""
echo -e "\033[33;5m Don't close Gitlab page when finished... \033[0m"
echo ""
echo "Also, IN A NEW TAB create or access Bitbucket account:"
echo "  1) In a new tab, open https://bitbucket.org/tecoflowfactory/ in a web browser."
echo "  2) Access with your Bitbucket (Jira) credentials or create a new one."
echo "  3) Access to https://bitbucket.org/account/settings/ssh-keys/ and leave it open"
echo ""
echo -e "\033[33;5m Don't close Bitbucket page when finished... \033[0m"
echo ""
echo "Also, IN A NEW TAB create or access your personal Github account (Optional):"
echo "  1) In a new tab, open https://github.com in a web browser."
echo "  2) Access with your personal Github credentials or create a new one."
echo "  3) Access to https://github.com/settings/keys and leave it open"
echo ""
echo -e "\033[33;5m Don't close Github page when finished... \033[0m"
echo ""
read -rp "Press enter when finish to create ssh keys..."

echo "Generating ssh key in ~/.ssh/id_rsa.pub file..."
cat /dev/zero | ssh-keygen -q -N ""
echo "Generating ssh key in ~/.ssh/id_rsa.pub file... DONE"

echo "Copying content of '~/.ssh/id_rsa.pub' file to the clipboard..."
xclip -sel c <~/.ssh/id_rsa.pub
echo "Copying content of '~/.ssh/id_rsa.pub' file to the clipboard... DONE"
echo ""
echo -e "\033[33;5m If you copy other thing to the clipboard, here is your ssh public key, ready to copy again... \033[0m"
echo ""
cat ~/.ssh/id_rsa.pub
echo ""

echo "Add SSH keys to Gitlab account:"
echo "  1) Access ssh-keys settings in http://10.200.172.71/profile/keys"
echo "  2) Paste the key copied from ~/.ssh/id_rsa.pub and press 'Add key' button."
echo ""
read -rp "Press enter when finish to continue..."
echo ""
echo "Add SSH keys to Bitbucket account:"
echo "  1) Access ssh-keys settings in https://bitbucket.org/account/settings/ssh-keys/"
echo "  2) Paste the key copied from ~/.ssh/id_rsa.pub and press 'Add key' button."
echo ""
read -rp "Press enter when finish to continue..."