#!/usr/bin/env bash

cd "$(dirname "$0")"

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# update brew
brew update && brew upgrade

# install ansible
brew install ansible ansible-lint

# install requirements
ansible-galaxy install -r requirements.yml

# run playbook
ansible-playbook setup_macos.yml -K

# brew cleanup
brew cleanup
