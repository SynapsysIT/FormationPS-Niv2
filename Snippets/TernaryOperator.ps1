($a -eq $b) ? $true : $false
(Test-Path $path) ? "Path exists" : "Path not found"

Write-Error 'Bad' && Write-Output 'Second'
Write-Output 'First' && Write-Output 'Second'

#Comment faire en Powershell 5 sans If / Else
@{ $true = 'Path Exists'; $false = 'Path Not Found'}[(Test-Path C:\Windows)]



