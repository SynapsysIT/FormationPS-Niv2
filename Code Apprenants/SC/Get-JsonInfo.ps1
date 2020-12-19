
$share = "C:\Users\schampault\FormationPS-Niv2\Snippets\JSON\SampleData"

function Get-JsonInfo
{
    [CmdletBinding()]
    param (
        
        
        [Parameter(Mandatory = $true)]
        [string]
        $share
    )
    
    begin
    {
        
    }
    process
    {

        $list = Get-ChildItem -Path $share
        $data = foreach ($item in $list)
        { 
            Get-Content -Path $item | Convertfrom-json
        }
        
        $ItemsProcessed = $data | Measure-Object -Property "Items Processed" -sum
        $Errors = $data | Measure-Object -Property "Errors" -sum
        $warning = $data | Measure-Object -Property "Warnings" -Average
        $job = $data | Measure-Object -Property "RunDate"-Minimum -Maximum
        


        [PSCustomObject]@{
            "Nombre de fichiers"   = $list.Count
            "Nombre d'items"       = $ItemsProcessed.Sum
            "Nombre d'erreurs"     = $Errors.Sum
            "Moyenne des warnings" = $warning.Average
            "Premier job"          = $job.Maximum
            "Dernier job"          = $job.Minimum

        }



    }
    
    end
    {
          
    }
}


