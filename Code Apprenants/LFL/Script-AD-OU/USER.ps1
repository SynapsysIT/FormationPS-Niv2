$CSVFile = Import-csv -Path "S:\FormationPS-Niv2\WS2\ToCreate-Users.csv" -Delimiter ";"
$OUCible = 'Neon_Genesis_Evangelion'
$Users = $CSVFile | Where-Object { $PsItem.OU -eq $OUCible }

Get-ADOrganizationalUnit -Filter 'Name -like "Utilisateurs"'

$OuExisting = Get-ADOrganizationalUnit -Identity "OU=$OUCible,OU=UTILISATEURS,DC=learn,DC=ps"

$Users

   New-ADOrganizationalUnit -name $OUCible -Path "OU=UTILISATEURS,DC=learn,DC=ps"
  



foreach($user in $users){

    New-ADUser -Name "$($user.Nom)" -DisplayName "$($user.Nom) $($user.Prenom)" -SamAccountName "$($user.SamAccountName)" -Path "OU=$OUCible,OU=UTILISATEURS,DC=learn,DC=ps"
    }