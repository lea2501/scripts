#!/bin/ksh

print "Fetching the Ports Tree..."
cd /tmp
ftp https://cdn.openbsd.org/pub/OpenBSD/$(uname -r)/{ports.tar.gz,SHA256.sig}
signify -Cp /etc/signify/openbsd-$(uname -r | cut -c 1,3)-base.pub -x SHA256.sig ports.tar.gz
print "Fetching the Ports Tree... DONE"

print "Unpacking ports..."
cd /usr
doas mkdir -p ports
doas tar xzf /tmp/ports.tar.gz
doas chgrp -R wsrc ports
doas chmod -R 775 ports
cvs -qd anoncvs@anoncvs.au.openbsd.org:/cvs checkout -rOPENBSD_$(uname -r | tr . _) -P ports

config_ports="$(cat /etc/mk.conf 2>/dev/null | grep "WRKOBJDIR=/usr/obj/ports")"
if [ "$config_ports" = "" ]; then
	print "INFO: Adding port config to /etc/mk.conf..."
	{
		echo "WRKOBJDIR=/usr/obj/ports"
		echo "DISTDIR=/usr/distfiles"
		echo "PACKAGE_REPOSITORY=/usr/packages"
	} | doas tee -a /etc/mk.conf
fi

doas pkg_add portslist
