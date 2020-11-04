# My setup configuration

## Disclaimer

This setup is mostly for my own usage and needs.

## Setup macOS

Make sure to check the config file in `ansible/macos/config.yml` and configure the location of the `private_dotfiles_path` option
This path should be the location of your `.ssh`, `.gnupg` & `.secrets` directories.

- When running from fresh install run `xcode-select --install` to install minimal tools like git etc
- Clone this repo, preferably in your home directory
- Configure the ansible playbook in `ansible/macos/config.yml` if necessary
- Run `sh ansible/macos/run.sh`. This will install homebrew, pip & ansible and run the setup_macos.yml playbook

### Configuration options

You can configure the following options in `ansible/macos/config.yml`

```yml
dotfiles_repo: "git@github.com:ldonnez/dotfiles.git"

dotfiles_directory_path: <path>
private_dotfiles_path: <path>

install_rubies: yes
install_extra_packages_with_homebrew: yes
configure_git: yes
configure_bat: yes
configure_zsh: yes
configure_vim: yes
configure_vifm: yes
configure_alacritty: yes
configure_tmux: yes
configure_ag: yes
configure_ssh: yes
configure_postgresql: yes
configure_redis: yes
configure_gnugpg: yes
configure_secrets: yes
configure_mutt: yes

extra_packages_to_install_with_homebrew:
  - <package-name>
```

## Setup Windows

Make sure to check the config file in `powershell/config.json`!

- Clone this repo, preferably in your home directory
- Configure the ansible playbook in `powershell/config.json` if necessary
- Open Powershell with Administrator permissions and run `Set-ExecutionPolicy Unrestricted -Scope CurrentUser` to be able to run powershell scripts.
- Run `powershell/setup_windows.ps1` as Administrator

### Configuration options

You can configure the following options in `powershell/config.json`

```json
{
  "dotfilesRepo": "git@github.com:ldonnez/dotfiles.git",
  "dotfilesPath": <path>,
  "installDotfiles": true,
  "configureVim": true,
  "extraPackagesToInstallWithChocolatey": [<packageName>]
}
```

## Setup WSL2 (Ubuntu-20.04)

Make sure to check the config file in `ansible/wsl-ubuntu/config.yml` and configure the location of the `private_dotfiles_path` option
This path should be the location of your `.ssh`, `.gnupg` & `.secrets` directories.

- Clone this repo, preferably in your home directory
- Configure the ansible playbook in `ansible/wsl-ubuntu/config.yml` if necessary
- Run `sh ansible/wsl-ubuntu/run.sh`. This will install python, pip & ansible and run the setup_wsl_ubuntu.yml playbook

### Configuration options

You can configure the following options in `ansible/wsl-ubuntu/config.yml`

```yml
dotfiles_repo: "git@github.com:ldonnez/dotfiles.git"

dotfiles_directory_path: <path>
private_dotfiles_path: <path>

install_dotfiles: yes
install_extra_packages_with_apt: yes
install_nodejs: yes
configure_git: yes
configure_bat: yes
configure_zsh: yes
configure_vim: yes
configure_vifm: yes
configure_tmux: yes
configure_ag: yes
configure_ssh: yes
configure_postgresql: yes
configure_redis: yes
configure_gnugpg: yes
configure_secrets: yes
configure_mutt: yes

extra_packages_to_install_with_apt:
  - <package-name>
```
