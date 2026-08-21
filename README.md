# Provisioning (MacOS, Debian, WSL)

## Disclaimer

This is mostly for my own usage.

## Prerequisites

Ansible playbooks **setup_macos.yml** and **setup_debian.yml** includes the **secrets** role which installs vault encrypted (`ansible-vault encrypt <filename>`) files from a repository cloned to `~/.secrets`. The `make setup-macos` and `make setup-debian` targets prompt for both the vault and become passwords automatically (`--ask-vault-pass -K`).

## Setup macOS

- When running from fresh install run `xcode-select --install` to install minimal tools like git etc
- Clone this repo, preferably in your home directory
- Run `make setup-macos`. This will install homebrew, ansible & ansible-lint, upgrade the Galaxy collections from requirements.yml and run the setup_macos.yml playbook

### Update macOS packages

Run

```zsh
make update-macos
```

This upgrades the Galaxy collections from requirements.yml and runs the playbook's update tasks.

## Setup WSL2 (Ubuntu >= 24.04)

Make sure to check vars in `setup_wsl_ubuntu.yml`.

- First, install WSL from an Administrator PowerShell:
  ```powershell
  wsl --install
  ```
- Then install the desired Ubuntu distro (replace version as needed):

  ```powershell
  wsl --install -d Ubuntu-24.04
  ```

  Supported versions: `Ubuntu-24.04`, `Ubuntu-26.04`

  You can list available versions with:

  ```powershell
   wsl --list --online
  ```

- Launch the installed distro from the Start menu or with Windows Terminal, create your Linux user, and let it finish initial setup
- To ensure network compatibility (especially for services that require bridged/mirrored networking like corporate VPN's), create or edit the `.wslconfig` file in your Windows user home directory (C:\Users\\\<YourUsername>\\\.wslconfig) and add the following:

  ```shell
  [wsl2]
  networkingMode=mirrored
  ```

- Clone this repo, preferably in your home directory
- Run `make setup-wsl-ubuntu`. This will install python and pipx, plus the latest ansible & ansible-lint via pipx.
- Close The WSL session and run `wsl.exe --shutdown` in a powershell shell to restart WSL.

### Update WSL2 (Ubuntu) packages

Run

```zsh
make update-wsl-ubuntu
```

This upgrades the Galaxy collections from requirements.yml and runs the playbook's update tasks.

## Setup Debian 13 (Trixie)

- Add current user to sudoers file. (log in as root `su -` and run `usermod -aG sudo [username]`)
- Install git `sudo apt install git`
- Clone this repo, preferably in your home directory
- Run `make setup-debian`. This will install python and make, plus the latest ansible & ansible-lint via pipx, then run the playbook.

### Update Debian 13 (Trixie) packages

Run

```zsh
make update-debian
```

This upgrades the Galaxy collections from requirements.yml and runs the playbook's update tasks.
