#!/bin/ksh

print -n "Enter Git user email: ";read -r gitUserEmail; print ""
git config --global user.email "$gitUserEmail"
print -n "Enter Git user name: ";read -r gitUserName; print ""
git config --global user.name "$gitUserName"
git config --global pull.rebase false
