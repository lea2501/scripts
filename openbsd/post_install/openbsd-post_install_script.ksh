#!/bin/ksh

# fail if any commands fails
set -e
# debug log
#set -x

# Section: Create session files
print -n "Create $HOME session files?: (y|N) ";read -r option; print ""
if [[ $option = "y" || $option = "Y" ]];then
    ./create_user_session_files.ksh
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
print -n "Update system with syspatch? (-release only): (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
    ./update_base_system.ksh
fi
