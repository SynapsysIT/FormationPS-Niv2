function Get-DiskStats
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidatePattern("^[A-Z]{1}$")]
        [string[]]
        $DriveLetter,

        # Computer Name
        [Parameter(Mandatory = $false)]
        [string]
        $ComputerName = "localhost"
    )
    
    begin
    {
        
    }
    
    process
    {
        try
        {
            $CIMData = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='$($DriveLetter):'" -ComputerName $ComputerName -ErrorAction Stop
        }
        catch
        {
            Write-Error "Unable to query drive letter $DriveLetter"
        }
        
        [PSCustomObject]@{
            ComputerName = $ComputerName
            DriveLetter  = $DriveLetter
            FreeSpace    = "{0} {1}" -f [math]::Round($CIMData.Freespace/1GB, 2), "GB"
            TotalSpace   = "{0} {1}" -f [math]::Round($CIMData.Size/1GB, 2), "GB"
            Remaining    = "{0} {1}" -f [math]::Round(($CIMData.FreeSpace / $CIMData.Size) * 100), "%"
        }
    }
    
    end
    {
        
    }
}