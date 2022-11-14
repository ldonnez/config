#!/usr/bin/env bash

cd "$(dirname "$0")"

# install homebrew
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# update brew
brew update && brew upgrade

# install ansible
brew install ansible ansible-lint

# run playbook
ansible-playbook setup_macos.yml -K

# brew cleanup
brew cleanup
