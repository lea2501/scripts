#!/bin/ksh

doas pkg_add -u

cd || return

# system
doas pkg_add vim dos2unix exfat-fuse xclip autocutsel xosd usbutils findutils tree coreutils
doas pkg_add inconsolata-font hack-fonts dina-fonts liberation-fonts terminus-font

# minimal-tools
doas pkg_add st

# devel
doas pkg_add cmake gmake jdk maven gradle jq git adb

# multimedia
doas pkg_add flac opus-tools vorbis-tools wavpack mpv ffmpeg ffmpeg-normalize sox shntool

# extra tools
doas pkg_add moc lynx w3m newsboat rtorrent amule youtube-dl pcmanfm detox scrot mc rarcrack fcrackzip pdfcrack ddrescue fdupes
doas pkg_add comix qpdf zathura zathura-pdf-mupdf zathura-djvu zathura-ps zathura-cb mupdf

# forensic tools
doas pkg_add foremost testdisk sleuthkit

# images
doas pkg_add feh geeqie gimp ImageMagick

# net
doas pkg_add curl axel tigervnc openconnect samba onionshare

# tools
doas pkg_add ntfs_3g rsync clamav rdesktop libreoffice keepassxc cabextract unrar p7zip unzip galculator password-store pass-otp zbar

# emulators
#doas pkg_add qemu