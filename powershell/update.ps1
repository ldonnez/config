# CHOCOLATEY
Write-Host "***************** UPDATE CHOCOLATEY PACKAGES *****************"  -ForegroundColor White -BackgroundColor Black
choco upgrade all -y

# WINGET
Write-Host "***************** UPDATE WINGET PACKAGES *****************"  -ForegroundColor White -BackgroundColor Black
winget upgrade --all

# WSL
Write-Host "***************** UPDATE WINGET PACKAGES *****************"  -ForegroundColor White -BackgroundColor Black
wsl.exe --update

#VIM-PLUG
Write-Host "***************** UPGRADE vim-plug ***********************"  -ForegroundColor White -BackgroundColor Black
vim +PlugUpgrade +qall

#VIM
Write-Host "***************** VIM PLUGINS ***********************"  -ForegroundColor White -BackgroundColor Black
vim +PlugUpdate +qall

#NEOVIM
Write-Host "***************** NEOVIM PLUGINS *****************"  -ForegroundColor White -BackgroundColor Black
nvim --headless "+Lazy! sync" +qa
