#!/bin/ksh

{
    print ""
    print "# Disable .core file generation"
    print "ulimit -Sc 0"
} >>$HOME/.profile
