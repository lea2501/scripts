#!/bin/sh

# fail if any commands fails
set -e
# debug log
#set -x

firefox-esr -no-remote -CreateProfile default-esr
firefox-esr -no-remote -CreateProfile default-nojs