#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# system
brew install -q \
    tmux vim nano dos2unix bash-completion htop coreutils findutils lm-sensors \
    cmake gradle maven npm jq git subversion groovy kotlin allure geany intellij-idea-ce podman \
    flac faac opus-tools vorbis-tools wavpack mpv ffmpeg sox shntool libdvdcss lsdvd vlc \
    moc mkcue avidemux lynx w3m rtorrent detox midnight-commander xquartz mupdf \
    curl wget axel firefox geckodriver google-chrome chromedriver jmeter postman tigervnc-viewer openconnect ngrok \
    osxfuse ntfs-3g rsync clamav freerdp rdesktop libreoffice cabextract unarj p7zip zip unzip gnu-tar bzip2 gzip

## emulators
#brew install -q virtualbox vagrant vagrant-manager
