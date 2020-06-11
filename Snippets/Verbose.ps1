﻿function Get-MultiplicationTab
{
    [CmdletBinding()]
    param (
        [int]$Table
    )
    
    $caller = (Get-PSCallStack)[0]
    Write-Verbose -Message "Function: $($caller.Command) - Params used: $($caller.Arguments)"
 

    $ObjTable = foreach ($Num in 1..10)
    {
        Write-Verbose -Message "Multiplicate $num by $Table"

        [PSCustomObject]@{
            Number = $Num
            "x$Table"  = $Num * $Table
        }
    }

    Write-Output $ObjTable
        
}