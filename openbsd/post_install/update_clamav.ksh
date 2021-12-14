#!/bin/ksh

doas sed -i 's/Example/#Example/g' /etc/freshclam.conf
doas freshclam
print "Update clamav virus definition database... Done"