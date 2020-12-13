#===============================================================================================================
# Language     :  PowerShell 5.0
# Filename     :  
# Autor        :  Julien MAZOYER [jmazoyer@synapsys-it.com]
# Description  :  
#===============================================================================================================
<#
    .SYNOPSIS
    
    .DESCRIPTION
    
    .EXAMPLE
        
    .EXAMPLE
    
    .LINK
    
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory = $True, Position = 1)]
    [ValidateScript({Test-Path -Path $_})]
    [string]$CSVPath
)

#============================================================================
#VARIABLES
#============================================================================
$TargetOU = "OU=Services,DC=contoso,DC=com"
$UPNRoot = (Get-ADDomain).DNSRoot
#============================================================================
#FUNCTIONS
#============================================================================
function Set-TargetOU
{
    param (
        [Parameter(Mandatory=$true)]
        [string]$OUName,

        [Parameter(Mandatory=$false)]
        [string]$Root = (Get-ADDomain).DistinguishedName
    )

    $OUPath = "OU=" + $OUName + "," + $Root

    if (Get-ADOrganizationalUnit -Filter {DistinguishedName -eq $OUPath})
    {
        return $OUPath
    }
    else
    {
        Write-Verbose "L'OU $OUPath n'existe pas. Création ..."
        $NewOU = New-ADOrganizationalUnit -Path $Root -Name $OUName -PassThru

        return $NewOU.DistinguishedName
    }
}

function Create-Password {
    param (
        [int]$Length = 15
    )

        $MyRange += 65..90 #UpperCase
        $MyRange += 97..122 #LowerCase
        $MyRange += 48..57 #Numbers
        $MyRange += (33..47) + (58..64) + (91..96) + (123..126) #Specials Characters
    

($MyRange | Get-Random -Count $Length | % { [char]$_ }) -join ''

}

function Get-SamAccountName
{
    param (
        [Parameter(Mandatory=$true)]
        [string]$GivenName,
    
        [Parameter(Mandatory=$true)]
        [string]$LastName
    )

        $SAM = ""
        ($GivenName -split " " -split "-" | ForEach-Object {$SAM += $_[0]})
        $SAM += $LastName -replace " "

        return $SAM.ToLower()
}

#============================================================================
#EXECUTION
#============================================================================
$CSV = Import-CSV -Path $CSVPath -Delimiter ";"
$MandatoryFields = @("GivenName","Surname","Service")
$CSVFields = ($CSV | Get-Member -MemberType NoteProperty).Name

foreach ($MandatoryField in $MandatoryFields)
{
    if ( $CSVFields -notcontains $MandatoryField )
    {
        Write-Warning "La valeur $MandatoryField est manquante dans le CSV. Sortie du script"
        break 
    }
}

foreach ($Line in $CSV) 
{
    $SamAccountName = Get-SamAccountName -GivenName $Line.GivenName -LastName $Line.SurName

    $NewADUserParam = @{
        DisplayName       = $Line.GivenName, ($Line.Surname).ToUpper() -join (' ')
        Name              = $Line.GivenName, ($Line.Surname).ToUpper() -join (' ')
        SamAccountName    = $SamAccountName
        UserPrincipalName = $SamAccountName, (Get-ADDomain).DNSRoot -join "@"
        Surname           = $Line.Surname
        GivenName         = $Line.GivenName
        Path              = Set-TargetOU -Root $TargetOU -OUName $Line.Service
        AccountPassword   = Create-Password -Length 15 | Tee-Object -Variable TempPassword | ConvertTo-SecureString -AsPlainText
        Enabled           = $true
    }

    New-ADUser @NewADUserParam -PassThru | Select-Object Name,SamAccountName,@{Name="Password";expression={$TempPassword}}

}
#============================================================================
#END
#============================================================================
Break

Get-ADUser -Filter * | Where-Object {$_.DistinguishedName -like "*OU=Services,DC=contoso,DC=com"} | Remove-ADUser
Get-ADOrganizationalUnit -Filter * | Where-Object {$_.DistinguishedName -like "*,OU=Services,DC=contoso,DC=com"} | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false -PassThru | Remove-ADOrganizationalUnit -Confirm:$false