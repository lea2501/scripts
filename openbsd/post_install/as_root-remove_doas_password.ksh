#!/bin/ksh

print -n "Enter user name: ";read -r username; print ""

print "permit nopass $username" >>/etc/doas.conf
#Allow user to run commands as root
print "permit nopass keepenv :wheel" >>/etc/doas.conf
print "permit nopass keepenv :wsrc" >>/etc/doas.conf
#Allow user mounting of an external USB stick
print "permit nopass $username as root cmd mount" >>/etc/doas.conf
print "permit nopass $username as root cmd umount" >>/etc/doas.conf

# Normal user configuration
#Add normal user to the wheel and wsrc groups
usermod -G wheel $username
usermod -G wsrc $username
usermod -G games $username
#Make sure you belong to the class (not group) staff:
usermod -L staff $username
