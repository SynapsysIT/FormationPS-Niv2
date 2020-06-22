clear-host
#$content = import-csv -path "C:\Users\iblin\Desktop\ToCreate-Users.csv" -Delimiter ";" | where-object { $_.OU -eq "The_Fifth_Element" }
$content = import-csv -path "S:\FormationPS-Niv2\WS2\ToCreate-Users.csv" -Delimiter ";" | where-object { $_.OU -eq "The_Fifth_Element" }

New-ADOrganizationalUnit -Name "The_Fifth_Element" -Path "OU=UTILISATEURS,DC=learn,DC=ps"

foreach ($user in $content)
{
        $OU = $user.ou
        $PRENOM = $user.Prenom
        $NOM = $user.Nom
        $SamAccountName = $user.SamAccountName
        $MemberOf = $user.MemberOf
          
    New-ADUser -SamAccountName $SamAccountName -Name $NOM -GivenName $PRENOM -Path "OU=The_Fifth_Element,OU=UTILISATEURS,DC=learn,DC=ps" #-Enabled $true
    Add-ADGroupMember -Identity $MemberOf -Members $user
} 



   