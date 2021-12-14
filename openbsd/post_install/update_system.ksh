#!/bin/ksh

print "Installed patches:"
doas syspatch -l
print "available packages:"
doas syspatch -c
print "Installing available patches:"
doas syspatch
print "Update system with syspatch... DONE"