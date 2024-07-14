# My setup configuration

## Disclaimer

This setup is mostly for my own usage and needs.

## Setup macOS

Make sure to check the vars in `setup_macos.yml` and configure the location of the `private_dotfiles_path` option
This path should be the location of your `.ssh`, `.gnupg` & `.secrets` directories.

- When running from fresh install run `xcode-select --install` to install minimal tools like git etc
- Clone this repo, preferably in your home directory
- Run `sh run_setup_macos.sh`. This will install homebrew, pip & ansible, install the requirements specified in requirements.yml and run the setup_macos.yml playbook

### Update macOS packages

Run

```
  ansible-playbook setup_macos.yml --tags=update
```

## Setup Windows

Make sure to check the config file in `powershell/config.json`!

- Clone this repo, preferably in your home directory
- Open Powershell with Administrator permissions and run `Set-ExecutionPolicy Unrestricted -Scope CurrentUser` to be able to run powershell scripts.
- Run `powershell/setup_windows.ps1` as Administrator
- Reboot
- Open Powershell with Administrator permissions and run `wsl --set-default-version 2` to set wsl2 as default wsl version

### Configuration options

You can configure the following options in `powershell/config.json`

```json
{
  "dotfilesRepo": "https://github.com/ldonnez/dotfiles.git",
  "dotfilesPath": <path>,
  "installDotfiles": true,
  "configureGit": true,
  "configureVim": true,
  "configureAlacritty": true,
  "configureAg": true,
  "configureVifm": true,
  "configureSsh": true,
  "configureWsl": true,
  "extraPackagesToInstallWithChocolatey": [<packageName>]
}
```

## Setup WSL2 (Ubuntu-22.04)

Make sure to check vars in `setup_wsl_ubuntu.yml`, configure the location of the `private_dotfiles_path` and `private_dotfiles_source` option
This path should be the location of your `.ssh`, `.gnupg` & `.secrets` directories.

- Clone this repo, preferably in your home directory
- Run `sh run_setup_wsl_ubuntu.sh`. This will install python, pip, ansible and makes sure the wsl.conf file is set to enable systemd.
- Close The WSL session and run wsl.exe --shutdown in powershell shell to rerstart WSL
- Open Ubuntu 22.04 again and run `ansible-galaxy install -r requirements.yml && ansible-playbook setup_wsl_ubuntu.yml -K --tags install`

### Update WSL2 (Ubuntu 22.04) packages

Run

```
  ansible-playbook setup_wsl_ubuntu.yml -K --tags update
```

## Setup Debian 12 (Bookworm)

Make sure to check vars in `setup_debian.yml`, configure the location of the `private_dotfiles_path` and `private_dotfiles_source` option.
This path should be the location of your `.ssh`, `.gnupg` & `.secrets` directories.

- Add current user to sudoers file. (log in as root `su` and run `sudo usermod -aG sudo [username]`)
- Install git `sudo apt install git`
- Clone this repo, preferably in your home directory
- Run `sh run_setup_debian.sh`. This will install all dependencies necessary (python, pipx and ansible) and run the playbook (`ansible-playbook setup_debian.yml -K --tags install`).

### Update Debian 12 (Bookworm) packages

Run

```
  ansible-playbook setup_debian.yml -K --tags update
```
