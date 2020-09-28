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

    <section class="news-items">

      <xsl:for-each select="item[position() &lt;= $maxItem]">

        <article class="news-article">
          <header>
            <h2>
              <xsl:apply-templates select="title/child::node()" mode="id"/>
            </h2>
            <span class="date"><xsl:value-of select="substring(pubDate, 6, 11)" /></span>
          </header>

          <section>
            <xsl:copy-of select="description/child::node()" />
          </section>
        </article>

      </xsl:for-each>

    </section>

  </xsl:template>

</xsl:stylesheet>
