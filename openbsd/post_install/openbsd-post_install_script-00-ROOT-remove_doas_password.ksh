#!/bin/ksh

# fail if any commands fails
set -e
# debug log
#set -x

echo "Removing asking for doas password for user..."
print "permit nopass $USER" >>/etc/doas.conf
#Allow user to run commands as root
print "permit nopass keepenv :wheel" >>/etc/doas.conf
print "permit nopass keepenv :wsrc" >>/etc/doas.conf
#Allow user mounting of an external USB stick
print "permit nopass $USER as root cmd mount" >>/etc/doas.conf
print "permit nopass $USER as root cmd umount" >>/etc/doas.conf

# Normal user configuration
#Add normal user to the wheel and wsrc groups
user mod -G wheel $USER
user mod -G wsrc $USER
#Make sure you belong to the class (not group) staff:
user mod -L staff $USER
echo "Removing asking for doas password for user... DONE"
