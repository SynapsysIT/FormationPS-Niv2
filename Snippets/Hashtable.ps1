
#Définir une hashtable
$Servers = @{
    Prod = 'SRVPRD01'
    Hom  = 'SRVHOM02'
}
#Ajouter une entrée
$Servers.Add("Dev", "SRVDEV03")

#Accéder à une entrée
$Servers["Prod"]
$Servers["Prod", "Hom"]


#SPLATTING > Hastable en tant que collection de paramètres et de valeurs de paramètres

$Param = @{
    Path      = $Home
    Directory = $true
    Depth     = 1
}

Get-ChildItem @Param

#Equivalent de la commande
Get-ChildItem -Path $Home -Directory -Recurse -Depth 1

#Trés utilie pour adapter les paramètres d'une commande dans un script en fonction d'une condition
$CIMParams = @{
    ClassName = 'Win32_Bios'
    ComputerName = $ComputerName
}

if($Credential)
{
    $CIMParams.Credential = $Credential
}

Get-CIMInstance @CIMParams


#Hastable "ordonnée"
$Hashtable = [ordered]@{
    Value1 = 1
    Value2 = 2
    Value3 = 3
}

#Les valeurs peuvent être une nouvelle hashtable

$HashtableImbriq = @{
    Person1 = @{Name = "Adam" ; Age = 35}
    Person2 = @{Name = "Bob" ; Age = 25}

}

$HashtableImbriq.Person1


#Transformé une hashtable en PSCustomObject
$Hashtable = [ordered]@{
    Value1 = 1
    Value2 = 2
    Value3 = 3
}

[pscustomobject]$Hashtable
