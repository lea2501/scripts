#!/bin/ksh

cd /usr
if [ ! -d /usr/ports ]; then
    echo "INFO: Directory /usr/ports does not exist, downloading ports tree..."
    doas ftp https://ftp.openbsd.org/pub/OpenBSD/$(uname -r)/ports.tar.gz
    doas ftp https://ftp.openbsd.org/pub/OpenBSD/$(uname -r)/SHA256.sig
    echo "INFO: Checking downloaded file with signify..."
    doas signify -C -p /etc/signify/openbsd-$(uname -r | cut -c 1,3)-base.pub -x SHA256.sig ports.tar.gz
    echo "INFO: Extracting downloaded file..."
    doas tar xzf ports.tar.gz
    doas rm ports.tar.gz SHA256.sig
fi

echo "INFO: Updating ports tree in /usr/ports..."
cd /usr
doas cvs -qd anoncvs@anoncvs.ca.openbsd.org:/cvs checkout -rOPENBSD_$(uname -r | tr . _) -P ports
