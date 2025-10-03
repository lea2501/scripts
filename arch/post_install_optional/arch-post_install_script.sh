#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

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

# Section: Artix. Add arch linux repos
read -rp "Add arch linux repos to Artix linux?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./artix-add_arch_linux_repositories_support.sh
fi

# Section: Create xinitrc
read -rp "Create .xinit file in user home directory?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./create_xinitrc.sh
fi

# Section: Disable login manager
read -rp "Disable login manager?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./disable_login_manager.sh
fi

# Section: Get personal dotfiles
read -rp "Get personal dotfiles backups from Github?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./get_personal_backup_files.sh
fi

# Section: Configure pacman settings
read -rp "Configure pacman settings?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./configure_pacman_settings.sh
fi

# Section: Install common packages
read -rp "Install common packages?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_common_packages.sh
fi

# Section: Install package 'paru'
read -rp "Install package 'paru'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_paru.sh
fi

# Section: Install packages 'suckless'
read -rp "Install packages 'suckless'?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_suckless_tools.sh
fi

# Section: Install packages 'tools'
read -rp "Install packages 'tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_tools.sh
fi

# Section: Install packages 'testing tools'
read -rp "Install packages 'testing tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_testing_tools.sh
fi

# Section: Install packages 'testing browsers'
read -rp "Install packages 'testing browsers'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_testing_browsers.sh
fi

# Section: Install packages 'other browsers'
read -rp "Install packages 'other browsers'?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_other_browsers.sh
fi

# Section: Install packages 'android tools'
read -rp "Install packages 'android tools'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_android_tools.sh
fi

# Section: Install packages 'appium'
read -rp "Install packages 'appium'?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./install_appium.sh
fi

# Section: Clean temporary AUR files
read -rp "Clean temporary AUR files?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./clean_temporary_aur_files.sh
fi

# Section: Create user aliases in bash_aliases file
read -rp "Create user aliases in bash_aliases file?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./create_user_aliases.sh
fi

# Section: Generate ssh keys
read -rp "Generate ssh keys?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./generate_ssh_keys.sh
fi

# Section: Add ssh key to Github account
read -rp "Add ssh key to Github account?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./add_ssh_key_to_github.sh
fi

# Section: Apply fix for misbehaving java applications
read -rp "Apply fix for misbehaving java applications?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./apply_java_applications_fix.sh
fi

# Section: Set keyboard layout
read -rp "Set keyboard layout?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./set_keyboard_layout.sh
fi

# Section: Configure Git
read -rp "Configure Git?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./configure_git.sh
fi

# Section: Clone personal repos
read -rp "Clone personal repos?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./clone_personal_repos.sh
fi

# Section: Set java default version
read -rp "Set java default version?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./set_java_default_version.sh
fi

# Section: Start and configure services
read -rp "Start and configure services?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./start_services.sh
fi

# Section: Enable Bash git prompt
read -rp "Enable Bash git prompt?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./enable_bash_git_prompt.sh
fi

# Section: Update clamav antivirus
read -rp "Update clamav antivirus?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./update_clamav.sh
fi

# Section: Set PATH in ~/bashrc file
read -rp "Set PATH in ~/bashrc file?: (Y|n)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./create_bin_directory.sh
fi

# Section: Nvidia optimus
read -rp "Set nvidia optimus integrated card?: (y|N)" option
while [[ " "${options[@]}" " != *" $option "* ]]; do
  echo "$option: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  read -rp "?: (y|n)" option
done
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  ./configure_nvidia_optimus.sh
fi