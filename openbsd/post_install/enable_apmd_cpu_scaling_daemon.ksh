#!/bin/ksh

doas rcctl enable apmd
#doas rcctl set apmd flags -A -z 10
doas rcctl set apmd flags -L -z 10
doas rcctl start apmd