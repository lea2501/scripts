#!/bin/ksh

wsconsctl keyboard.bell.volume=0
wsconsctl -a | grep keyboard.bell >> /etc/wsconsctl.conf