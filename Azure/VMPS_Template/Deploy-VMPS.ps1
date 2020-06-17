[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [int]
    $VMNumber
)

$RessourceGroupName = (Get-AzResourceGroup -Name "PS-Formation").ResourceGroupName
$TemplateFile = Join-Path $PSScriptRoot -ChildPath template.json
$ParameterFile = Join-Path $PSScriptRoot -ChildPath parameters.json

foreach ($num in 5..7)
{
    $Num = "{0:D2}" -f $num

    $NetworkInterfaceName = "vm$($num)NIC"
    $networkSecurityGroupName = "VM$($num)-nsg"
    $publicIpAddressName = "VM$($num)-IP"
    $VirtualMachineName = "VM$($num)"
    $VirtualMachineComputerName = "VM$($num)"
    $adminPassword = ConvertTo-SecureString  "AzSynapsys20!" -AsPlainText -Force

    New-AzResourceGroupDeployment -ResourceGroupName $RessourceGroupName `
        -TemplateFile $TemplateFile `
        -networkInterfaceName $NetworkInterfaceName `
        -networkSecurityGroupName $networkSecurityGroupName `
        -publicIpAddressName $publicIpAddressName `
        -VirtualMachineName $VirtualMachineName `
        -VirtualMachineComputerName $VirtualMachineComputerName `
        -adminPassword $adminPassword `
        -TemplateParameterFile $ParameterFile

}



