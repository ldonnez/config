#!/usr/bin/env bash

cd "$(dirname "$0")"

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Make brew command available in shell
if [[ $(uname -m) == 'arm64' ]] && [[ $(uname) = "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# update brew
brew update && brew upgrade

# install ansible
brew install ansible ansible-lint

# install requirements
ansible-galaxy install -r requirements.yml

# run playbook
ansible-playbook setup_macos.yml -K --tags install

# brew cleanup
brew cleanup
