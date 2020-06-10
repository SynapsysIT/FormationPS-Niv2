
$CIMData = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"

$Obj = [PSCustomObject]@{
    ComputerName = $env:COMPUTERNAME
    FreeSpace    = $CIMData.Freespace/1GB
    TotalSpace   = $CIMData.Size/1GB

}


$Obj
Write-Output $Obj

#Add properties
$Obj | Add-Member -MemberType NoteProperty -Name "Comment" -Value 'System Drive'

#Remove properties
$Obj.psobject.Properties.Remove("Comment")

#List properties name
$Obj | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
$Obj.psobject.Properties.name

#Accessing one properties
$Obj.Remaining

#Build a collection
$TenTable = foreach ($Num in 1..10)
{
    [PSCustomObject]@{
        Number = $Num
        "x10" = $Num * 10
    }
}

Write-Output $TenTable
