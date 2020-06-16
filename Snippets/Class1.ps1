#Enumerations
Enum Sexe
{
    M
    F
    X
}


class People 
{
    [string]$Nom
    [string]$Prenom
    [datetime]$DateNaissance
    [string]$VilleNaissance
    [Sexe]$Sexe

    hidden [string]$ID

    People ()
    {
    }

    People([string]$Nom, [string]$Prenom, [datetime]$DateNaissance,[string]$VilleNaissance, [sexe]$Sexe)
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

$Var = [people]::new("Turing","Alan",(Get-Date 23/06/1912),"Londres","M")
$Var.GetAge()

$Var | Get-Member



