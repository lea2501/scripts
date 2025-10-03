#!/bin/ksh

doas cp /etc/fstab /etc/fstab.bak
doas sed -ie 's/rw/rw,noatime/g' /etc/fstab
