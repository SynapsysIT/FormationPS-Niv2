﻿# Regex le plus simple
"Synapsys" -match "NAP"
"Synapsys" -cmatch "NAP"

#Pattern "Numéro de téléphone FR"
$PhonePattern = "(0[1-9])([0-9][0-9]){4}"

"0156857841" -match $PhonePattern
"9956857841" -match $PhonePattern

#Exemple de "capture group"
$TVShowPattern = "^(?<titre>.*?)\.S(?<saison>\d+)\.?E(?<episode>\d+)\.(?<reste>.*)$"

"Westworld.S03E01.VOSTFR.1080p.AMZN.WEB-DL.DDP5.1.H.264-MYSTERiON" -match $TVShowPattern

$Matches.titre
$Matches.saison
$Matches.episode


#Ajouter les caractères d'échappement pour une chaine RegEx
[RegEx]::Escape("C:\Windows\System32")
