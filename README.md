# My setup configuration

## Disclaimer

This setup is mostly for my own usage and needs.

## Prerequisites

Ansible playbooks **setup_macos.yml** and **setup_debian.yml** includes the **secrets** role which installs vault encrypted (`ansible-vault encrypt <filename>`) files from a repository cloned to `~/.secrets`. Run with `--ask-vault-pass` to decrypt them:

```zsh
ansible-playbook setup_macos.yml -K --ask-vault-pass --tags install
```

## Setup macOS

- When running from fresh install run `xcode-select --install` to install minimal tools like git etc
- Clone this repo, preferably in your home directory
- Run `sh run_setup_macos.sh`. This will install homebrew, pip & ansible, install the requirements specified in requirements.yml and run the setup_macos.yml playbook

### Update macOS packages

Run

```zsh
  ansible-playbook setup_macos.yml --tags=update
```

## Setup WSL2 (Ubuntu >= 22.04)

Make sure to check vars in `setup_wsl_ubuntu.yml`.

- First, install WSL from an Administrator PowerShell:
  ```powershell
  wsl --install
  ```
- Then install the desired Ubuntu distro (replace version as needed):

  ```powershell
  wsl --install -d Ubuntu-22.04
  ```

  Supported versions: `Ubuntu-22.04`, `Ubuntu-24.04`, `Ubuntu-26.04`
  You can list available versions with:

  ```powershell
   wsl --list --online
  ```

- Launch the installed distro from the Start menu, create your Linux user, and let it finish initial setup
- To ensure network compatibility (especially for services that require bridged/mirrored networking like corporate VPN's), create or edit the `.wslconfig` file in your Windows user home directory (C:\Users\\\<YourUsername>\\\.wslconfig) and add the following:

```shell
[wsl2]
networkingMode=mirrored
```

- Clone this repo, preferably in your home directory
- Run `sh run_setup_wsl_ubuntu.sh`. This will install python and pipx and installs latest ansible and ansible-lint with pipx.
- Close The WSL session and run `wsl.exe --shutdown` in a powershell shell to restart WSL.

### Update WSL2 (Ubuntu) packages

Run

```zsh
  ansible-playbook setup_wsl_ubuntu.yml -K --tags update
```

## Setup Debian 13 (Trixie)

- Add current user to sudoers file. (log in as root `su` and run `sudo usermod -aG sudo [username]`)
- Install git `sudo apt install git`
- Clone this repo, preferably in your home directory
- Run `sh run_setup_debian.sh`. This will install all dependencies necessary (python, pipx and ansible) and run the playbook.

### Update Debian 13 (Trixie) packages

Run

```zsh
  ansible-playbook setup_debian.yml -K --tags update
```
