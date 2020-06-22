<#
.Synopsis
    AD OU and users creation
.DESCRIPTION
    Scritp create OU and users from CSV file
.EXAMPLE
    .\PRD_AD_Users_and_OU_Creation.ps1 -ImportCSV C:\Temp\ImportFile.Csv
.INPUTS
    Just CSV file with users and OU informations
.OUTPUTS
    Creation of OU, users and lof (if you ask)
#>

Param (
    [Parameter(Mandatory = $True, Position = 1)]
    $ImportCSV
)

#region Function
#region Function Create OU and Users
Function New-CustomADObject
{
    Param (
        [Parameter(ValueFromPipeline)]
        $ADObject,
        $ADObjectPath <#= 'OU=Utilisateurs,DC=learn,DC=ps'
 #>
        )

    BEGIN
    {

    }

    PROCESS 
    {
        #region OU
        $OU = $ADObject.OU
        $OUQuery = '(name=*' + $OU + '*)'
        $OUCheck = $null
        $OUCheck = Get-ADOrganizationalUnit -LDAPFilter $OUQuery
    
        If ($null -eq $OUCheck)
        {
            Try
            {
                $OuCheck = New-ADOrganizationalUnit -Name $OU -Path $ADObjectPath -PassThru
                #$OUCheck = Get-ADOrganizationalUnit -LDAPFilter $OUQuery
            }
            Catch
            {
            }
        }
        Else
        {
            'Deja existante'
        }
        #endregion OU
        
        #region User
        $UserSam = $ADObject.SamAccountName
        $UserCheck = $null
        $UserCheck = Get-ADUser -Filter { SamAccountName -eq $UserSam }
        $UserOU = $OUCheck.DistinguishedName

        If ($null -eq $UserCheck)
        {
            Try
            {
                $NewADUserParam = @{
                    DisplayName       = $ADObject.Prenom, $ADObject.Nom -join (' ')
                    Name              = $ADObject.Prenom, $ADObject.Nom -join (' ')
                    SamAccountName    = $UserSam
                    Surname           = $ADObject.Nom
                    GivenName         = $ADObject.Prenom
                    UserPrincipalName = $UserSam, (Get-ADDomain).DNSroot -join ('@') # Attention, le DNSroot n'est pas toujours l'extension de l'UPN
                    Path              = $UserOU
                    AccountPassword   = (ConvertTo-SecureString 'PowerShell4Life!' -AsPlainText -Force)
                    Enabled           = $true
                }

                $UserMember = $ADObject.MemberOf

                New-ADUser @NewADUserParam

                Try
                {
                    Add-ADGroupMember -Identity $UserMember -Members $UserSam
                }
                Catch
                {
                }
            }
            Catch
            {
            }
        }
        Else
        {
        }
        #endregion User
    }
    END 
    {

    }
}
#endregion Function Create OU and Users
#endregion Function

#region Variables
$ImportedCSV = Import-CSV $ImportCSV -Delimiter ";"
$ADObjectPath = 'OU=UTILISATEURS,DC=learn,DC=ps'
#endregion Variables

#region Check CSV
$NotePropertyCheck = @(
    'OU',
    'SamAccountName',
    'Nom',
    'Prenom',
    'MemberOf'
)
$ImportedNoteProperty = (($ImportedCSV | Get-Member) | Where-Object { $PsItem.MemberType -eq 'NoteProperty' }).Name


<#Version Julien
foreach ($NoteProperty in $ImportedNoteProperty)
{
    if ($NotePropertyCheck -notcontains $NoteProperty)
    {
        Write-Warning "La propriété $NoteProperty est introuvable"     
    }
}
#>

#Version Mathieu
$Result = New-Object PsObject
foreach ($NoteProperty in $ImportedNoteProperty)
{
    $Result | Add-Member NoteProperty -Name $NoteProperty -Value ($NotePropertyCheck -contains $NoteProperty)
}
If ($Result -match 'False')
{
    Write-Output "Au moins une colonne ne correspond pas aux propriétés attendu.`nMerci de vérifier le fichier CSV."
    $Result
    Pause
    Break
}
Else
{
    'YEAH'
}
#endregion Check CSV

#region Main
$ImportedCSV | New-CustomADObject -ADObjectPath $ADObjectPath # Voilà, cette simple ligne va tout initier =)
#endregion Main

# C:\Users\Emyel\Desktop\PRD_AD_Users_and_OU_Creation.ps1 -ImportCSV C:\Users\Emyel\Documents\ToCreate-Users.csv ###'OU=UTILISATEURS,DC=learn,DC=ps'