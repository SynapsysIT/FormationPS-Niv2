Enum ServerType
{
    HyperV
    Sharepoint
    Exchange
    Lync
    Web
    ConfigMgr
}
   
Class Computer
{
    [String]$Name
    [String]$Type
    [string]$Description
    [string]$owner
    [string]$Model
    [int]$Reboots
    
    [void]Reboot()
    {
        $this.Reboots ++
    }
    
    #constructors
    Computer ([string]$Name)
    {
        if ($comp = Get-ADComputer -filter "name -eq '$Name'" -Properties * -ErrorAction SilentlyContinue)
        {
            $this.name = $Name
            $this.Description = $Comp.Description
    
            switch -wildcard ($comp.OperatingSystem)
            {
                ('*Server*') { $this.Type = 'Server'; Break }
                ('*workstation*') { $this.Type = 'Workstation' }
                ('*Laptop*') { $this.Type = 'Laptop'; Break }
                default { $this.Type = 'N/A' }
               
            }
            $this.owner = $comp.ManagedBy.Split(',')[0].replace('CN=', '')
        }
        else
        {
            Write-Verbose "Could Not find $($this.name)"
        }
           
    }
    Computer ([ServerType]$type, [string]$Description, [string]$owner, [String]$Model)
    {
   
        if ($user = Get-ADUser -Filter "name -eq '$owner'")
        {
            $ou = ""
            switch ($type)
            {
               
                "HyperV" { $ou = 'ou=HyperVHosts,OU=Servers,OU=HQ,DC=District,DC=Local'; break }
                "Exchange" { $ou = 'ou=ExchangeHosts,OU=Servers,OU=HQ,DC=District,DC=Local'; break }
                "ConfigMgr" { $ou = 'ou=ConfigMgrHosts,OU=Servers,OU=HQ,DC=District,DC=Local'; break }
                default { $ou = 'OU=Servers,OU=HQ,DC=District,DC=Local' }
               
            }
   
            $ServerName = [computer]::GetNextFreeName($type)
   
            try
            {
                New-ADComputer -Name $ServerName -Description $Description -ManagedBy $user -path $ou -ErrorAction Stop
                $this.Name = $ServerName
                $this.Type = $type
                $this.Description = $Description
                $this.owner = $owner     
            }
            catch
            {
                $_
            } 
        }
        else
        {
            Write-Warning "the user $($Owner) is not existing. Please verify and try again."
        }
           
           
    }
   
    #Methods
   
    [string]  static GetNextFreeName ([ServerType]$type)
    {
   
        $PrefixSearch = ""
        switch ($type)
        {
               
            "HyperV" { $PrefixSearch = "HYPE-*"; break }
            "Exchange" { $PrefixSearch = "EXCH-*"; break }
            "ConfigMgr" { $PrefixSearch = "CONF-*"; break }
            default { $PrefixSearch = "SERV-*"; break }
               
        }
   
        $AllNames = Get-ADComputer -Filter { name -like $PrefixSearch } | select name
        $Prefix = $PrefixSearch.Replace("*", "")
        [int]$LastUsed = $AllNames | % { $_.name.trim("$Prefix") } | select -Last 1
        $Next = $LastUsed + 1
        $nextNumber = $Next.tostring().padleft(3, '0')
        Write-Verbose "Prefix:$($Prefix) Number:$($nextNumber)"
        $Return = $prefix + $nextNumber
           
        return $Return
    }
}