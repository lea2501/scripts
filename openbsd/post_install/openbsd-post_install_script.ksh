#!/bin/ksh

# fail if any commands fails
set -e
# debug log
#set -x

# Section: Create xinitrc
print -n "Create $HOME/.xsession file in user home directory?: (y|N) ";read -r option; print ""
if [[ $option = "y" || $option = "Y" ]];then
    ./create_xsession_file.ksh
fi

# Section: Get personal dotfiles
print -n "Get personal dotfiles backups from Github?: (y|N) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./get_personal_backup_files.ksh
fi

# Section: Install common packages
print -n "Install common packages?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./install_common_packages.ksh
fi

# Section: Install external packages 'other browsers'
print -n "Install external packages 'other browsers'?: (y|N) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./install_other_browsers.ksh
fi

# Section: Install external packages 'development'
print -n "Install external packages 'development'?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  doas pkg_add intellij
  print "Install packages 'development'... DONE"
fi

# Section: Disable xconsole in xenodm
print -n "Disable xconsole in xenodm?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./disable_xconsole_in_xenodm.ksh
fi

# Section: Generate ssh keys
print -n "Generate ssh keys?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./generate_ssh_key.ksh
fi

# Section: Set keyboard layout
print -n "Set keyboard layout?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./set_keyboard_layout.ksh
fi

# Section: Configure Git
print -n "Configure Git?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./configure_git.ksh
fi

# Section: Clone personal repos
print -n "Clone personal repos?: (y|N) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./clone_personal_repos.ksh
fi

# Section: Update clamav antivirus
print -n "Update clamav antivirus?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./update_clamav.ksh
fi

# Section: Set PATH in $HOME/profile file
print -n "Set PATH in $HOME/profile file?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./set_path_in_profile_file.ksh
fi

# Section: Enable UTF8 support
print -n "Enable UTF8 support?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./enable_utf8_support.ksh
fi

# Section: Enable apmd CPU scaling daemon
print -n "Enable apmd CPU scaling daemon?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./enable_apmd_cpu_scaling_daemon.ksh
fi

# Section: Improve disk performance
print -n "Improve disk performance (using 'noatime' in fstab mounts)?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./set_noatime_in_fstab.ksh
fi

# Section: Update system
print -n "Update system with syspatch?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./update_system.ksh
fi
