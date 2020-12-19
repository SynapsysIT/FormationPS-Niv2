Function Get-SnippetInfos
{

    <#
    .SYNOPSIS
        This function can retrieve snippet files infos
    .DESCRIPTION
        This function can retrieve snippet files infos
    .PARAMETER SourceFolderPath
        uno
    .EXAMPLE
        Get-Test -ComputerName "toto"
    #>

    Param
    (
        [Parameter(Mandatory = $true, ValuefromPipeline = $True, Position = 0)]
        [string]$SourceFolderPath
    )

    #Test
    If (Test-Path $SourceFolderPath)
    {
        #GCI
        $GciSourceFolder = Get-ChildItem -Path $SourceFolderPath

        #Convert From JSon
        $Obj = foreach ($File in $GciSourceFolder)
        {
            Get-Content -Path $File.PSPath | ConvertFrom-Json
        }

        $FinalObj = [PSCustomObject]@{
            TotalProcessedFiles = ($Obj | Measure-Object -Property "Items processed" -Sum).Sum
            TotalFiles          = $GciSourceFolder.count
            TotalErrors         = ($Obj | Measure-Object -Property Errors -Sum).Sum
            AverageWarnings     = ($Obj | Measure-Object -Property Warnings -Average).Average
            First               = ($Obj | Select-Object JobID, @{name='RunDateT';expression={[datetime]$_.RunDate}} | Sort-Object -Property RunDateT)[0]
            Last                = [string]($Obj | Select-Object JobID, @{name='RunDateT';expression={[datetime]$_.RunDate}} | Sort-Object -Property RunDateT)[-1]
        }

        $FinalObj
    }
    Else
    {
        Write-Output "Wrong Path"
    }
}

Get-SnippetInfos -SourceFolderPath "D:\New folder\FormationPS-Niv2\Snippets\JSON\SampleData"