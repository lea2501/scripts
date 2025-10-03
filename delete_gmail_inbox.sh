#!/usr/bin/expect

#you can modify the timeout if the script fails
set timeout 1

#our connection variables
set ip "pop.gmail.com"
set socket "995"
set user "flowfactoryautomation@gmail.com"
set pass "auto1234AUTO1234"

#we set the address we want to remove mails from here. Escape special regex characters such as dots.
set target_address "mail\.example@gmail\.com"

#we launch the subprocess we want to interact with
spawn openssl s_client -connect $ip:$socket -quiet

#if connection went all right, we try to login
expect -re ".OK.*" {send "user $user\r"}
expect -re ".OK.*" {send "pass $pass\r"}

#if login went alright, we try to count the messages on the server
#you will get the following output :
#+OK NB_MSG TOTAL_SIZE
expect -re ".OK.*" {send "stat\r"}

#if the stat command went alright ...
expect -re ".OK.*" {
        #we extract the number of mail from the output of the stat command
        set mail_count [lindex [split [lindex [split $expect_out(buffer) \n] 1] " "] 1]

        #we iterate through every email...
        for {set i 1} {$i <= $mail_count} {incr i 1} {
            #we retrieve the header of the email
            send "top $i 0\r"
            
            #if the header contains "To: $target_address" (or "To: <$target_address>" or "To: Contact Name <$target_address>" ...)
            #to filter according to the sender, change the regex to "\nFrom: ..."
            expect -re "\nTo: \[^\n\]*$target_address" {
                    #we delete the email
                    send "dele $i\r"
            }
        }
}
expect default
