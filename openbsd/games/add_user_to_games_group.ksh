#!/bin/bash

print -n "Enter user name: ";read -r username; print ""
usermod -G games $username