#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

# Create .local/bin to symlink alternative paths locally
mkdir -p ~/.local/bin

# update apt
sudo apt update && sudo apt upgrade

sudo apt install git python3-setuptools python3-pip

# upgrade pip
pip3 install --user --upgrade pip

# install ansible
pip3 install ansible ansible-lint

# Install requirements
ansible-galaxy install -r requirements.yml

# Run playbook
ansible-playbook setup_wsl_ubuntu.yml -K --tags install
