function Get-MachineInfo
{
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline = $True, Mandatory = $false)]
        [Alias('CN', 'DNSHostName', 'Name')]
        [string[]]$ComputerName = "localhost",

        [switch]$UseDCOM
    )
 
    BEGIN { }

    PROCESS
    {
        # Connect session
        try 
        {
            if ($UseDCOM)
            {
                $CIMOption = New-CimSessionOption -Protocol DCOM
            }
            else
            {
                $CIMOption = New-CimSessionOption -Protocol WSMAN
            }

            $session = New-CimSession -ComputerName $ComputerName -SessionOption $CIMOption -ErrorAction Stop

            Write-Verbose "Connected on $ComputerName"

            # Query data
            $OSInfo_params = @{
                'ClassName'  = 'Win32_OperatingSystem'
                'CimSession' = $session
            }

            $OSInfo = Get-CimInstance @OSInfo_params


            $CSInfo_params = @{
                'ClassName'  = 'Win32_ComputerSystem'
                'CimSession' = $session
            }

            $CSInfo = Get-CimInstance @CSInfo_params

            $DriveInfo_Params = @{
                'ClassName'  = 'Win32_LogicalDisk'
                'Filter'     = "DeviceId='$($OSInfo.SystemDrive)'"
                'CimSession' = $session
            }

            $DriveInfo = Get-CimInstance @DriveInfo_Params

            $ProcInfo_params = @{'ClassName' = 'Win32_Processor'
                'CimSession'                 = $session
            }
            $ProcInfo = Get-CimInstance @ProcInfo_params | Select-Object -first 1

            # ClOSInfoe session
            $session | Remove-CimSession


            [PSCustomObject][ordered]@{
                'ComputerName'      = $ComputerName
                'OSInfoVersion'     = $OSInfo.version
                'SPVersion'         = $OSInfo.servicepackmajorversion
                'OSInfoBuild'       = $OSInfo.buildnumber
                'Manufacturer'      = $CSInfo.manufacturer
                'Model'             = $CSInfo.model
                'Procs'             = $CSInfo.numberofprocessors
                'Cores'             = $CSInfo.numberoflogicalprocessors
                'RAM'               = ($CSInfo.totalphysicalmemory / 1GB)
                'Arch'              = $ProcInfo.addresswidth
                'SysDriveFreeSpace' = {}($DriveInfo.freespace / $DriveInfo.)
            }


        }
        catch 
        {
            Write-Warning "Unable to connect on $ComputerName"
        }
 
    } #PROCESS

    END { }

} #function