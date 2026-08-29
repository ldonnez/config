SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

# Harmless if these don't exist; needed for pipx (~/.local/bin) and fresh Apple Silicon brew
export PATH := $(HOME)/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$(PATH)

.PHONY: collections setup-macos setup-debian setup-wsl-ubuntu update-macos update-debian update-wsl-ubuntu backup lint

collections:
	ansible-galaxy collection install -r requirements.yml --upgrade

setup-macos:
	@if ! command -v brew > /dev/null 2>&1; then \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	brew update && brew upgrade
	brew install ansible ansible-lint
	ansible-galaxy collection install -r requirements.yml --upgrade
	ansible-playbook setup_macos.yml -K --ask-vault-pass --tags install
	brew cleanup

setup-debian:
	sudo apt update && sudo apt upgrade -y
	sudo apt install -y git python3-setuptools python3-pip python3-apt pipx make
	@mkdir -p ~/.local/bin
	# community.general.pipx needs pipx >= 1.7.0; apt ships older, so bootstrap current pipx via pipx
	pipx install pipx
	sudo apt purge -y --autoremove pipx
	pipx install ansible --include-deps
	pipx install ansible-lint
	ansible-galaxy collection install -r requirements.yml --upgrade
	ansible-playbook setup_debian.yml -K --ask-vault-pass --tags install

setup-wsl-ubuntu:
	sudo apt update && sudo apt upgrade -y
	@mkdir -p ~/.local/bin
	sudo apt install -y git python3-setuptools python3-pip python3-apt pipx make
	pipx install pipx
	sudo apt purge -y --autoremove pipx
	pipx install ansible --include-deps
	pipx install ansible-lint
	ansible-galaxy collection install -r requirements.yml --upgrade
	ansible-playbook setup_wsl_ubuntu.yml -K --tags install

update-macos: collections
	ansible-playbook setup_macos.yml --tags update

update-debian: collections
	ansible-playbook setup_debian.yml -K --tags update

update-wsl-ubuntu: collections
	ansible-playbook setup_wsl_ubuntu.yml -K --tags update

backup: collections
	ansible-playbook backup.yml

lint:
	ansible-lint
