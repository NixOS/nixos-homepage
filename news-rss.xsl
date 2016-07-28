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

  <xsl:output method='xml' encoding="UTF-8" omit-xml-declaration="no" />

  <xsl:param name="maxItem" />

  <xsl:template match="news">

    <!--<?xml version="1.0" encoding="UTF-8"?>-->
    <rss version="2.0" xmlns:blogChannel="http://backend.userland.com/blogChannelModule">
      <channel>
        <title>NixOS News</title>
        <link>https://nixos.org</link>
        <description>News for NixOS, the purely functional Linux distribution.</description>

        <image>
          <title>NixOS</title>
          <url>https://nixos.org/logo/nixos-logo-only-hires.png</url>
          <link>https://nixos.org/</link>
        </image>

        <xsl:for-each select="item[position() &lt;= $maxItem]">
          <item>
            <title><xsl:apply-templates select="title/child::node()" mode="id" /></title>
            <link>https://nixos.org/news.html</link>
            <description><xsl:copy-of select="description/child::node()" /></description>
            <pubDate><xsl:value-of select="pubDate" /></pubDate>
          </item>
        </xsl:for-each>
      </channel>
    </rss>
  </xsl:template>

</xsl:stylesheet>
