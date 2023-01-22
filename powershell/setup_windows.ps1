# Get config from ./config.json
$config = Get-Content -Raw -Path "$PSScriptRoot/config.json" | ConvertFrom-Json

$dotfilesRepo = $config.dotfilesRepo
$dotfilesPath = $config.dotfilesPath
$chocolateyPackages = $config.chocolateyPackages
$wingetPackages = $config.wingetPackages
$msStorePackages = $config.msStorePackages
$gamingMsStorePackages = $config.gamingMsStorePackages
$installDotfiles = $config.installDotfiles
$privateDotfilesPath = $config.privateDotfilesPath

Write-Host "***************** ENABLE DEVELOPER MODE  *****************"  -ForegroundColor White -BackgroundColor Black
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
DISM /Online /Add-Capability /CapabilityName:Tools.DeveloperMode.Core~~~~0.0.1.0

# Install chocolatey
Write-Host "***************** INSTALL THE CHOCOLATEY PACKAGE MANAGER *****************"  -ForegroundColor White -BackgroundColor Black
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Write-Host "***************** INSTALL VISUAL STUDIO BUILD TOOLS *****************"  -ForegroundColor White -BackgroundColor Black
choco install visualstudio2019buildtools --package-parameters "--allWorkloads --includeRecommended --passive"

Write-Host "***************** INSTALL GIT *****************"  -ForegroundColor White -BackgroundColor Black
choco install git -y

$dotfilesExist = Test-Path -Path $dotfilesPath

Write-Host "***************** INSTALL PACKAGES WITH CHOCOLATEY *****************" -ForegroundColor White -BackgroundColor Black
$chocolateyPackages | ForEach-Object { choco install $_ -y }

Write-Host "***************** RELOAD ENV PATH *****************" -ForegroundColor White -BackgroundColor Black
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

If ($installDotfiles -And !$dotfilesExist) {
    Write-Host "***************** CLONE DOTFILES INTO $dotfilesPath *****************" -ForegroundColor White -BackgroundColor Black
    git clone $dotfilesRepo $dotfilesPath
}

If ($config.configureGit) {
  Write-Host "***************** SYMLINK $home\.gitconfig WITH $dotfilesPath\.gitconfig *****************"  -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\.gitconfig" -Target "$dotfilesPath\.gitconfig"

  Write-Host "***************** SYMLINK $home\.gitignore_global WITH $dotfilesPath\.gitignore_global *****************"  -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\.gitignore_global" -Target "$dotfilesPath\.gitignore_global"
}

If ($config.configureYarn) {
  Write-Host "***************** INSTALL YARN VIA NPM *****************" -ForegroundColor White -BackgroundColor Black
  npm -g install yarn
}

If ($config.configureVim) {
  Write-Host "***************** INSTALL VIM *****************" -ForegroundColor White -BackgroundColor Black
  choco install vim -y

  Write-Host "***************** SYMLINK $home\_vimrc WITH $dotfilesPath\.vimrc *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\_vimrc" -Target "$dotfilesPath\.vimrc"

  Write-Host "***************** SYMLINK $home\_gvimrc WITH $dotfilesPath\.config\nvim\ginit.vim *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\_gvimrc" -Target "$dotfilesPath\.gvimrc"

  Write-Host "***************** INSTALL plugins *****************"  -ForegroundColor White -BackgroundColor Black
  vim +PlugUpdate +qall
}

If ($config.configureNeovim) {
  Write-Host "***************** INSTALL NEOVIM *****************" -ForegroundColor White -BackgroundColor Black
  choco install neovim -y

  Write-Host "***************** SYMLINK $home\AppData\Local\nvim\ginit.vim WITH $dotfilesPath\.config\nvim\ginit.vim *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\AppData\Local\nvim\ginit.vim" -Target "$dotfilesPath\.config\nvim\ginit.vim"

  Write-Host "***************** SYMLINK $home\AppData\Local\nvim\init.lua WITH $dotfilesPath\.config\nvim\init.lua *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\AppData\Local\nvim\init.lua" -Target "$dotfilesPath\.config\nvim\init.lua"

  Write-Host "***************** SYMLINK $home\AppData\Local\nvim\lua WITH $dotfilesPath\.config\nvim\lua *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType Junction -f -Path "$home\AppData\Local\nvim\lua" -Target "$dotfilesPath\.config\nvim\lua"

  Write-Host "***************** SYMLINK $home\AppData\Local\nvim\lazy-lock.json WITH $dotfilesPath\.config\nvim\lazy-lock.json *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\AppData\Local\nvim\lazy-lock.json" -Target "$dotfilesPath\.config\nvim\lazy-lock.json"

  Write-Host "***************** SYMLINK $home\AppData\Local\nvim\snippets WITH $dotfilesPath\.config\nvim\snippets *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType Junction -f -Path "$home\AppData\Local\nvim\snippets" -Target "$dotfilesPath\.config\nvim\snippets"

  Write-Host "***************** INSTALL language servers with npm *****************" -ForegroundColor White -BackgroundColor Black
  npm install typescript typescript-language-server vscode-langservers-extracted eslint_d @fsouza/prettierd -g

  Write-Host "***************** INSTALL language servers with yarn *****************" -ForegroundColor White -BackgroundColor Black
  yarn global add yaml-language-server -g

  Write-Host "***************** INSTALL stylua with cargo *****************" -ForegroundColor White -BackgroundColor Black
  cargo install stylua

  Write-Host "***************** INSTALL virtualenv with pip *****************" -ForegroundColor White -BackgroundColor Black
  pip3 install virtualenv

  Write-Host "***************** INSTALL plugins *****************"  -ForegroundColor White -BackgroundColor Black
  nvim --headless "+Lazy! sync" +qa
}

If ($config.configureVifm) {
  Write-Host "***************** INSTALL VIFM  *****************" -ForegroundColor White -BackgroundColor Black
  choco install vifm -y

  Write-Host "***************** SYMLINK $home\AppData\Roaming\Vifm\vifmrc WITH $dotfilesPath\vifmrc *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\AppData\Roaming\Vifm\vifmrc" -Target "$dotfilesPath\.config\vifm\vifmrc"
}

If ($config.configureAg) {
  Write-Host "***************** INSTALL AG (the silver searcher) *****************" -ForegroundColor White -BackgroundColor Black
  choco install ag -y

  Write-Host "***************** SYMLINK $home\.agignore WITH $dotfilesPath\.agignore *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\.agignore" -Target "$dotfilesPath\.agignore"
}

If ($config.configureFd) {
  Write-Host "***************** INSTALL FD *****************" -ForegroundColor White -BackgroundColor Black
  choco install fd -y

  Write-Host "***************** SYMLINK $home\.fdignore WITH $dotfilesPath\.agignore *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\.fdignore" -Target "$dotfilesPath\.agignore"
}

If ($config.configureRg) {
  Write-Host "***************** INSTALL RG *****************" -ForegroundColor White -BackgroundColor Black
  choco install ripgrep -y

  Write-Host "***************** SYMLINK $home\.fdignore WITH $dotfilesPath\.agignore *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\.rgignore" -Target "$dotfilesPath\.agignore"
}

If ($config.configureSsh) {
  Write-Host "***************** SYMLINK $home\.ssh WITH $privateDotfilesPath\.ssh *****************" -ForegroundColor White -BackgroundColor Black
  New-Item -ItemType SymbolicLink -f -Path "$home\.ssh" -Target "$privateDotfilesPath\.ssh"

  Write-Host "*****************  SET GIT_SSH ENV VARIABLE TO WINDOWS ssh.exe LOCATION *****************" -ForegroundColor White -BackgroundColor Black
  [System.Environment]::SetEnvironmentVariable('GIT_SSH','C:\Windows\System32\OpenSSH\ssh.exe')

  Write-Host "*****************  SET SSH STARTUP TYPE TO AUTOMATIC *****************" -ForegroundColor White -BackgroundColor Black
  Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service
}

If ($config.configureWsl) {
  Write-Host "***************** ENABLE WSL *****************" -ForegroundColor White -BackgroundColor Black
  dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

  Write-Host "*****************  ENABLE VIRTUAL MACHINE PLATFORM *****************" -ForegroundColor White -BackgroundColor Black
  dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

  Write-Host "***************** SET WSL2 AS DEFAULT *****************" -ForegroundColor White -BackgroundColor Black
  wsl --set-default-version 2

  Write-Host "***************** INSTALL WSL2 *****************" -ForegroundColor White -BackgroundColor Black
  winget install "Windows Subsystem for Linux" --source msstore --accept-source-agreements --accept-package-agreements

  Write-Host "***************** INSTALL Ubuntu 22.04.1 LTS WITH WINGET *****************" -ForegroundColor White -BackgroundColor Black
  winget install "Ubuntu 22.04.1 LTS" --silent --source msstore --accept-source-agreements --accept-package-agreements
}

Write-Host "***************** INSTALL PACKAGES WITH WINGET *****************" -ForegroundColor White -BackgroundColor Black
$wingetPackages | ForEach-Object { winget install "$_" --accept-source-agreements }

Write-Host "***************** INSTALL PACKAGES WITH WINGET FROM MSSTORE *****************" -ForegroundColor White -BackgroundColor Black
$msStorePackages | ForEach-Object { winget install "$_" --source msstore --accept-source-agreements --accept-package-agreements }

Write-Host "***************** INSTALL PACKAGES WITH WINGET FROM MSSTORE *****************" -ForegroundColor White -BackgroundColor Black
$msStorePackages | ForEach-Object { winget install "$_" --source msstore --accept-source-agreements --accept-package-agreements }

If ($config.configureForGaming) {
  Write-Host "***************** INSTALL GAMING PACKAGES WITH WINGET FROM MSSTORE *****************" -ForegroundColor White -BackgroundColor Black
  $gamingMsStorePackages | ForEach-Object { winget install "$_" --source msstore --accept-source-agreements --accept-package-agreements }
}

