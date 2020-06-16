#Arrondi une decimal
[System.Math]::Round(5.9855)

#Vérifier la validité d'une adresse IP
"192.168.1.255" -as [System.Net.IPAddress]


#Générer un objet PSCredential
$password = ConvertTo-SecureString 'Password@123' -AsPlainText -Force
$Credentials = [PSCredential]::new('Adminstrator', $password)


#Créer un objet Version
[version]"1.0.2"

#Exécuter une commande sans qu'elle ne renvoit rien
[void](Get-Process)


#Généreer un objet de type URI
[System.Uri]'https://synapsys-it.com'

#Vérifier la validité d'une URL
'https://synapsys-it.com' -as [uri]


#Créer du code éxécutable à partir de texte brut
$Code = [scriptblock]::Create("Get-Process")
&$Code

#Lister les Type Accelerators
[PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::Get