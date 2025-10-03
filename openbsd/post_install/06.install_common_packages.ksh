#!/bin/ksh

doas pkg_add -u

cd || return

# system
doas pkg_add \
    vim dos2unix exfat-fuse usbutils findutils tree coreutils \
    xclip autocutsel xosd pcmanfm detox scrot \
    inconsolata-font hack-fonts dina-fonts liberation-fonts terminus-font \
    st slock dmenu \
    cmake gmake jdk maven npm python python-pip gradle jq git adb intellij geany cppcheck \
    flac opus-tools vorbis-tools wavpack mpv ffmpeg ffmpeg-normalize sox shntool \
    moc lynx newsboat rtorrent amule yt-dlp mc rarcrack fcrackzip pdfcrack ddrescue fdupes \
    comix qpdf zathura zathura-pdf-mupdf zathura-djvu zathura-ps zathura-cb mupdf \
    foremost testdisk sleuthkit \
    feh geeqie gimp ImageMagick tesseract tesseract-eng tesseract-spa optipng \
    ssh-copy-id curl axel rsync tigervnc openconnect onionshare clamav rdesktop \
    firefox-esr geckodriver chromium tor tor-browser \
    ntfs_3g libreoffice keepassxc cabextract unrar p7zip unzip innoextract galculator zbar \
    qemu

#netsurf badwolf dooble qutebrowser amfora lagrange
