#!/bin/ksh

doas pkg_add syncthing
syncthing_xsession="$(cat ~/.xsession | grep "syncthing --no-browser &")"
if [ "$syncthing_xsession" = "" ]; then
	print "INFO: Adding syncthing to ~/.xsession..."
	{
		echo ""
		echo '# start syncthing'
		echo 'syncthing --no-browser &'
	} >>$HOME/.xsession
fi

kern_maxfiles="$(cat /etc/sysctl.conf | grep "kern.maxfiles=80000")"
if [ "$kern_maxfiles" = "" ]; then
  doas sed 's/kern.maxfiles=.*/kern.maxfiles=80000/' /etc/sysctl.conf
  doas sysctl kern.maxfiles=80000
fi

doas cp /etc/login.conf /etc/login.conf.bak
doas sed -ie 's/:openfiles-max=1024:/:openfiles-max=16000:/g' /etc/login.conf
doas sed -ie 's/:openfiles-cur=512:/:openfiles-cur=8000:/g' /etc/login.conf

syncthing_loginconf="$(cat /etc/login.conf | grep "syncthing:")"
if [ "$syncthing_loginconf" = "" ]; then
	print "INFO: Adding syncthing to /etc/login.conf..."
	{
		echo ''
		echo 'syncthing:\'
		echo '        :openfiles-cur=8000:\'
		echo '        :openfiles-max=16000:\'
		echo '        :tc=daemon:'
	} | doas tee -a /etc/login.conf
	doas cap_mkdb /etc/login.conf
fi

echo ""
echo "  NOTE: On OpenBSD is better to disable 'watch for changes' and then set 'full rescan interval = 60'"
echo "        in the 'advanced' tab in a folder's settings (on the web UI)."
echo ""
echo "        This is to avoid the warning: "
echo "         Filesystem watching (kqueue) is enabled on 'Folder' (XXXX) with a lot of files/directories"