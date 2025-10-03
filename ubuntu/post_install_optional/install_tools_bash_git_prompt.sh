#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# bash-git-prompt
application=bash-git-prompt
repository=https://github.com/magicmonty/bash-git-prompt.git
mkdir -p ~/src
cd ~/src || return
if [ ! -d $application ]; then
  git clone $repository
  cd $application || return
else
  cd $application || return
  git pull
fi

{
  echo ""
  echo "# bash git prompt"
  echo "if [ -f ~/src/bash-git-prompt/gitprompt.sh ]; then"
  echo "    # To only show the git prompt in or under a repository directory"
  echo "     GIT_PROMPT_ONLY_IN_REPO=1"
  echo "    # To use upstream's default theme"
  echo "     GIT_PROMPT_THEME=Default"
  echo "    source ~/src/bash-git-prompt/gitprompt.sh"
  echo "fi"
}>>~/.bashrc
source ~/.bashrc