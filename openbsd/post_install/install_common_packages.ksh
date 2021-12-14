#!/bin/ksh

doas pkg_add -u
print "Update system repositories and packages... DONE"

cd || return

# system
doas pkg_add vim dos2unix exfat-fuse xclip autocutsel xosd usbutils htop findutils tree
doas pkg_add inconsolata-font hack-fonts dina-fonts liberation-fonts terminus-font

# minimal-tools
doas pkg_add st

# devel
doas pkg_add cmake gmake jdk maven gradle jq git mariadb-server mariadb-client geany

# multimedia
doas pkg_add flac opus-tools vorbis-tools wavpack mpv ffmpeg ffmpeg-normalize sox shntool lsdvd

# extra tools
doas pkg_add moc lynx w3m newsboat rtorrent amule youtube-dl pcmanfm detox scrot mc rarcrack fcrackzip pdfcrack ddrescue fdupes
doas pkg_add comix qpdf zathura zathura-pdf-mupdf zathura-djvu zathura-ps zathura-cb mupdf

# forensic tools
doas pkg_add foremost testdisk sleuthkit

# images
doas pkg_add feh geeqie gimp ImageMagick

# net
doas pkg_add curl axel tigervnc openconnect samba tor tor-browser onionshare

# tools
doas pkg_add ntfs_3g rsync clamav rdesktop libreoffice keepassxc cabextract unrar p7zip unzip galculator

# emulators
doas pkg_add qemu

print "install packages... DONE"