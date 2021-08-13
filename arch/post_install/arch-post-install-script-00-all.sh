#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

echo "Running post install scripts..."
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-01-set_basic_config-01-remove_sudo_password.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-01-set_basic_config-02-set_pacman_config.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-02-install_pacman_packages.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-03-install_aur_packages-01-tools.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-03-install_aur_packages-02-testing_browsers.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-03-install_aur_packages-03-testing_tools.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-03-install_aur_packages-04-android_tools.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-03-install_aur_packages-05-appium.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-03-install_aur_packages-06-clean_temporary_files.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-04-clone_repositories-01-create_user_aliases.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-04-clone_repositories-02-install_openconnect.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-04-clone_repositories-03-install_android_idaptive_application.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-04-clone_repositories-04-connect_to_anyconnect_vpn.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-04-clone_repositories-05-generate_ssh_keys.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-04-clone_repositories-06-clone_automation_repos.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-04-clone_repositories-07-clone_flow_repos.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-04-clone_repositories-08-configure_servers_access.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-05-configure_applications-01-set_keyboard_layout.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-05-configure_applications-02-configure_git.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-05-configure_applications-03-set_java_default.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-05-configure_applications-04-start_services.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-05-configure_applications-05-bash_git_prompt.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-05-configure_applications-06-clamav.sh
~/repos/automation-tools/scripts/arch/post_install/arch-post-install-script-05-configure_applications-07-set_path.sh
echo "Running post install scripts... DONE"
