#!/bin/ksh

# fail if any commands fails
set -e
# debug log
#set -x

username=$USER

cloneRepo() {
  mkdir -p "$HOME"/src
  cd "$HOME"/src || return
  if [[ ! -e "$1" ]];then
    git clone https://aur.archlinux.org/"$1".git
    cd "$1" || return
  else
    cd "$1" || return
    git pull
  fi
}

# Section: Create xinitrc
print -n "Create $HOME/.xsession file in user home directory?: (y|N) ";read -r option; print ""
if [[ $option = "y" || $option = "Y" ]];then
   {
    print "export ENV=\$HOME/.kshrc"
    print "xsetroot -solid grey &"
    print "xterm -bg black -fg white +sb &"
    print "cwm"
  } >>$HOME/.xsession
  print "Create $HOME/.xinitrc file... DONE"
fi

# Section: Get personal dotfiles
print -n "Get personal dotfiles backups from Github?: (y|N) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  doas pkg_add curl
  cd || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.xinitrc"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.Xresources"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.Xdefaults"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.tmux.conf"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.vimrc"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.xbindkeysrc"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.picom.conf"
  mkdir -p "$HOME"/.prboom-plus/ && cd "$HOME"/.prboom-plus/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.prboom-plus/prboom-plus.cfg"
  cd || return
  mkdir -p "$HOME"/.config/gzdoom/ && cd "$HOME"/.config/gzdoom/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/gzdoom/gzdoom.ini"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/gzdoom/gzdoom_chex.ini"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/gzdoom/gzdoom_chex_mouseonly.ini"
  cd || return
  mkdir -p "$HOME"/.config/i3/ && cd "$HOME"/.config/i3/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/i3/config"
  cd || return
  mkdir -p "$HOME"/.config/i3status/ && cd "$HOME"/.config/i3status/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/i3status/config"
  cd || return
  mkdir -p "$HOME"/.config/mc/ && cd "$HOME"/.config/mc/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mc/hotlist"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mc/ini"
  cd || return
  mkdir -p "$HOME"/.config/mpv/ && cd "$HOME"/.config/mpv/ || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mpv/input.conf"
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.config/mpv/mpv.conf"
  cd || return
  mkdir -p "$HOME"/.config/geany/colorschemes/ && cd "$HOME"/.config/geany/colorschemes/ || return
  curl -OL "https://raw.github.com/geany/geany-themes/master/colorschemes/bespin.conf"
  cd || return
  curl -OL "https://raw.githubusercontent.com/lea2501/dotfiles/main/.cwmrc"
  cd || return
  print "Get backup dotfiles from github... DONE"
fi

# Section: Install common packages
print -n "Install common packages?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  doas pkg_add -u
  print "Update system repositories and packages... DONE"
  cd || return
  # system
  doas pkg_add vim dos2unix exfat-fuse xclip autocutsel xosd usbutils htop findutils tree
  doas pkg_add inconsolata-font hack-fonts dina-fonts liberation-fonts terminus-font

  # minimal-tools
  doas pkg_add st

  # devel
  doas pkg_add cmake jdk maven gradle jq git mariadb-server mariadb-client geany

  # multimedia
  doas pkg_add flac opus-tools vorbis-tools wavpack mpv ffmpeg ffmpeg-normalize sox shntool lsdvd

  # extra tools
  doas pkg_add moc lynx w3m newsboat rtorrent amule youtube-dl pcmanfm detox scrot mc rarcrack fcrackzip pdfcrack ddrescue fdupes
  doas pkg_add comix qpdf zathura zathura-pdf-mupdf zathura-djvu zathura-ps zathura-cb mupdf

  # forensic tools
  doas pkg_add foremost testdisk sleuthkit

  # images
  doas pkg_add feh geeqie gimp ImageMagick

  # net
  doas pkg_add curl axel tigervnc openconnect samba tor tor-browser onionshare

  # tools
  doas pkg_add ntfs_3g rsync clamav rdesktop libreoffice keepassxc cabextract unrar p7zip unzip galculator

  # emulators
  doas pkg_add qemu

  print "install packages... DONE"
fi

# Section: Install external packages 'other browsers'
print -n "Install external packages 'other browsers'?: (y|N) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  doas pkg_add chromium
  doas pkg_add firefox-esr geckodriver
  doas pkg_add surf
  doas pkg_add amfora bombadillo lagrange
  print "Install packages 'other browsers'... DONE"
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
  doas sed -i 's/xconsole/#xconsole/' /etc/X11/xenodm/Xsetup_0
  print "Disable xconsole in xenodm... DONE"
fi

# Section: Generate ssh keys
print -n "Generate ssh keys?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  print "Generating ssh keys..."
  print "In a web browser, create or access your personal Github account (Optional):"
  print "  1) In a new tab, open https://github.com in a web browser."
  print "  2) Access with your personal Github credentials or create a new one."
  print "  3) Access to https://github.com/settings/keys and leave it open"
  print ""
  echo -e "\033[33;5m Don't close Github page when finished... \033[0m"
  print ""
  read -rp "Press enter when finish to create ssh keys..."
  print -n "Generate ssh keys?: (Y|n) ";read; print ""

  cat /dev/zero | ssh-keygen -q -N ""
  print "Generate ssh key in $HOME/.ssh/id_rsa.pub file... DONE"

  xclip -sel PRIMARY <"$HOME"/.ssh/id_rsa.pub
  print "Copying content of '$HOME/.ssh/id_rsa.pub' file to the clipboard... DONE"
  print ""
  echo -e "\033[33;5m If you copy other thing to the clipboard, here is your ssh public key, ready to copy again... \033[0m"
  print ""
  cat "$HOME"/.ssh/id_rsa.pub
  print ""

  print "Add SSH keys to Github account (Optional):"
  print "  1) Access ssh-keys settings in https://github.com/settings/keys"
  print "  2) Paste the key copied from $HOME/.ssh/id_rsa.pub and press 'Add key' button."
  print ""
  print -n "Generate ssh keys?: (Y|n) ";read; print ""
  print "Generate ssh keys... DONE"
fi

# Section: Set keyboard layout
print -n "Set keyboard layout?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  cd || return
  print "setxkbmap -layout latam -variant deadtilde" >>"$HOME"/.profile
  print "Set keyboard layout... DONE"
fi

# Section: Configure Git
print -n "Configure Git?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  read -rp "Enter Git user email: " gitUserEmail
  git config --global user.email "$gitUserEmail"
  read -rp "Enter Git user name: " gitUserName
  git config --global user.name "$gitUserName"
  git config --global pull.rebase false
  print "Configure Git... DONE"
fi

# Section: Clone personal repos
print -n "Clone personal repos?: (y|N) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  mkdir -p "$HOME"/src
  print "Create $HOME/src directory... DONE"
  cd "$HOME"/src || return
  git clone git@github.com:lea2501/dotfiles.git
  git clone git@github.com:lea2501/scripts.git
  print "Clone Github repos... DONE"
fi

# Section: Update clamav antivirus
print -n "Update clamav antivirus?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  doas sed -i 's/Example/#Example/g' /etc/freshclam.conf
  doas freshclam
  print "Update clamav virus definition database... Done"
fi

# Section: Set PATH in $HOME/profile file
print -n "Set PATH in $HOME/profile file?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  cd || return
  mkdir -p "$HOME"/bin
  print "PATH=\$PATH:$HOME/bin/" >>"$HOME"/.profile
  source "$HOME"/.profile
  print "Create user 'bin' directory... DONE"
fi

# Section: Enable UTF8 support
print -n "Enable UTF8 support?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  print "export LC_CTYPE=en_US.UTF-8" >>"$HOME"/.profile
  print "export GTK_IM_MODULE=xim # without this GTK apps will use their own compose key settings" >>"$HOME"/.profile
  print "export LESSCHARSET=utf-8 # not strictly necessary, but for when you view Unicode files in less" >>"$HOME"/.profile
  print "Enable UTF8 support... DONE"
fi

# Section: Enable apmd CPU scaling daemon
print -n "Enable apmd CPU scaling daemon?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  doas rcctl enable apmd
  doas rcctl set apmd flags -A -z 10
  doas rcctl start apmd
  print "Enable apmd CPU scaling daemon... DONE"
fi

# Section: Improve disk performance
print -n "Improve disk performance (using 'noatime' in fstab mounts)?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  doas cp /etc/fstab /etc/fstab.bak
  doas sed -i 's/rw/rw,noatime/' /etc/fstab
  print "Improve disk performance... DONE"
fi

# Section: Update system
print -n "Update system with syspatch?: (Y|n) ";read -r option; print ""
if [[ "$option" == "y" || "$option" == "Y" ]]; then
  print "Installed patches:"
  doas syspatch -l
  print "available packages:"
  doas syspatch -c
  print "Installing available patches:"
  doas syspatch
  print "Update system with syspatch... DONE"
fi
