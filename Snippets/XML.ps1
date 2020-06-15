$XML = [xml](Get-Content .\BandData.xml)


#Afficher les données du XML
$XML.Bands.Band | Select-Object @{Name = "Name"; Expression = { $_.Name.'#text' } },
@{Name = "Founded"; Expression = { $_.Name.Year } },
@{Name = "Lead"; Expression = { $_.lead } },
@{Name = "Members"; Expression = { $_.members.member } }


# <Band>
#     <Name Year="1970" City="Boston, MA">Aerosmith</Name>
#     <Lead>Steven Tyler</Lead>
#     <Members>
#         <Member>Tom Hamilton</Member>
#         <Member>Joey Kramer</Member>
#         <Member>Joe Perry</Member>
#         <Member>Brad Whitford</Member>
#     </Members>
# </Band>

#MODIFIER UN XML
$Band = $XML.CreateNode("element", "Band", "")

$Name = $XML.CreateElement("Name")
$Name.InnerText = "Synapsys"

$Year = $XML.CreateAttribute("Year")
$Year.InnerText = "2012"

$City = $XML.CreateAttribute("City")
$City.InnerText = "Paris, France"

$Name.Attributes.Append($Year)
$Name.Attributes.Append($City)

$Band.AppendChild($Name)

$LeadMember = $XML.CreateElement("Lead")
$LeadMember.InnerText = "Sebastien Di Ruocco"
$Band.AppendChild($LeadMember)

$XML.Bands.AppendChild($Band)

$XML.Save(".\BandData.modified.xml")


#=====================================================================

# CREER UN XML
[xml]$Doc = New-Object System.Xml.XmlDocument
$Dlecaration = $Doc.CreateXmlDeclaration("1.0", "UTF-8", $null)
$Doc.AppendChild($Dlecaration) | Out-Null

$Root = $Doc.CreateNode("element", "computer",$null)
$Name = $Doc.CreateElement("Name")
$Name.InnerText = $env:COMPUTERNAME
$Root.AppendChild($Name)


$Data = Get-HotFix -ComputerName $env:computername | Select-Object Caption,InstalledOn,InstalledBy,HotfixID,Description
$NodeUpdate = $Doc.CreateNode("element", "Updates", $null)

foreach ($item in $data)
{
    $Update = $Doc.CreateNode("element", "Update", $null)
    
    $Item | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
        $ElementInfo = $Doc.CreateElement($_)
        $ElementInfo.InnerText = $item.$_

        $Update.AppendChild($ElementInfo)

    }

    $NodeUpdate.AppendChild($Update) | Out-Null
}

$Root.AppendChild($NodeUpdate)
$Doc.AppendChild($Root)
$Doc.Save(".\HotfixesXML.xml")
    











$XML.Bands.Band[0].ChildNodes.Item(0)."#text" = "Club Dorothée"
$XML.Save(".\Snippets\NewBandData.xml")