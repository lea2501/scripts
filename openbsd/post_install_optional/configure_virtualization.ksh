#!/bin/ksh

release=$(uname -r)
release_brief=$(echo $release | tr -d ".")

print "INFO: Checking CPU capabilities..."
dmesg | egrep '(VMX/EPT|SVM/RVI)'

print "INFO: Enable and start vmd..."
doas rcctl enable vmd
doas rcctl start vmd
print "INFO: Enable and start vmd... DONE"

print "INFO: Creating VMs directory in ~/vms..."
mkdir -p ~/vms
print "INFO: Creating VMs directory in ~/vms... DONE"

if [ ! -d ~/isos/openbsd/$release ]; then
	print "INFO: Downloading latest RELEASE iso image..."
	mkdir -p ~/isos/openbsd/$release
	cd ~/isos/openbsd/$release
	curl -OL "https://cdn.openbsd.org/pub/OpenBSD/$release/amd64/SHA256"
	curl -OL "https://cdn.openbsd.org/pub/OpenBSD/$release/amd64/SHA256.sig"
	curl -OL "https://cdn.openbsd.org/pub/OpenBSD/$release/amd64/miniroot$release_brief.img"
	curl -OL "https://cdn.openbsd.org/pub/OpenBSD/$release/amd64/cd$release_brief.iso"
	print "INFO: Downloading latest RELEASE iso image... DONE"
fi

if [ ! -f /etc/hostname.vether0 ]; then
	print "INFO: Configuring network bridge..."
	echo 'inet 10.0.0.1 255.255.255.0' | doas tee -a /etc/hostname.vether0
	doas sh /etc/netstart vether0
fi
if [ ! -f /etc/hostname.bridge0 ]; then
	echo 'add vether0' | doas tee -a /etc/hostname.bridge0
	doas sh /etc/netstart bridge0
	print "INFO: Configuring network bridge... DONE"
fi

print ""
print "To create a new VM:"
print "  $ vmctl create -s 10G ~/vms/openbsd_$release_brief.qcow2"
print "  $ doas vmctl start -m 1G -L -i 1 -r ~/isos/openbsd/$release/cd$release_brief.iso -d ~/vms/openbsd_$release_brief.qcow2 openbsd_$release_brief"
print "  $ vmctl show"
print "  $ doas vmctl console openbsd_$release_brief"
print "  $ doas vmctl stop openbsd_$release_brief"
print ""
