#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# Set superuser privileges command if not set
if [ -z "${su+x}" ]; then
  su="sudo"
fi

$su apt-get install -y supertuxkart

mkdir -p $HOME/.local/share/supertuxkart/addons/
cd $HOME/.local/share/supertuxkart/addons/ || return

echo ""
echo "================================================================="
echo "Please download manually the file from Box:"
echo "  https://app.box.com/s/bb2opvj3e5tctpg802rs9ar1pjutaj9j"
echo "Save it in ~/Downloads"
echo "After downloading, press any key to continue..."
echo "================================================================="
read -n 1 -s -r
echo ""

mv $HOME/Downloads/supertuxkart_tente3D.zip .
unzip supertuxkart_tente3D.zip

# to have it in all users
#$su cp supertuxkart_tente3D.zip /usr/share/games/supertuxkart/data/
#cd /usr/share/games/supertuxkart/data/ || return
#unzip supertuxkart_tente3D.zip
#rm supertuxkart_tente3D.zip