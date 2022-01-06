#!/bin/ksh

sysctl kern.audio.record=1
echo kern.audio.record=1 >> /etc/sysctl.conf
