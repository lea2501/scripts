#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# system
brew install -q \
    tmux vim nano dos2unix bash-completion htop coreutils findutils lm-sensors \
    cmake gradle maven npm jq git allure geany intellij-idea-ce podman \
    flac faac opus-tools vorbis-tools wavpack mpv ffmpeg sox shntool libdvdcss lsdvd vlc \
    moc mkcue rtorrent detox midnight-commander xquartz mupdf \
    curl wget axel firefox geckodriver google-chrome chromedriver jmeter postman tigervnc-viewer openconnect \
    macfuse ntfs-3g rsync clamav libreoffice cabextract unarj p7zip zip unzip gnu-tar bzip2 gzip
