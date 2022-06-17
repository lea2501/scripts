#!/bin/ksh

print -n "Enter user name: ";read -r username; print ""

print "permit persist keepenv nopass $username" >>/etc/doas.conf
#Allow user to run commands as root
#print "permit persist keepenv :wheel" >>/etc/doas.conf
#print "permit persist keepenv :wsrc" >>/etc/doas.conf
#Allow user mounting of an external USB stick
print "permit nopass $username as root cmd mount" >>/etc/doas.conf
print "permit nopass $username as root cmd umount" >>/etc/doas.conf
