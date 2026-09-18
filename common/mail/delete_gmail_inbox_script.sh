#!/usr/bin/env expect

set timeout 1

proc require_env {name} {
        global env

        if {![info exists env($name)] || [string trim $env($name)] eq ""} {
                puts stderr "ERROR: falta la variable de entorno $name. Definila antes de ejecutar el script."
                exit 1
        }

        return $env($name)
}

set ip "imap.gmail.com"
set socket "993"
set user [require_env "GMAIL_USER"]
set pass [require_env "GMAIL_PASSWORD"]

spawn openssl s_client -connect $ip:$socket -crlf

expect -re ".OK.*" {send "01 LOGIN $user $pass\r"}
expect -re "01 OK.*" {send "02 SELECT INBOX\r"}

expect -re "02 OK.*" {send "03 STORE 1:* +FLAGS (\\Deleted)\r"}
expect -re "03 OK.*" {send "04 EXPUNGE\r"}
expect -re "04 OK.*" {send "05 LOGOUT\r"}
