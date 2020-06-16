try
{
    #Cette erreur n'est pas "terminating" par defaut. 
    #Vous devez ajouter "-ErrorAction Stop" pour la rendre critique et qu'elle soit catchée

    Get-ChildItem -Path "C:\NotExist" -ErrorAction Stop           
    Write-Host "Everything is fine !" -ForegroundColor Green

    1/0
}
catch [System.DivideByZeroException]
{
    Write-Error "Revise tes maths !"
}
catch
{
    Write-Error $_.Exception.Message
}


trap
{
    Write-Host $PSItem.ToString() -ForegroundColor Yellow
}




1/0