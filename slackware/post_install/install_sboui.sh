#!/bin/bash

slackbuilds_dir=$HOME/slackbuilds
mkdir -p "$slackbuilds_dir"

cd "$slackbuilds_dir" || exit

# get dependencies
sbopkg -b "libconfig sboui"