#!/bin/ksh

cp /etc/X11/xenodm/Xsetup_0 /etc/X11/xenodm/Xsetup_0.bak

{
    print ""
    print "# Set xrandr"
    print "if [ \"\$(xrandr | grep 'HDMI-A-0 connected')\" != \"\" ]; then"
    print "  xrandr --output HDMI-A-0 --auto --output eDP --off"
    print "fi"
} >>/etc/X11/xenodm/Xsetup_0
