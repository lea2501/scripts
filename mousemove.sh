#!/bin/bash
LENGTH=100
#
# Set DELAY to the desired number of seconds between each move of the mouse pointer.
DELAY=30
#
while true
do
    for ANGLE in 0 90 180 270
    do
        xdotool mousemove_relative --polar $ANGLE $LENGTH
        sleep $DELAY
    done
done
