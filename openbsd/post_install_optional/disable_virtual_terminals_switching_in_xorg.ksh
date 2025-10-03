#!/bin/ksh

{
	echo "Section \"ServerFlags\""
	echo "        Option \"DontVTSwitch\" \"True\""
	echo "        Option \"DontZap\"      \"True\""
	echo "EndSection"
} | doas tee -a /etc/xorg.conf

ls -lahF /etc/xorg.conf
