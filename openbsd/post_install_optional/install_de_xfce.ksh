#!/bin/ksh

username=${1:-${DOAS_USER:-$(id -un)}}

if [ -z "$username" ] || [ "$username" = "root" ]; then
	print -u2 "Usage: $0 username"
	print -u2 "Run this script as the regular user, or provide the target username."
	exit 1
fi

if ! id "$username" >/dev/null 2>&1; then
	print -u2 "User does not exist: $username"
	exit 1
fi

doas pkg_add xfce xfce-extras ## install xfce desktop
doas sed -i 's/xconsole/#xconsole/' /etc/X11/xenodm/Xsetup_0 # no xconcole
doas usermod -G operator,wheel "$username" # enable power controls and doas access
#echo "permit persist :wheel" >> /etc/doas.conf # doas = sudo
doas rcctl enable messagebus ## enable dbus
doas rcctl start messagebus ## start dbus
doas rcctl enable apmd ## enable power daemon
doas rcctl start apmd  ## start power daemon
echo "exec startxfce4" > ~/.xsession ## auto launchs xfce4 desktop


doas pkg_add gnome
doas rcctl disable xenodm
echo "Disable xenodm > OK"
doas rcctl enable multicast messagebus avahi_daemon gdm
echo "Enable 'multicast messagebus avahi_daemon gdm' > OK"
