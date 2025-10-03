#!/bin/ksh

print -n "Enter user name: ";read -r username; print ""

# Normal user configuration
#Add normal user to the wheel and wsrc groups
usermod -G operator $username
usermod -G staff $username
usermod -G wheel $username
usermod -G wsrc $username
usermod -G games $username
#Make sure you belong to the class (not group) staff:
usermod -L staff $username
