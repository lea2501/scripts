#!/bin/ksh

doas pkg_add neovim bash

chsh -s $(whereis bash) $(whoami)
LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.2/neovim-0.8/utils/installer/install.sh)

{
    print ''
    print '# add $HOME/.local/bin to PATH'
    print 'export PATH=$HOME/.local/bin:$PATH'
} >>$HOME/.profile

cp ~/.local/share/lunarvim/lvim/utils/installer/config.example.lua ~/.config/lvim/config.lua
cd ~/.config/lvim/ && lvim --headless +'lua require("lvim.utils").generate_settings()' +qa && sort -o lv-settings.lua{,} && cd -
