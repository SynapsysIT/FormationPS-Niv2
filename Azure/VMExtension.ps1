
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) 

choco install git --params "/NoShellIntegration" -y -r
choco install vscode -y -r
choco install vscode-powershell -y -r
choco install powershell-core -y -r
choco install microsoft-windows-terminal -y -r

Add-WindowsCapability -Online -Name "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"
Add-WindowsCapability -Online -Name "Rsat.FileServices.Tools~~~~0.0.1.0"