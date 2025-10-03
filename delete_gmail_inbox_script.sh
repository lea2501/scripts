#!/usr/bin/expect

set timeout 1

set ip "imap.gmail.com"
set socket "993"
set user "flowfactoryautomationbeta@gmail.com"
set pass "auto1234AUTO1234"

spawn openssl s_client -connect $ip:$socket -crlf

expect -re ".OK.*" {send "01 LOGIN $user $pass\r"}
expect -re "01 OK.*" {send "02 SELECT INBOX\r"}

expect -re "02 OK.*" {send "03 STORE 1:* +FLAGS (\\Deleted)\r"}
expect -re "03 OK.*" {send "04 EXPUNGE\r"}
expect -re "04 OK.*" {send "05 LOGOUT\r"}
