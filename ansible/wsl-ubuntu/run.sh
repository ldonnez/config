#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

# Create .local/bin to symlink alternative paths locally
mkdir -p ~/.local/bin

# update apt
sudo apt update && sudo apt upgrade

sudo apt install git python python-setuptools python3-setuptools python3-pip

# install ansible
sudo apt install ansible

# upgrade pip
pip3 install --user --upgrade pip

# run playbook
ansible-playbook setup_wsl_ubuntu.yml --ask-become-pass
