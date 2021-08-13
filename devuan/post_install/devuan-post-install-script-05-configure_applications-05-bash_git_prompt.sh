#!/bin/bash

# fail if any commands fails
set -e
# debug log
#set -x

# enable bash-git-prompt
echo "Enabling Bash git prompt..."

{
  echo "if [ -f ~/src/bash-git-prompt/gitprompt.sh ]; then"
  echo "    # To only show the git prompt in or under a repository directory"
  echo "     GIT_PROMPT_ONLY_IN_REPO=1"
  echo "    # To use upstream's default theme"
  echo "     GIT_PROMPT_THEME=Default"
  echo "    source ~/src/bash-git-prompt/gitprompt.sh"
  echo "fi"
}>>~/.bashrc
source ~/.bashrc

echo "Enabling Bash git prompt... DONE"
