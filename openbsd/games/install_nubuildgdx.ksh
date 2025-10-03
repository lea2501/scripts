#!/bin/ksh

doas pkg_add jdk

application=NuBuildGDX
repository=atsb/NuBuildGDX
cd || return
mkdir -p ~/bin/${application}
cd ~/bin/${application} || return
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/"$repository"/releases/latest | grep browser_download_url | grep ".zip" | head -n 1 | cut -d '"' -f 4)
curl -OL "$DOWNLOAD_URL"
unzip ./*.zip
rm *.zip
echo "NOTE: To play run: $ /usr/local/jdk-17/bin/java -jar ~/bin/NuBuildGDX/NuBuildGDX.jar"

cd - || return