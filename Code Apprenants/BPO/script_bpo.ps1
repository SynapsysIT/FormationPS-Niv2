
$CSVFile = Import-csv -Path "S:\FormationPS-Niv2\WS2\ToCreate-Users.csv" -Delimiter ";"
$OUCible = 'Back_To_The_Futur'
$Users = $CSVFile | Where-Object {$PsItem.OU -eq $OUCible}
$OUParent =(Get-ADOrganizationalUnit -Filter * | Where-Object {$_.Name -eq "UTILISATEURS"}).DistinguishedNAme
$NEwOU = New-ADOrganizationalUnit -name $OUCible -Path "OU=UTILISATEURS,DC=learn,DC=ps" -ProtectedFromAccidentalDeletion $false -PassThru
foreach($Ut in $Users){
    New-ADUser `
        -Name "$($ut.Nom)" `
        -DisplayName "$($ut.Nom) $($ut.Prenom)" `
        -SamAccountName "$($ut.SamAccountName)" `
        -Path $NewOU.DistinguishedName  `
        -AccountPassword (ConvertTo-SecureString 'P@ssw0rd!' -AsPlainText -force ) `
        -Enabled $True

        Add-ADGroupMember -Identity $Ut.Memberof -members $Ut.SamAccountName

}

