#!/bin/ksh

doas pkg_add xfce xfce-extras ## install xfce desktop
doas sed -i 's/xconsole/#xconsole/' /etc/X11/xenodm/Xsetup_0 # no xconcole
doas usermod -G operator <user name> # so you can use xfce to log out, reboot etc
doas usermod -G wheel <user name> # so you can use doas
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
