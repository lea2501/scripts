#!/usr/bin/expect -f
#!/usr/lib/postfix/sbin/
set BASEDIR [file dirname [ dict get [ info frame 0 ] file ]]
set SERVERHOST  boromir.fibertel.com.ar/CTO
set SERVERCERT  pin-sha256:19N0NqmmW2PqYhxU5nOizGCV00eSeND8sinOLrX3Qss=
set MYUSERNAME  {USER}
set MYPASSWORD  {PASSWORD}
set MYREALM     CTO-Operaciones
set TOKEN       [lindex $argv 0]
set timeout 30
log_user 1
puts stderr "Connecting to VPN server"
spawn /usr/sbin/openconnect --juniper $SERVERHOST --servercert $SERVERCERT --no-dtls
expect "realm\*:"
send $MYREALM\n
expect "sername:"
send $MYUSERNAME\n
expect "password:"
send $MYPASSWORD\n
expect "password#2:"
send $TOKEN\n
#expect "frmSelectRoles\*:"
#send $MYROLE\n
interact