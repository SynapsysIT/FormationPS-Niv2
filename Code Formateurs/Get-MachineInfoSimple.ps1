


function Get-MachineInfoCollab
{
    [CmdletBinding()]
    param (
        # Parameter help description  
        [Alias("MachineName")]
        [string[]]
        $Name
    )
    
    foreach ($item in $name) 
    {
            
        if (Test-connection -TargetName $item -Count 1 -Quiet -ErrorAction SilentlyContinue) 
        {
    
            $OSInfo = (Get-CimInstance win32_operatingSystem -computername $item)
            $ComputerInfo = Get-CimInstance win32_computerSystem -ComputerName $item 
            $DiskInfo = Get-CimInstance win32_logicalDisk -ComputerName $item | Where-Object { $_.name -eq $OsInfo.SystemDrive }

            [PSCustomObject]@{
                ComputerName         = $item
                OSVersion            = $OsInfo.Version
                BuildOS              = $OsInfo.Caption
                Model                = $ComputerInfo.Model
                NumOfProcessors      = $ComputerInfo.NumberOfProcessors
                RamMemory            = $ComputerInfo.TotalPhysicalMemory
                SystemDrive          = $OsInfo.SystemDrive
                SystemDriveFreeSpace = $DiskInfo.freespace
                Status               = "OK"
            }
            
        }
        Else
        {
            [PSCustomObject]@{
                Computer = $item
                Status   = "NOK"
            }
        }
         
    }
    
}