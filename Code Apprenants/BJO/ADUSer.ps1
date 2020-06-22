<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    CSVPath
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
Param(
    [string]$CSVPath = "S:\FormationPS-Niv2\WS2\ToCreate-Users.csv"
)
#
Set-StrictMode -Version 2.0
set-psdebug -strict
#
#region Constants
#
#endregion Constants
#
#region Variables
[string]$CurrentFolder = split-path $myInvocation.mycommand.path
[string]$PowerShellLogsDir = $CurrentFolder + "\ADUser_PowerShell.log"
[string]$OUCible = "The_Lord_Of_The_Rings"
[string]$DCPath = "OU=UTILISATEURS,DC=learn,DC=ps"
[string]$UserPassword = "P@ssw0rd"
#endregion Variables
#
#region Additional Functions
Function Write-Log($TextBlock)
{
    [string]$TimeDate = Get-Date
    [string]$OutPut = "$TimeDate - $Section - $TextBlock"
    add-content -path $PowerShellLogsDir -value $OutPut
    Write-Host $OutPut
}
#endregion Additional Functions
#
#region Main Functions
Function New-ClientDir($LogDir)
{
    if (!(Test-Path -Path $LogDir ))
    {
        New-Item -path $LogDir -ItemType directory -force
    }
    $Section = "Main               "
    Write-Log  "_____________________________________________________________________"
    Write-Log  "ScriptFullName = ""$CurrentFolder"""
    Write-Log  ""
    $Section = "New-ClientDir      "
    Write-Log  "Run > New-ClientDir"
}
#
Function New-UserbyCSV
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [string]$CSVPath,
        [Parameter(Mandatory = $True)]
        [string]$OUCible,
        [Parameter(Mandatory = $True)]
        [string]$DCPath,
        [Parameter(Mandatory = $True)]
        [string]$UserPassword
    )
    $Section = "New-UserbyCSV      "
    $CSVFile = Import-csv -Path $CSVPath -Delimiter ";"
    $Users = $CSVFile |
    Where-Object {
        $_.OU -eq $OUCible
    }
    IF (-not(Get-ADOrganizationalUnit -Filter "Name -like '$OUCible'"))
    {
        New-ADOrganizationalUnit -name $OUCible -Path "$($DCPath)"
        Write-Log "$OUCible OU created"
    }
    Else
    {
        Write-Log "$OUCible OU exist"
    }
    foreach ($ut in $Users)
    {
        IF (-not(Get-ADUser -identity $ut.SamAccountName))
        {
            Try
            {
                New-ADUser `
                    -Name "$($ut.Nom)" `
                    -DisplayName "$($ut.Prenom) $($ut.Nom)" `
                    -SamAccountName "$($ut.SamAccountName)" `
                    -UserPrincipalName ($($ut.Prenom) + $($ut.Nom) + "@learn.ps") `
                    -GivenName $ut.prenom `
                    -surname $ut.nom `
                    -path "OU=$($ut.OU),$($DCPath)" `
                    -AccountPassword (ConvertTo-SecureString "$UserPassword" -AsPlainText -Force) `
                    -Enabled $true
                Write-Log "$($ut.SamAccountName) account created"
            }
            Catch
            {
                Write-Log "ERROR during creation of $($ut.SamAccountName)"
            }
        }
        Else
        {
            Write-Log "$($ut.Nom) account exist"
        }
        Add-ADGroupMember -Identity $ut.MemberOf -Members $ut.SamAccountName
        Write-Log "$($ut.SamAccountName) add to $($ut.MemberOf)"
    }
}
##
Function Exit-Script()
{
    $Section = "Exit-Script        "
    Write-Log "Run > Exit-Script"
    Write-Log "Script Correctly run, EXIT now"
    Write-Log ""
    exit
}
#Endregion Function
#
#region Main
Function Main()
{
    New-ClientDir($CurrentFolder)
    New-UserbyCSV -CSVPath $CSVPath -OUCible $OUCible -DCPath $DCPath -UserPassword $UserPassword
    Exit-Script
}
#Endregion Main
Main

