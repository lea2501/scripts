#!/bin/ksh

print "In a web browser, create or access your personal Github account (Optional):"
print "  1) In a new tab, open https://github.com in a web browser."
print "  2) Access with your personal Github credentials or create a new one."
print "  3) Access to https://github.com/settings/keys and leave it open"
print ""
echo -e "\033[33;5m Don't close Github page when finished... \033[0m"
print ""
read -r "Press enter when finish to create ssh keys..."
print -n "Generate ssh keys?: (Y|n) ";read -r option; print ""

cat /dev/zero | ssh-keygen -q -t ed25519 -N ""
print "Generate ssh key in $HOME/.ssh/id_ed25519.pub file... DONE"

cat "$HOME"/.ssh/id_ed25519.pub
print ""

print "Add SSH keys to Github account (Optional):"
print "  1) Access ssh-keys settings in https://github.com/settings/keys"
print "  2) Paste the key copied from $HOME/.ssh/id_ed25519.pub and press 'Add key' button."
print ""
