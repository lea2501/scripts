#!/bin/ksh

print ""
echo -e "\033[33;5m If using laptop, unplug any external displays if connected... \033[0m"
print ""
read -r "Press enter when finish to continue..."

if [ ! -f /etc/X11/xorg.conf.d/20-intel.conf ]; then
	{
		echo "Section \"Device\""
		echo "    Identifier \"Intel Graphics\""
		echo "    Driver \"intel\""
		echo "    Option \"TearFree\" \"true\""
		echo "EndSection"
	} | doas tee -a /etc/X11/xorg.conf.d/20-intel.conf
fi

output=$(xrandr | grep " connected " | awk '{print $1;}')
output=$(echo $output|tr -d '\n')

echo "To enable immediately just type: '$ xrandr --output $output --set TearFree on'"
