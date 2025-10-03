#!/bin/ksh

# script in https://tildegit.org/solene/obsdfreqd

pkg_add obsdfreqd

rcctl enable obsdfreqd
rcctl stop apmd ; rcctl disable apmd

{
	#!/bin/ksh

	daemon="/usr/local/sbin/obsdfreqd"

	. /etc/rc.d/rc.subr

	pexp="${daemon}.*"
	rc_reload=NO
	rc_bg=YES

	rc_cmd $1

} >>/etc/rc.d/obsdfreqd

rcctl start obsdfreqd
