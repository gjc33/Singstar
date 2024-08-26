$FolderPath = "C:\Users\garyc\Documents\GitHub\Singstar\"

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
<!DOCTYPE document [ <!ATTLIST xsl:stylesheet id ID #REQUIRED> ]>

<document>

'@

$stylesheet = @'
<xsl:stylesheet id="style1"
                    version="1.0"
                    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:template match="/">

  <h2>Singstar Catalogue</h2>
  <table border="1">
    <tr bgcolor="#9acd32">
      <th>Format</th>
      <th>Disc</th>
      <th>Artist</th>
      <th>Song Title</th>
    </tr>
    <xsl:for-each select="//Catalogue/Track">
    <tr>
      <td><xsl:value-of select="Format"/></td>
      <td><xsl:value-of select="Disc"/></td>
      <td><xsl:value-of select="Artist"/></td>
      <td><xsl:value-of select="SongTitle"/></td>
    </tr>
    </xsl:for-each>
  </table>

</xsl:template>

</xsl:stylesheet>

<Catalogue>
'@

$xml += $stylesheet

$xml += $data | ForEach-Object {
    $ExecutionContext.InvokeCommand.ExpandString($entrytemplate)
}

$xml += "</Catalogue></document>"

$xml | Out-File $(Join-Path $FolderPath "index.html")
