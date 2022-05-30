#!/bin/ksh

mkdir -p /etc/X11/xorg.conf.d

{
    print 'Section "Device"'
    print '  Identifier "drm"'
    print '  Driver "intel"'
    print '  Option "TearFree" "true"'
    print 'EndSection'

} >>/etc/X11/xorg.conf.d/intel.conf
