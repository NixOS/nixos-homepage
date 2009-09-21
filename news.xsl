<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:sets="http://exslt.org/sets"
                xmlns:exsl="http://exslt.org/common"
                xmlns:str="http://exslt.org/strings"
                extension-element-prefixes="exsl sets str"
                exclude-result-prefixes="xhtml"
                >

  <xsl:output method='xml' encoding="UTF-8" omit-xml-declaration="yes" />

  <xsl:param name="maxItem" />

  <xsl:template match="news">

    <table class="news">

      <xsl:for-each select="item[position() &lt;= $maxItem]">

        <tr class="news-header"> 
          <td class="news-short">
            <xsl:apply-templates select="title/child::node()" mode="id"/>
          </td>
          <td class="news-date"><xsl:value-of select="year" />/<xsl:value-of select="month" />/<xsl:value-of select="day" /></td>
        </tr>
        <tr class="news-descr">
          <td colspan="2">
            <xsl:copy-of select="description/child::node()" />
          </td>
        </tr>

      </xsl:for-each>

    </table>
      
  </xsl:template>

</xsl:stylesheet>
