#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# tools
paru -S bash-git-prompt

{
  echo ""
  echo "# bash git prompt"
  echo "if [ -f /usr/lib/bash-git-prompt/gitprompt.sh ]; then"
  echo "    # To only show the git prompt in or under a repository directory"
  echo "     GIT_PROMPT_ONLY_IN_REPO=1"
  echo "    # To use upstream's default theme"
  echo "     GIT_PROMPT_THEME=Default"
  echo "    # To use upstream's default theme, modified by arch maintainer"
  echo "    # GIT_PROMPT_THEME=Default_Arch"
  echo "    source /usr/lib/bash-git-prompt/gitprompt.sh"
  echo "fi"
}>>~/.bashrc
source ~/.bashrc
