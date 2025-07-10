#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

# Create .local/bin to symlink alternative paths locally
mkdir -p ~/.local/bin

# Ensure ~/.local/bin is in PATH
PATH=$PATH:~/.local/bin

# update apt
sudo apt update && sudo apt upgrade

sudo apt install git python3-setuptools python3-pip pipx python3-apt ansible

# install ansible-lint
pipx install ansible-lint

# Install requirements
ansible-galaxy install -r requirements.yml

# Run playbook
ansible-playbook setup_debian.yml -K --tags install
