#!/bin/ksh

sysctl kern.video.record=1
echo kern.video.record=1 >> /etc/sysctl.conf
