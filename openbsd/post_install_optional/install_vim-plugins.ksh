#!/bin/ksh

doas pkg_add vim git

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo ""
echo "Resources: "
echo "    https://github.com/junegunn/vim-plug"
echo "    https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation"
echo ""
echo "    Reload .vimrc and :PlugInstall to install plugins."