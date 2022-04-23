#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

apt-get -y --fix-missing install amd64-microcode
#apt-get -y --fix-missing install amd64-microcode/chimaera-backports
#apt-get -y --fix-missing install linux-image-amd64/chimaera-backports firmware-linux/chimaera-backports firmware-linux-nonfree/chimaera-backports firmware-amd-graphics/chimaera-backports libgl1-mesa-dri/chimaera-backports libglx-mesa0/chimaera-backports mesa-vulkan-drivers/chimaera-backports xserver-xorg-video-all/chimaera-backports
apt-get -y --fix-missing install linux-image-amd64 firmware-linux firmware-linux-nonfree firmware-amd-graphics libgl1-mesa-dri libglx-mesa0 mesa-vulkan-drivers xserver-xorg-video-all

echo > /etc/X11/xorg.conf.d/20-amdgpu.conf <<EOF
Section "Device"
   Identifier  "AMD Graphics"
   Driver      "amdgpu"
   Option      "TearFree"  "true"
EndSection
EOF