#!/bin/ksh

# fail if any commands fails
set -e
# debug log
#set -x

cd || return

{
    print 'export ENV=$HOME/.kshrc'
} >>$HOME/.profile

{
    print "# use vim if it's installed, vi otherwise"
    print "case "$(command -v vim)" in"
    print "  */vim) VIM=vim ;;"
    print "  *)     VIM=vi  ;;"
    print "esac"
    print ""
    print "# aliases"
    print "alias syncthing='syncthing -no-browser'"
    print "alias ll='ls -lahF'"
    print "alias newsboat_news='newsboat -r -u ~/.newsboat/urls_news -c ~/.newsboat/cache_news.db -C ~/.newsboat/config_news'"
    print "alias newsboat_video='newsboat -r -u ~/.newsboat/urls_videos -c ~/.newsboat/cache_videos.db -C ~/.newsboat/config_videos'"
    print "alias newsboat_downloads='newsboat -r -u ~/.newsboat/urls_downloads -c ~/.newsboat/cache_downloads.db -C ~/.newsboat/config_downloads'"
    print "alias ll='ls -lahF'"
    print "alias jdownloader='/usr/local/jdk-11/bin/java -jar $HOME/bin/jdownloader/JDownloader.jar'"
    print ""
    print "# env"
    print "export EDITOR=vim"
    print "export FCEDIT=$EDITOR"
    print "export PAGER=less"
    print "export LESS='-iMRS -x2'"
    print "export LANG=en_US.UTF-8"
    print "export LC_CTYPE=en_US.UTF-8"
    print "export CLICOLOR=1"
    print "HISTFILE=$HOME/.ksh_history"
    print "HISTSIZE=20000"
    print ""
    print "# emacs mode gives you the familiar Ctrl-A, Ctrl-E, etc"
    print "set -o emacs"
    print ""
    print "# prompt"
    print "export PS1='$USER:$PWD $ '"
    print "#export PS1='$USER:$PWD \! $ '"
    print "#export PS1='$USER (${PWD##*/}) $ '"
} >>$HOME/.kshrc

{
    print '# use UTF-8 everywhere'
    print 'export LANG=en_US.UTF-8'
    print ''
    print '# specify location of kshrc'
    print 'export ENV=$HOME/.kshrc'
    print ''
    print '# load Xresources file'
    print 'xrdb -merge $HOME/.Xresources'
    print ''
    print '# disable system beep'
    print 'xset b off'
    print ''
    print '# synchronize copy buffers'
    print 'autocutsel &'
    print ''
    print '# reduce sound to not destroy my ears'
    print 'sndioctl -f snd/1 output.level=0.3'
    print ''
    print '# compositor for faster windows drawing'
    print 'picom &'
    print ''
    print '#xsetroot -solid grey &'
    print '#xterm -bg black -fg white +sb &'
    print './src/scripts/setWallpaperRandomPicture.ksh'
    print ''
    print '# Set PATH'
    print "PATH=\$HOME/bin/:\$HOME/src/scripts/:\$PATH"
    print ''
    print "cwm"
} >>$HOME/.xsession

{
    print '" display current mode (insert/normal)'
    print 'set showmode'
    print '" show matching parens, braces, etc'
    print 'set showmatch'
    print '" display row/column info'
    print 'set ruler'
    print '" autoindent width = 2 spaces'
    print 'set shiftwidth=2'
    print '" tab width = 2 spaces'
    print 'set tabstop=2'
    print '" display all error messages'
    print 'set verbose'
    print '" enable horizontal scrolling'
    print 'set leftright'
    print '" use extended regular expressions'
    print 'set extended'
    print '" case-insensitive search, unless an uppercase letter is used'
    print 'set iclower'
    print '" incremental search'
    print 'set searchincr'
    print '" print helpful messages (eg, 4 lines yanked)'
    print 'set report=1'
} >>$HOME/.exrc

