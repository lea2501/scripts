#!/bin/sh

# fail if any commands fails
set -e
# debug log
#set -x

firefox-esr -CreateProfile default-esr
firefox-esr -CreateProfile default-nojs