#!/bin/ksh

print "Installed patches:"
doas syspatch -l
print "available patches:"
doas syspatch -c
print "Installing available patches:"
doas syspatch