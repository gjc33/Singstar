$FolderPath = "C:\Users\garyc\Documents\GitHub\Singstar\"

$data = Import-Csv -Path $(Join-Path $Folderpath "Singstar.csv") -Delimiter ","
$entryTemplate = @'

        <tr>
            <td>$($i)</td>
            <td>$($_.Format)</td>
            <td>$($_.Disc)</td>
            <td>$($_.Artist)</td>
            <td>$($_."Song Title")</td>
        </tr>

'@

$html = @'
<html>
    <body>
    <h2>Singstar Catalogue</h2>

    <table border='1'>
        <tr bgcolor='#9acd32'>
            <th>Index</th>
            <th>Format</th>
            <th>Disc</th>
            <th>Artist</th>
            <th>Song Title</th></tr>
'@

$html += $data | Sort "Artist"| ForEach-Object {$i = 1}{
    $ExecutionContext.InvokeCommand.ExpandString($entrytemplate)
    $i++
}

$html += @'
    </body>
</html>
'@


$html | Out-File $(Join-Path $FolderPath "index.html")

