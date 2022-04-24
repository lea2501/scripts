#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

options=(Y y N n)

# Section: Create xinitrc
read -rp "Install brew?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_brew.sh
fi

# Section: Install common packages
read -rp "Install common packages?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_jdk.sh
  ./install_common_applications.sh
fi

# Section: Install packages 'testing tools'
read -rp "Install packages 'testing tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_testing_tools.sh
fi

# Section: Install packages 'android tools'
read -rp "Install packages 'android tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_android_tools.sh
fi

# Section: Install packages 'appium'
read -rp "Install packages 'appium'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_appium.sh
fi

# Section: Install packages 'docker'
read -rp "Install packages 'docker'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_docker.sh
fi

# Section: Generate ssh keys
read -rp "Generate ssh keys?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./generate_ssh_key.sh
fi

# Section: Configure Git
read -rp "Configure Git?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./configure_git.sh
fi

# Section: Set java default version
read -rp "Set java default version?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./set_java_version.sh
fi

# Section: Configure and start docker
read -rp "Configure and start docker?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./configure_and_start_docker.sh
fi

# Section: Update clamav antivirus
read -rp "Update clamav antivirus?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./update_clamav.sh
fi

# Section: Set PATH in ~/bashrc file
read -rp "Set PATH in ~/bashrc file?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|N)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./create_user_bin_directory.sh
fi
