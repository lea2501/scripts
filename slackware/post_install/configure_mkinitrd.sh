#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# configure slackpkgmirror
cp /etc/mkinitrd.conf.sample /etc/mkinitrd.conf
cat /etc/mkinitrd.conf | sed -e "s/#SOURCE_TREE=/SOURCE_TREE=/" | tee /etc/mkinitrd.conf
cat /etc/mkinitrd.conf | sed -e "s/#CLEAR_TREE=/CLEAR_TREE=/" | tee /etc/mkinitrd.conf
cat /etc/mkinitrd.conf | sed -e "s/#OUTPUT_IMAGE=/OUTPUT_IMAGE=/" | tee /etc/mkinitrd.conf
cat /etc/mkinitrd.conf | sed -e "s/#KEYMAP="us"/KEYMAP="la_latin1"/" | tee /etc/mkinitrd.conf
cat /etc/mkinitrd.conf | sed -e "s/#MODULE_LIST=/MODULE_LIST=/" | tee /etc/mkinitrd.conf
cat /etc/mkinitrd.conf | sed -e "s/#SOURCE_TREE=/SOURCE_TREE=/" | tee /etc/mkinitrd.conf
cat /etc/mkinitrd.conf | sed -e "s/#SOURCE_TREE=/SOURCE_TREE=/" | tee /etc/mkinitrd.conf
cat /etc/mkinitrd.conf | sed -e "s/#SOURCE_TREE=/SOURCE_TREE=/" | tee /etc/mkinitrd.conf
cat /etc/mkinitrd.conf | sed -e "s/#SOURCE_TREE=/SOURCE_TREE=/" | tee /etc/mkinitrd.conf
cat /etc/mkinitrd.conf | sed -e "s/#SOURCE_TREE=/SOURCE_TREE=/" | tee /etc/mkinitrd.conf
cat /etc/mkinitrd.conf | sed -e "s/#SOURCE_TREE=/SOURCE_TREE=/" | tee /etc/mkinitrd.conf
