#!/bin/ksh

doas cp /etc/fstab /etc/fstab.bak
doas sed -i 's/rw/rw,noatime/' /etc/fstab
print "Improve disk performance... DONE"