# try each in turn
Get-Service -Name BITS, Nobody, WinRM -EA Continue
Get-Service -Name BITS, Nobody, WinRM -EA SilentlyContinue
Get-Service -Name BITS, Nobody, WinRM -EA Inquire
Get-Service -Name BITS, Nobody, WinRM -EA Stop


try
{
    #Cette erreur n'est pas "terminating" par defaut. 
    #Vous devez ajouter "-ErrorAction Stop" pour la rendre critique et qu'elle soit catchée

    Get-ChildItem -Path "C:\NotExist" -ErrorAction Stop           
    Write-Host "Everything is fine !" -ForegroundColor Green

    1 / 0
}
catch [System.DivideByZeroException]
{
    Write-Error "Revise tes maths !"
}
catch
{
    Write-Error $_.Exception.Message
}
finally
{
    Write-Host "Script Finish !"
}

#TRAP TEST
function TrapTest
{
    trap
    {
        Write-Host "ERROR TRAP" -ForegroundColor Yellow
    }

    Get-Service QuiExistePas -ErrorAction Stop
}





