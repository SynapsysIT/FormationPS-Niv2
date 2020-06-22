
$myCsv = Import-Csv -Path "S:\FormationPS-Niv2\WS2\ToCreate-Users.csv" -Delimiter ";"
$OUCible = "Game_Of_Thrones"
$FilterCsv = $mycsv | Where-Object {$_.OU -eq "Game_Of_Thrones" }

New-ADOrganizationalUnit -name $OUCible -path "OU=UTILISATEURS,DC=learn,DC=ps"

foreach($Ut in $FilterCsv){
    $UName = $Ut.prenom + ' ' + $Ut.Nom
    New-ADUser -name $UName -GivenName $Ut.prenom -Path "OU=$OUCible,OU=UTILISATEURS,DC=learn,DC=ps"
}