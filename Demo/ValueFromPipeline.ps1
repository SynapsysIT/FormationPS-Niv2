
#VALUE FROM PIPELINE BY PROPERTY NAME
function Test-Pipeline 
{
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]
        $Name
    )
    
    begin {
        Write-Host "Services Status" -ForegroundColor Yellow
        Write-Host $input
    }
    
    process {
       switch ((Get-Service $Name).Status) {
           "Running" { Write-Host $Name is $_ -ForegroundColor Green }
           "Stopped" { Write-Host $Name is $_ -ForegroundColor Red }
       }
    }
    
    end {
        Write-Host "Done !" -ForegroundColor Yellow
    }
}

Get-Service | Test-Pipeline

#VALUE FROM PIPELINE

Function Show-ProcessID {
    [CmdletBinding()]
    Param(
       [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
       [PSObject]$Process
    )
  
    Begin {
       Write-Verbose "In the begin block"
    }
  
    Process {
       Write-Verbose "In the process block"
       Write-Host $Process.Name have ID $Process.Id
    }
  
    End {
       Write-Verbose "In the end block"
    }
 }

 Get-Process | Select-Object -First 5 | Show-ProcessID