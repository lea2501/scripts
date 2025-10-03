#!/bin/ksh

doas sed -i '/google/d' /etc/ntpd.conf
doas rcctl restart ntpd