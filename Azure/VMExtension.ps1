
Start-Transcript -Path "$PSScriptRoot\Transcript.txt"
Set-ExecutionPolicy Unrestricted -Scope Process -Force -Confirm:$false

Set-NetConnectionProfile -NetworkCategory Private
Enable-PSRemoting -Force -Confirm:$false

Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) 

$ChocolateyProfile = "C:\ProgramData\chocolatey\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

refreshenv

$securePassword = ConvertTo-SecureString 'AzSynapsys20!' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential '$env:computername\adm-ps', $securePassword

Invoke-Command -ScriptBlock {

  choco feature enable -n=allowGlobalConfirmation
  choco install git --params "/NoShellIntegration" -y -r
  choco install vscode -y -r
  choco install powershell-core -y -r
  choco install microsoft-windows-terminal -y -r

  refreshenv

  code --install-extension ms-vscode.powershell
  code --install-extension zhuangtongfa.material-theme
  code --install-extension ms-vsliveshare.vsliveshare
  code --install-extension coenraads.bracket-pair-colorizer-2

} -ComputerName $env:computername -Credential $credential

Add-WindowsCapability -Online -Name "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0"
Add-WindowsCapability -Online -Name "Rsat.FileServices.Tools~~~~0.0.1.0"

Set-WinUserLanguageList -LanguageList fr-FR -Force

Stop-Transcript