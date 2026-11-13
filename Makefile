SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

# Harmless if these don't exist; needed for pipx (~/.local/bin) and fresh Apple Silicon brew
export PATH := $(HOME)/.local/bin:/opt/homebrew/bin:/opt/homebrew/sbin:$(PATH)

# The docker CLI resolves contexts (e.g. Docker Desktop) itself, but the python docker SDK
# used by molecule only honors DOCKER_HOST, so default it to the active context's endpoint.
DOCKER_HOST ?= $(shell docker context inspect --format '{{.Endpoints.docker.Host}}' 2>/dev/null || echo unix:///var/run/docker.sock)
export DOCKER_HOST

.PHONY: collections molecule setup-macos setup-debian setup-wsl-ubuntu update-macos update-debian update-wsl-ubuntu backup lint test backup-secrets backup-secrets-local restore-secrets restore-secrets-local test molecule-images

collections:
	ansible-galaxy collection install -r requirements.yml --upgrade

molecule:
	-pipx uninstall ansible
	pipx install ansible-core
	pipx inject ansible-core requests docker
	pipx install ansible-lint
	pipx install molecule
	pipx inject molecule "molecule-plugins[docker]"
	-pipx runpip molecule uninstall --yes ansible

setup-macos:
	@if ! command -v brew > /dev/null 2>&1; then \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi
	brew install ansible ansible-lint
	ansible-galaxy collection install -r requirements.yml --upgrade
	ansible-playbook setup_macos.yml -K --ask-vault-pass --tags install
	brew cleanup

setup-debian:
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

backup-secrets: collections
	ansible-playbook backup_secrets.yml -K --ask-vault-pass

backup-secrets-local: collections
	ansible-playbook backup_secrets.yml -K --ask-vault-pass -e git_sync=false

restore-secrets: collections
	ansible-playbook restore_secrets.yml -K --ask-vault-pass

restore-secrets-local: collections
	ansible-playbook restore_secrets.yml -K --ask-vault-pass -e git_sync=false

lint:
	ansible-lint

molecule-images:
	docker build --build-arg BASE_IMAGE=debian:13 -t molecule:debian13 -f molecule/Dockerfile .
	docker build --build-arg BASE_IMAGE=ubuntu:24.04 -t molecule:ubuntu2404 -f molecule/Dockerfile .
	docker build --build-arg BASE_IMAGE=ubuntu:26.04 -t molecule:ubuntu2604 -f molecule/Dockerfile .

test: collections molecule-images
	molecule test $(if $(ROLE),-s $(ROLE),--all --exclude default)
