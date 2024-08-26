<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
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
    <xsl:for-each select="Catalog/Track">
    <tr>
      <td><xsl:value-of select="Format"/></td>
      <td><xsl:value-of select="Disc"/></td>
      <td><xsl:value-of select="Artist"/></td>
      <td><xsl:value-of select="SongTitle"/></td>
    </tr>
    </xsl:for-each>
  </table>
  </body>
  </html>
</xsl:template>

</xsl:stylesheet>