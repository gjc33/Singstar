$FolderPath = "C:\Users\garyc\Documents\GitHub\Singstar\"

$data = Import-Csv -Path $(Join-Path $Folderpath "Singstar.csv") -Delimiter ","

$html = @'
<html>
    <body>
  <h2>Singstar Catalogue</h2>
      <table border="1">
        <tr bgcolor="#9acd32">
          <th>Format</th>
          <th>Disc</th>
          <th>Artist</th>
          <th>Song Title</th>
        </tr>
'@

$entryTemplate = @'

        <tr>
            <td>$($_.Format)</td>
            <td>$($_.Disc)</td>
            <td>$($_.Artist)</td>
            <td>$($_."Song Title")</td>
        </tr>

'@

$html += $data | ForEach-Object {
    $ExecutionContext.InvokeCommand.ExpandString($entrytemplate)
}

$html += @'

    </body>
</html>
'@


$html | Out-File $(Join-Path $FolderPath "index.html")
