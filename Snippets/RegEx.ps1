"Synapsys" -match "NAP"
"Synapsys" -cmatch "NAP"

$PhonePattern = "(0[1-9])([0-9][0-9]){4}"

"0156857841" -match $PhonePattern
"9956857841" -match $PhonePattern


$TVShowPattern = "^(?<titre>.*?)\.S(?<saison>\d+)\.?E(?<episode>\d+)\.(?<reste>.*)$"

"Westworld.S03E01.VOSTFR.1080p.AMZN.WEB-DL.DDP5.1.H.264-MYSTERiON" -match $TVShowPattern

$Matches.titre
$Matches.saison
$Matches.episode


$PROFILE | Select-Object *

AllUsersAllHosts       : C:\Program Files\PowerShell\7\profile.ps1
AllUsersCurrentHost    : C:\Program Files\PowerShell\7\Microsoft.PowerShell_profile.ps1
CurrentUserAllHosts    : C:\Users\jmazoyer\Documents\PowerShell\profile.ps1
CurrentUserCurrentHost : C:\Users\jmazoyer\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
Length                 : 67