# CHOCOLATEY
Write-Host "***************** UPDATE CHOCOLATEY PACKAGES *****************"  -ForegroundColor White -BackgroundColor Black
choco upgrade all -y

# WINGET
Write-Host "***************** UPDATE WINGET PACKAGES *****************"  -ForegroundColor White -BackgroundColor Black
winget upgrade --all

#NEOVIM
Write-Host "***************** NEOVIM PLUGINS *****************"  -ForegroundColor White -BackgroundColor Black
nvim --headless -c "autocmd User PackerComplete quitall" -c "lua require('packer').sync()"