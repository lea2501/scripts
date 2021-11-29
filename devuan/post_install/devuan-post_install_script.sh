#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

username=$USER

cloneRepo() {
  mkdir -p ~/aur
  cd ~/aur || return
  if [ ! -d "$1" ]; then
    git clone https://aur.archlinux.org/"$1".git
    cd "$1" || return
  else
    cd "$1" || return
    git pull
  fi
}

options=(Y y N n)
supercmd=(sudo doas)

# Section: set su command
read -rp "Use 'doas' or 'sudo' for superuser command?: (sudo|doas)" superuser
while [[ " "${supercmd[@]}" " != *" $superuser "* ]]; do
  echo "$superuser: not recognized. Valid options are:"
  echo "${supercmd[@]/%/,}"
  read -rp "?: (sudo|doas)" superuser
done
if [ "$superuser" == "sudo" ]; then
  export su=sudo
elif [ "$superuser" == "doas" ]; then
  export su=doas
fi

# Section: Create xinitrc
read -rp "Create .xinit file in user home directory?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-create_xinitrc.sh
fi

# Section: Disable login manager
read -rp "Disable login manager?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-disable_login_manager.sh
fi

# Section: Get personal dotfiles
read -rp "Get personal dotfiles backups from Github?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-get_personal_backup_files.sh
fi

# Section: Install common packages
read -rp "Install common packages?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-install_common_packages.sh
fi

# Section: Install 'minimal tools'
read -rp "Install 'minimal tools'?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-install_minimal_tools.sh
fi

# Section: Install external packages 'tools'
read -rp "Install external packages 'tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-install_tools.sh
fi

# Section: Install external packages 'testing browsers'
read -rp "Install external packages 'testing browsers'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then

fi

# Section: Install external packages 'other browsers'
read -rp "Install external packages 'other browsers'?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-install_other_browsers.sh
fi

# Section: Install external packages 'testing tools'
read -rp "Install external packages 'testing tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-install_testing_tools.sh
fi

# Section: Install external packages 'android tools'
read -rp "Install external packages 'android tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-install_android_tools.sh
fi

# Section: Install external packages 'appium'
read -rp "Install external packages 'appium'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-install_appium.sh
fi

# Section: Install external packages 'development'
read -rp "Install external packages 'development'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-install_development_tools.sh
fi

# Section: Create user aliases in bash_aliases file
read -rp "Create user aliases in bash_aliases file?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-create_user_aliases.sh
fi

# Section: Generate ssh keys
read -rp "Generate ssh keys?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-generate_ssh_key.sh
fi

# Section: Apply fix for misbehaving java applications
read -rp "Apply fix for misbehaving java applications?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-apply_java_applications_fix.sh
fi

# Section: Set keyboard layout
read -rp "Set keyboard layout?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-set_keyboard_layout.sh
fi

# Section: Configure Git
read -rp "Configure Git?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-configure_git.sh
fi

# Section: Clone personal repos
read -rp "Clone personal repos?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-clone_personal_repos.sh
fi

# Section: Set java default version
read -rp "Set java default version?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-set_java_version.sh
fi

# Section: Start and configure services
read -rp "Start and configure services?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-start_services.sh
fi

# Section: Enable Bash git prompt
read -rp "Enable Bash git prompt?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-enable_bash_git_prompt.sh
fi

# Section: Update clamav antivirus
read -rp "Update clamav antivirus?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-update_clamav.sh
fi

# Section: Set PATH in ~/bashrc file
read -rp "Set PATH in ~/bashrc file?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./devuan-post_install_script-create_bin_directory.sh
fi


