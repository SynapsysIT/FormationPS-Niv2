Function Get-ComputerInfoPerso {

    <#
    .SYNOPSIS
        This function can retrieve some computer information
    .DESCRIPTION
        This function can retrieve some computer information
    .PARAMETER ComputerName
        uno
    .EXAMPLE
        Get-Test -ComputerName "toto"
    #>
    
    Param
    (
        [Parameter(Mandatory = $true, ValuefromPipeline = $True, Position = 0)]
        [string]$ComputerName
    )
    
    
    # OSVersion - BuildOS - NumOfProcessors - RamMemory - SystemDrive - Status
    Try {
        $Round1 = Get-CimInstance -ComputerName $ComputerName -Class win32_OperatingSystem -ErrorAction Stop
    }
    Catch {
        Write-Error ('[ERROR] Unable to retrieve some Computer infos: ' + $Error[0].Exception.Message)
        exit 1 
    }
    
    #SystemDriveFreeSpace
    Try {
        $Round2 = Get-CimInstance -ComputerName $ComputerName -Class Win32_Logicaldisk -filter "deviceid='C:'" -ErrorAction Stop
        $Round2 = ($Round2.FreeSpace) / 1GB
    }
    Catch {
        Write-Error ('[ERROR] Unable to retrieve #SystemDriveFreeSpace: ' + $Error[0].Exception.Message)
        exit 1   
    }
    
    #PsCustomObject
    $Obj = [PSCustomObject]@{
        ComputerName         = $Round1.CSName
        OSVersion            = $Round1.Version
        BuildOS              = $Round1.BuildNumber
        NumOfProcessors      = $Round1.NumberOfProcesses
        RamMemory            = $Round1.TotalVisibleMemorySize
        SystemDrive          = $Round1.SystemDrive
        SystemDriveFreeSpace = $Round2
        Status               = $Round1.Status
    }

    Write-Output $Obj
}