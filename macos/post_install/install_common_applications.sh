#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# system
brew install -q tmux vim nano dos2unix bash-completion htop coreutils findutils lm-sensors

# devel
brew install -q cmake gradle maven npm jq git subversion groovy kotlin allure geany intellij-idea-ce podman

# multimedia
brew install -q flac faac opus-tools vorbis-tools wavpack mpv ffmpeg sox shntool libdvdcss lsdvd vlc

# extra tools
brew install -q moc mkcue avidemux lynx w3m rtorrent detox midnight-commander xquartz mupdf

# network tools
brew install -q curl wget axel firefox geckodriver google-chrome chromedriver jmeter postman tigervnc-viewer openconnect ngrok

# tools
brew install -q osxfuse ntfs-3g rsync clamav freerdp rdesktop libreoffice cabextract unarj p7zip zip unzip gnu-tar bzip2 gzip

## emulators
#brew install -q virtualbox vagrant vagrant-manager
