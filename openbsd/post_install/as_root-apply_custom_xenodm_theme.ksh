#!/bin/ksh

mv /etc/X11/xenodm/Xresources /etc/X11/xenodm/Xresources.bak

{
    print "xlogin.Login.echoPasswd:       true"
    print "xlogin.Login.fail:             fail"
    print "xlogin.Login.greeting:"
    print "xlogin.Login.namePrompt:       \040login\040"
    print "xlogin.Login.passwdPrompt:     passwd\040"
    print ""
    print "xlogin.Login.height:           180"
    print "xlogin.Login.width:            280"
    print "xlogin.Login.y:                320"
    print "xlogin.Login.frameWidth:       0"
    print "xlogin.Login.innerFramesWidth: 0"
    print ""
    print "xlogin.Login.background:       black"
    print "xlogin.Login.foreground:       #eeeeee"
    print "xlogin.Login.failColor:        white"
    print "xlogin.Login.inpColor:         black"
    print "xlogin.Login.promptColor:      #eeeeec"
    print ""
    print "xlogin.Login.face:             fixed-13"
    print "xlogin.Login.failFace:         fixed-13"
    print "xlogin.Login.promptFace:       fixed-13"

} >>/etc/X11/xenodm/Xresources
