function Create-Password {
    param (
        [int]$Length = 8
    )

    $ArrayofChar = ("!#$%&'()*+,-./:;<=>?@[\]^_`{|}~ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!\#$%&'()*+,-./:;<=>?@[\]^_`{|}~").GetEnumerator()
    $Password = ($ArrayofChar | Get-Random -Count $Length) -join ""
    
    Write-Output $Password
}



