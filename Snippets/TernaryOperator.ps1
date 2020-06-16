
# SI la condition est vrai la valeur de gauche est renvoyé vers le pipeline, sinon celle de droite
($a -eq $b) ? $true : $false
(Test-Path $path) ? "Path exists" : "Path not found"

    #Exemple pour reproduire ce comportement sous Powershell 5
    @{ $true = 'Path Exists'; $false = 'Path Not Found'}[(Test-Path C:\Windows)]

#Si la premier commande sort sans error la seconde est éxécutée
Write-Output 'First' && Write-Output 'Second'
Write-Error 'Bad' && Write-Output 'Second'

#Si la première commande sort en erreur, la seconde est éxécuté
Write-Error "First" || Write-Output "Second" 
Write-Output "First" || Write-Output "Second"





