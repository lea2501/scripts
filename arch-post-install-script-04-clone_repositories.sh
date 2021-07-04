#!/bin/bash

################################
### DO NOT EDIT THIS FILE DIRECTLY, INSTEAD, COPY TO YOUR LOCAL ~/script directory and edit there
### $ mkdir ~/script
### $ cp scripts/<THIS_FILENAME> ~/script/
### $ cd ~/script/
### EDIT FILE
### $ ./<THIS_FILENAME>
################################

# fail if any commands fails
set -e
# debug log
#set -x

############ Script

options=(y n)
read -rp "Create user aliases?: (Y|n)" createUserAliases
if [[ " "${options[@]}" " != *" $createUserAliases "* ]]; then
  echo "$createUserAliases: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Configure VPN access?: (Y|n)" configureVpnAccess
if [[ " "${options[@]}" " != *" $configureVpnAccess "* ]]; then
  echo "$configureVpnAccess: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Install Idaptive mobile application?: (Y|n)" installIdaptiveMobileApplication
if [[ " "${options[@]}" " != *" $installIdaptiveMobileApplication "* ]]; then
  echo "$installIdaptiveMobileApplication: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Connect to Cisco AnyConnect VPN?: (Y|n)" connectToAnyconnectVpn
if [[ " "${options[@]}" " != *" $connectToAnyconnectVpn "* ]]; then
  echo "$connectToAnyconnectVpn: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
sshKeyGenOptions=(auto manual n)
read -rp "Create a new SSH key? : (AUTO|manual|n)" generateSshKey
if [[ " "${sshKeyGenOptions[@]}" " != *" $generateSshKey "* ]]; then
  echo "$generateSshKey: not recognized. Valid options are:"
  echo "${sshKeyGenOptions[@]/%/,}"
  exit 1
fi
read -rp "Clone automation repositories? : (Y|n)" cloneReposAutomation
if [[ " "${options[@]}" " != *" $cloneReposAutomation "* ]]; then
  echo "$cloneReposAutomation: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Clone Flow Factory repositories? : (Y|n)" cloneReposFlowFactory
if [[ " "${options[@]}" " != *" $cloneReposFlowFactory "* ]]; then
  echo "$cloneReposFlowFactory: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Clone github repositories? : (y|N)" cloneReposGithub
if [[ " "${options[@]}" " != *" $cloneReposGithub "* ]]; then
  echo "$cloneReposGithub: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi
read -rp "Configure remote server access? : (Y|n)" configureRemoteServerAccess
if [[ " "${options[@]}" " != *" $configureRemoteServerAccess "* ]]; then
  echo "$configureRemoteServerAccess: not recognized. Valid options are:"
  echo "${options[@]/%/,}"
  exit 1
fi

# add aliases
if [ "$createUserAliases" = "y" ]; then
  echo "Creating user aliases in ~/.bash_aliases file..."
  cd || return

  {
    echo "alias aur_update='for dir in ~/aur/*; do (cd \"\$dir\" && pwd && git pull); done'"
    echo "alias syncthing='syncthing -no-browser'"
    echo "alias getBatt='upower -i /org/freedesktop/UPower/devices/battery_BAT0'"
    echo "alias getBattBrief='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E \"state|time\ to\ |percentage\"'"
    echo "alias getBattPercent=\"upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep 'percentage' | awk '{print \$2}'\"":
    echo "alias getVulnerabilities='grep -RHe \"^\" /sys/devices/system/cpu/vulnerabilities'"
    echo "alias getAudioMaster=\"amixer sget Master | grep 'Right:' | awk -F'[][]' '{print \$2}'\""
  } >>~/.bash_aliases

  #echo "${juniperPassword}" > ~/.ocvpn_secret
  #echo "  note: you need to change aliases with your data in ~/.bash_aliases file)"
  #echo "alias openconnect_juniper='cat ~/.ocvpn_secret | sudo /usr/bin/openconnect --juniper boromir.fibertel.com.ar --servercert sha256:${juniperServercert} --user=${juniperUsername} --passwd-on-stdin'" >>~/.bash_aliases
  read -rp "Enter Cisco AnyConnect VPN username (uXXXXXX): " openconnectUsername
  echo "alias openconnect_anyconnect='sudo /usr/bin/openconnect -u ${openconnectUsername} vpn-ssl.telecom.com.ar'" >>~/.bash_aliases

  {
    echo "if [ -f ~/.bash_aliases ]; then"
    echo "  . ~/.bash_aliases"
    echo "fi"
  } >>~/.bashrc

  source ~/.bashrc
  echo "Creating user aliases in ~/.bash_aliases file... DONE"
fi

# Clone company repositories
if [ "$configureVpnAccess" = "y" ]; then
  echo "installing packages..."
  sudo pacman -Sy --noconfirm --needed openconnect
  sudo pacman -Sy --noconfirm --needed networkmanager-openconnect
  echo "installing packages... DONE"
fi

if [ "$installIdaptiveMobileApplication" = "y" ]; then
  echo "Connect to anyConnect VPN"
  echo "  In a smartphone, search and install 'Idaptive' application from Play Store"
  echo "    https://play.google.com/store/apps/details?id=com.centrify.mdm.samsung"
  echo "  If using a smartphone without google play or google services do:"
  echo "    1) Download and install 'F-Droid' from https://f-droid.org/F-Droid.apk"
  echo "    2) Install 'Aurora Store' from F-Droid"
  echo "    3) Install 'Idaptive' from Aurora Store"
  echo ""
  read -rp "Press enter to continue"
  echo "Idaptive mobile application steps:"
  echo "  1) Open 'Idaptive' mobile application"
  echo "  2) Login using \"uXXXXXX@telecom\" (don't put 'uXXXXXX@teco.com.ar') and \"LAN password\"."
  echo "  3) Don't wait for apps to load (It won't). Go to menu and select \"Mobile Authenticator\"."
  echo "  4) Use temporary token to connect to VPN."
  read -rp "Press enter to continue"
fi

if [ "$connectToAnyconnectVpn" = "y" ]; then
  echo "Connecting to Cisco AnyConnect VPN..."
  echo "Open a new terminal and do the following..."
  echo "    $ openconnect_anyconnect"
  echo "    or..."
  echo "    $ sudo /usr/bin/openconnect -u ${openconnectUsername} vpn-ssl.telecom.com.ar"
  echo "  When asking for password enter your 'LAN password'"
  echo "  When asking for password again, enter the Idaptive temporary token password"
  echo ""
  echo -e "\033[33;5m PLEASE NOTE THAT BOTH PASSWORD PROMPTS LOOK THE SAME! \033[0m"
  echo ""
  read -rp "Press enter to continue"
  echo "Connecting to Cisco AnyConnect VPN... DONE"
fi

if [ "$generateSshKey" = "auto" ] || [ "$generateSshKey" = "manual" ]; then
  echo "Create or access Gitlab account:"
  echo "  1) Open http://10.200.172.71 in a web browser."
  echo "  2) Access with your Gitlab credentials or create a new one."
  echo "  3) Ask another member of the automation team to give you access to the Gitlab automation group."
  echo "  4) Access to http://10.200.172.71/profile/keys and leave it open"
  echo ""
  echo -e "\033[33;5m Don't close Gitlab page when finished... \033[0m"
  echo ""
  echo "Also, IN A NEW TAB create or access Bitbucket account:"
  echo "  1) In a new tab, open https://bitbucket.org/tecoflowfactory/ in a web browser."
  echo "  2) Access with your Bitbucket (Jira) credentials or create a new one."
  echo "  3) Access to https://bitbucket.org/account/settings/ssh-keys/ and leave it open"
  echo ""
  echo -e "\033[33;5m Don't close Bitbucket page when finished... \033[0m"
  echo ""
  echo "Also, IN A NEW TAB create or access your personal Github account (Optional):"
  echo "  1) In a new tab, open https://github.com in a web browser."
  echo "  2) Access with your personal Github credentials or create a new one."
  echo "  3) Access to https://github.com/settings/keys and leave it open"
  echo ""
  echo -e "\033[33;5m Don't close Github page when finished... \033[0m"
  echo ""
  read -rp "Press enter when finish to create ssh keys..."
fi

if [ "$generateSshKey" = "manual" ]; then
  echo "Open a new terminal and do the following..."
  echo "You should generate ssh keys with command:"
  echo "  $ ssh-keygen"
  echo "  note: when asked for a file location and for a passphrase,"
  echo "        just press enter key for defaults and blank passphrase."
  echo ""
  echo "Now, copy the contents of the file ~/.ssh/id_rsa.pub to the clipboard,"
  echo "with the command:"
  echo "  $ xclip -sel c < ~/.ssh/id_rsa.pub"
  echo ""
  read -rp "Press enter when finish to continue..."
fi

if [ "$generateSshKey" = "auto" ]; then
  echo "Generating ssh key in ~/.ssh/id_rsa.pub file..."
  cat /dev/zero | ssh-keygen -q -N ""
  echo "Generating ssh key in ~/.ssh/id_rsa.pub file... DONE"

  echo "Copying content of '~/.ssh/id_rsa.pub' file to the clipboard..."
  xclip -sel c <~/.ssh/id_rsa.pub
  echo "Copying content of '~/.ssh/id_rsa.pub' file to the clipboard... DONE"
  echo ""
  echo -e "\033[33;5m If you copy other thing to the clipboard, here is your ssh public key, ready to copy again... \033[0m"
  echo ""
  cat ~/.ssh/id_rsa.pub
  echo ""
fi

if [ "$generateSshKey" = "auto" ] || [ "$generateSshKey" = "manual" ]; then
  echo "Add SSH keys to Gitlab account:"
  echo "  1) Access ssh-keys settings in http://10.200.172.71/profile/keys"
  echo "  2) Paste the key copied from ~/.ssh/id_rsa.pub and press 'Add key' button."
  echo ""
  read -rp "Press enter when finish to continue..."
  echo ""
  echo "Add SSH keys to Bitbucket account:"
  echo "  1) Access ssh-keys settings in https://bitbucket.org/account/settings/ssh-keys/"
  echo "  2) Paste the key copied from ~/.ssh/id_rsa.pub and press 'Add key' button."
  echo ""
  read -rp "Press enter when finish to continue..."
fi

if [ "$cloneReposAutomation" = "y" ]; then
  echo "Creating ~/repos directory..."
  mkdir -p ~/repos
  echo "Creating ~/repos directory... DONE"
  echo "Cloning automation repos..."
  cd ~/repos || return
  git clone -b develop git@10.200.172.71:Automation/automation-wiki.git
  git clone -b develop git@10.200.172.71:Automation/automation-tools.git
  git clone -b develop git@10.200.172.71:Automation/automation-minerva.git
  git clone -b develop git@10.200.172.71:Automation/automation-gateway.git
  git clone -b develop git@10.200.172.71:Automation/automation-webclient.git
  git clone -b develop git@10.200.172.71:Automation/automation-webclient-analytics.git
  git clone -b develop git@10.200.172.71:Automation/automation-smarttv-ff.git
  git clone -b develop git@10.200.172.71:Automation/automation-android.git
  git clone -b develop git@10.200.172.71:Automation/automation-android-tv.git
  git clone -b develop git@10.200.172.71:Automation/automation-ios.git
  git clone -b develop git@10.200.172.71:Automation/automation-jmeter.git
  git clone -b develop git@10.200.172.71:Automation/automation-wrk.git
  git clone -b develop git@10.200.172.71:Automation/automation-api-iot.git
  git clone -b develop git@10.200.172.71:Automation/automation-web-iot.git
  git clone -b develop git@10.200.172.71:Automation/automation-android-iot.git
  git clone -b develop git@10.200.172.71:Automation/automation-ios-iot.git
  echo "Cloning automation repos... DONE"
fi

if [ "$cloneReposFlowFactory" = "y" ]; then
  echo "Creating ~/repos directory..."
  mkdir -p ~/repos
  echo "Creating ~/repos directory... DONE"
  echo "Cloning Flow Factory repos..."
  cd ~/repos || return
  git clone -b develop git@bitbucket.org:tecoflowfactory/flow-android.git
  git clone -b develop git@bitbucket.org:tecoflowfactory/flow-android-tv.git
  git clone -b releases git@bitbucket.org:tecoflowfactory/flow-android-core-library.git
  git clone -b develop git@bitbucket.org:tecoflowfactory/flow-smart-tv.git
  git clone -b develop git@bitbucket.org:tecoflowfactory/webclient.git
  git clone -b develop git@bitbucket.org:tecoflowfactory/ios.git
  git clone -b develop git@bitbucket.org:tecoflowfactory/flow-iot.git
  git clone -b develop git@bitbucket.org:tecoflowfactory/iot-web.git
  echo "Cloning Flow Factory repos... DONE"
fi

if [ "$cloneReposGithub" = "y" ]; then
  echo "Creating ~/src directory..."
  mkdir -p ~/src
  echo "Creating ~/src directory... DONE"
  echo "Cloning Github repos..."
  cd ~/src || return
  git clone git@github.com:lea2501/dotfiles.git
  git clone git@github.com:lea2501/scripts.git
  echo "Cloning Github repos... DONE"
fi

confRemoteServerAccess() {
  server=$1
  echo "Configure access to ${server} server..."
  read -rp "Enter your username for server ${server}: " serverUsername
  echo -e "\033[33;5m If connected then type 'exit' and press enter to continue \033[0m"
  ssh -t ${serverUsername}@${server}
  echo ""
  echo "Connected successfully to server ${server} as user ${serverUsername}"
  echo ""
  echo "Configure access to ${server} server... DONE"
}

copySshKeysToRemoteServer() {
  server=$1
  echo "Copy Ssh keys to ${server} server..."
  read -rp "Enter your username for server ${server}: " serverUsername
  ssh-copy-id -i ~/.ssh/id_rsa.pub ${serverUsername}@${server}
  echo ""
  echo "Copy Ssh keys to ${server} server... DONE"
}

accessRemoteServer() {
  server=$1
  echo "Access ${server} server..."
  read -rp "Enter your username for server ${server}: " serverUsername
  echo -e "\033[33;5m If connected then type 'exit' and press enter to continue \033[0m"
  ssh -i ~/.ssh/id_rsa ${serverUsername}@${server}
  echo ""
  echo "Connected successfully to server ${server} as user ${serverUsername}"
  echo ""
  echo "Access ${server} server... DONE"
}

if [ "$configureRemoteServerAccess" = "y" ]; then
  echo "Configure remote server access..."
  confRemoteServerAccess 10.200.172.73
  confRemoteServerAccess 10.200.172.74
  confRemoteServerAccess 10.200.172.75

  copySshKeysToRemoteServer 10.200.172.73
  copySshKeysToRemoteServer 10.200.172.74
  copySshKeysToRemoteServer 10.200.172.75

  accessRemoteServer 10.200.172.73
  accessRemoteServer 10.200.172.74
  accessRemoteServer 10.200.172.75
  echo "Configure remote server access... DONE"
fi