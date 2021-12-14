#!/bin/ksh

doas sed -i 's/xconsole/#xconsole/' /etc/X11/xenodm/Xsetup_0
print "Disable xconsole in xenodm... DONE"