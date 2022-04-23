#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

apt-get -y --fix-missing install linux-image/chimaera-backports firmware-linux/chimaera-backports firmware-linux-nonfree/chimaera-backports firmware-amd-graphics/chimaera-backports libgl1-mesa-dri/chimaera-backports libglx-mesa0/chimaera-backports mesa-vulkan-drivers/chimaera-backports xserver-xorg-video-all/chimaera-backports