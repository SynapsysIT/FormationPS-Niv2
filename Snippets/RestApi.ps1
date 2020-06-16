#Les API de certains service Web permettent de récupérer des données et formater la sortie
$Request = Invoke-RestMethod "http://dummy.restapiexample.com/api/v1/employees"
$Request.Data

(Invoke-RestMethod -Uri 'https://api.ipify.org?format=json').ip


$User = (Invoke-RestMethod https://randomuser.me/api/?nat=fr).results