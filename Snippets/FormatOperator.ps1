#Arrondi une decimal à X chiffre aprés la virgule
 "{0:n3}" -f 123.45678

#Afficher un INT en décimal
 "{0:n3}" -f ([int32]12)

#Modifier l'affichage d'une suite de chiffre selon un template
"{0:0# ## ## ## ##}" -f 0611223344

#Crée une liste incrémentielle
1..100 | ForEach-Object { 'Name{0:d3}' -f $_ }

#Formater un objet en string
 Get-ChildItem $Home  | ForEach-Object {'Filename: {0} Created: {1}' -f $_.fullname,$_.creationtime}

#Afficher un chiffre en pourcentage
"{0:p0}" -f 0.5

#Afficher un nombre sur X digits
"{0:d5}" -f 123