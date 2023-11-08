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

  <xsl:template match="news">

    <!--<?xml version="1.0" encoding="UTF-8"?>-->
    <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
      <channel>
        <title>NixOS News</title>
        <link>https://nixos.org/news.html</link>
        <atom:link href="https://nixos.org/blog/stories-rss.xml" rel="self" type="application/rss+xml" />
        <description>News for NixOS, the purely functional Linux distribution.</description>
        <fh:complete xmlns:fh="http://purl.org/syndication/history/1.0"/>

        <image>
          <title>NixOS News</title>
          <url>https://nixos.org/logo/nixos-logo-only-hires.png</url>
          <link>https://nixos.org/news.html</link>
        </image>

        <xsl:for-each select="item">
          <item>
            <title><xsl:apply-templates select="title/child::node()" mode="id" /></title>
            <link>https://nixos.org/blog/stories.html#<xsl:value-of select="title/@id" /></link>
            <description><xsl:apply-templates select="description/child::node()" mode="serialize" /></description>
            <pubDate><xsl:value-of select="pubDate" /></pubDate>
            <guid isPermaLink="false"><xsl:value-of select="pubDate" /></guid>
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
