[System.Math]::Round(5.9855)


"192.168.1.255" -as [System.Net.IPAddress]


$password = ConvertTo-SecureString 'Password@123' -AsPlainText -Force
$Credentials = [PSCredential]::new('Adminstrator', $password)









[version]"1.0.2"

[void](Get-Process)


[PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::Get



[guid]::NewGuid()

[System.Uri]'https://synapsys-it.com'

'https://synapsys-it.com' -as [uri]



$Code = [scriptblock]::Create("Get-Process")
&$Code