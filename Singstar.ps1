$FolderPath = "S:\Singstar\"

$data = Import-Csv -Path $(Join-Path $Folderpath "Singstar.csv") -Delimiter ","

$entryTemplate = @'
<Track>
    <Format>$($_.Format)</Format>
    <Disc>$($_.Disc)</Disc>
    <Artist>$($_.Artist)</Artist>
    <SongTitle>$($_."Song Title")</SongTitle>
</Track>
'@

$xml = @'
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="Singstar.xsl"?>
<Catalogue>
'@

$xml += $data | ForEach-Object {
    $ExecutionContext.InvokeCommand.ExpandString($entrytemplate)
}

$xml += "</Catalogue>"

$xml | Out-File $(Join-Path $FolderPath "Singstar.XML")
