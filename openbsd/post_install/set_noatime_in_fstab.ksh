#!/bin/ksh

doas cp /etc/fstab /etc/fstab.bak
doas sed -ie 's/rw/rw,softdep,noatime/g' /etc/fstab
