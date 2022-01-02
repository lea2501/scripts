#!/bin/ksh

read -rp "Enter Git user email: " gitUserEmail
git config --global user.email "$gitUserEmail"
read -rp "Enter Git user name: " gitUserName
git config --global user.name "$gitUserName"
git config --global pull.rebase false