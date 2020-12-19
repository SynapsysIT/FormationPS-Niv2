function Get-AnalyseData {
    [CmdletBinding()]
    param (
        [string]
        $DataFolderPath
    )
    
    begin {
        
    }
    
    process {
        $data = Get-ChildItem -Path $DataFolderPath | ForEach-Object {
            Get-Content $_.FullName | ConvertFrom-Json
        }

        $data = $data | Select-Object JobID,"Items processed",Errors,Warnings,@{name="RunDate";expression={get-date $_.RunDate}}

        $result = [PSCustomObject]@{
            FileNb = ($data | Measure-Object | Select-Object -ExpandProperty Count)
            ItemNb = ($data."Items Processed" | Measure-Object -Sum | Select-Object Sum).sum
            ErrorNb = ($data.Errors | Measure-Object -Sum | Select-Object Sum).sum
            WarningAvrg = ($data."Warnings" | Measure-Object -Average | Select-Object Average).Average
            FirstJob = "bla"
            LastJob = "bla"
        }
        Write-Output $result
    }
    
    end {
        
    }
}