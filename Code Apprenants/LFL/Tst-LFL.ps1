$disk=Get-volume -DriveLetter C 
$Size=$disk.Size
$SizeAvailable=$disk.SizeRemaining

$Pourcent=($SizeAvailable*100)/$Size


$RoundP = [math]::Round($Pourcent)

Write-Output "$RoundP %"


[math]::Round(((Get-volume -DriveLetter C ).SizeRemaining * 100) / ((Get-volume -DriveLetter C ).Size))