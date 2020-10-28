# Get config from ./config.json
$config = Get-Content -Raw -Path "$PSScriptRoot/config.json" | ConvertFrom-Json

$dotfilesRepo = $config.dotfilesRepo
$dotfilesPath = $config.dotfilesPath
$extraPackagesToInstallWithChocolatey = $config.extraPackagesToInstallWithChocolatey
$installDotfiles = $config.installDotfiles
$privateDotfilesPath = $config.privateDotfilesPath

# Install chocolatey
Write-Host "***************** INSTALL THE CHOCOLATEY PACKAGE MANAGER *****************"  -ForegroundColor White -BackgroundColor Black
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

If ($config.configureGit) {
  Write-Host "***************** INSTALL GIT *****************"  -ForegroundColor White -BackgroundColor Black
  choco install git -y

  Write-Host "***************** SYMLINK $home\.gitconfig WITH $dotfilesPath\.gitconfig *****************"  -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\.gitconfig" -Target "$dotfilesPath\.gitconfig"

  Write-Host "***************** SYMLINK $home\.gitignore_global WITH $dotfilesPath\.gitignore_global *****************"  -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\.gitignore_global" -Target "$dotfilesPath\.gitignore_global"
}

$dotfilesExist = Test-Path -Path $config.dotfilesPath

If ($installDotfiles -And !$dotfilesExist) {
    Write-Host "***************** CREATE DOTFILES DIRECTORY $dotfilesPath *****************" -ForegroundColor White -BackgroundColor Black
    New-Item -Path $dotfilesPath -ItemType Directory

    Write-Host "***************** CLONE DOTFILES INTO $dotfilesPath *****************"
    git clone $dotfilesRepo $dofilesPath
}

If ($config.configureVim) {
  Write-Host "***************** INSTALL VIM *****************" -ForegroundColor White -BackgroundColor Black
  choco install vim -y

  Write-Host "***************** INSTALL NEOVIM *****************" -ForegroundColor White -BackgroundColor Black
  choco install neovim -y

  Write-Host "***************** SYMLINK $home\_vimrc WITH $dotfilesPath\.vimrc *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\_vimrc" -Target "$dotfilesPath\.vimrc"

  Write-Host "***************** SYMLINK $home\AppData\Local\nvim\init.vim WITH $dotfilesPath\.vimrc *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\AppData\Local\nvim\init.vim" -Target "$dotfilesPath\.vimrc"
}

If ($config.configureVifm) {
  Write-Host "***************** INSTALL VIFM  *****************" -ForegroundColor White -BackgroundColor Black
  choco install vifm -y

  Write-Host "***************** SYMLINK $home\AppData\Roaming\Vifm\vifmrc WITH $dotfilesPath\vifmrc *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\AppData\Roaming\Vifm\vifmrc" -Target "$dotfilesPath\vifmrc"
}

If ($config.configureAg) {
  Write-Host "***************** INSTALL AG (the silver searcher) *****************" -ForegroundColor White -BackgroundColor Black
  choco install ag -y

  Write-Host "***************** SYMLINK $home\.agignore WITH $dotfilesPath\.agignore *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\.agignore" -Target "$dotfilesPath\.agignore"
}

If ($config.configureAlacritty) {
  Write-Host "***************** INSTALL ALACRITTY *****************" -ForegroundColor White -BackgroundColor Black
  choco install alacritty -y

  Write-Host "***************** SYMLINK $home\AppData\Roaming\alacritty\alacritty.yml WITH $dotfilesPath\.alacritty.yml *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\AppData\Roaming\alacritty\alacritty.yml" -Target "$dotfilesPath\.alacritty.yml"
}

If ($config.configureSsh) {
  Write-Host "***************** SYMLINK $home\.ssh WITH $privateDotfilesPath\.ssh *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\.ssh" -Target "$privateDotfilesPath\.ssh"

  Write-Host "SET SSH STARTUP TYPE TO MANUAL" -ForegroundColor White -BackgroundColor Black
  Set-Service ssh-agent -StartupType Manual
}

$packages = $extraPackagesToInstallWithChocolatey -join ", "
Write-Host "***************** INSTALL $packages WITH CHOCOLATEY *****************" -ForegroundColor White -BackgroundColor Black
$extraPackagesToInstallWithChocolatey | ForEach-Object { choco install $_ -y }
