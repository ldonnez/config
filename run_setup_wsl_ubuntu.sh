#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

# Create .local/bin to symlink alternative paths locally
mkdir -p ~/.local/bin

# Ensure ~/.local/bin is in PATH
PATH=$PATH:~/.local/bin

# update apt
sudo apt update && sudo apt upgrade

sudo apt install git python3-setuptools python3-pip python3-venv python3-packaging

# Install pipx
pip3 install pipx

# Install ansible & ansible-lint
pipx install ansible --include-deps
pipx install ansible-lint

# Install requirements
ansible-galaxy install -r requirements.yml

# Run playbook
ansible-playbook setup_wsl_ubuntu.yml -K --tags install
