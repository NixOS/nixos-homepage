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
            <description><xsl:apply-templates select="description/child::node()" mode="serialize" /></description>
            <pubDate><xsl:value-of select="pubDate" /></pubDate>
          </item>
        </xsl:for-each>
      </channel>
    </rss>
  </xsl:template>

  <!-- from https://stackoverflow.com/a/15783514 -->
  <xsl:template match="*" mode="serialize">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:apply-templates select="@*" mode="serialize" />
    <xsl:choose>
      <xsl:when test="node()">
        <xsl:text>&gt;</xsl:text>
        <xsl:apply-templates mode="serialize" />
        <xsl:text>&lt;/</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> /&gt;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="@*" mode="serialize">
    <xsl:text> </xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>="</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"</xsl:text>
  </xsl:template>

  <xsl:template match="text()" mode="serialize">
    <xsl:value-of select="."/>
  </xsl:template>

</xsl:stylesheet>
