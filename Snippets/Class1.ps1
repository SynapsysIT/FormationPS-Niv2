class People 
{
    [string]$Nom
    [string]$Prenom
    [datetime]$DateNaissance
    [string]$VilleNaissance
    [char]$Sexe

    hidden [string]$ID

    People ()
    {
    }

    People([string]$Nom, [string]$Prenom, [datetime]$DateNaissance,[string]$VilleNaissance, [char]$Sexe)
    {
        $this.Nom = $Nom
        $this.Prenom = $Prenom
        $this.DateNaissance = $DateNaissance
        $this.Sexe = $Sexe
        $this.VilleNaissance = $VilleNaissance
        $this.ID = [guid]::NewGuid()
    }

    [string] GetAge()
    {
        $TimeSpan = [datetime]::Now - $this.DateNaissance
        $Years = (New-Object DateTime -ArgumentList $TimeSpan.Ticks).Year - 1
        return $Years
    }

    [string]ToString()
    {
        return $this.Prenom + " " + $this.Nom + "," + " né le " + $this.DateNaissance.ToString("dd/MM/yy") + " à " + $this.VilleNaissance
    }
        
}

$Var = [people]::new("Mazoyer","Julien",(Get-Date 12/10/1984),"Nîmes","M")
$Var.GetAge()

$Var | Get-Member

#Enumerations
Enum Turtles
{
    Donatello = 1
    Leonardo = 2
    Michelangelo = 3
    Raphael = 4
}

