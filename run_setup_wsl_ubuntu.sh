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

# enable systemd
sudo cp -u ./roles/wsl/files/wsl.conf /etc

printf "\n\n\nEverything prepared!\nClose your session and run \`wsl.exe --shutdown\` and restart WSL\nAfterwards run \`ansible-playbook setup_wsl_ubuntu.yml -K\` in this directory "

sleep 4
# ansible-playbook setup_wsl_ubuntu.yml -K
