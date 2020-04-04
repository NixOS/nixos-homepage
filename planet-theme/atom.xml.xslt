<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:access="http://www.bloglines.com/about/specs/fac-1.0"
                xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:indexing="urn:atom-extension:indexing"
                xmlns:planet="http://planet.intertwingly.net/"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="planet xhtml">

  <!-- strip planet elements and attributes -->
  <xsl:template match="planet:*|@planet:*"/>

  <!-- strip obsolete link relationships -->
  <xsl:template match="atom:link[@rel='service.edit']"/>
  <xsl:template match="atom:link[@rel='service.post']"/>
  <xsl:template match="atom:link[@rel='service.feed']"/>

  <!-- Feedburner detritus -->
  <xsl:template match="xhtml:div[@class='feedflare']"/>

  <!-- Strip site meter -->
  <xsl:template match="xhtml:div[comment()[. = ' Site Meter ']]"/>

  <!-- add Google/LiveJournal-esque and Bloglines noindex directive -->
  <xsl:template match="atom:feed">
    <xsl:copy>
      <xsl:attribute name="indexing:index">no</xsl:attribute>
      <xsl:apply-templates select="@*"/>
      <access:restriction relationship="deny"/>
      <xsl:apply-templates select="node()"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:copy>
  </xsl:template>

<!-- popular customization: add planet name to each entry title
  <xsl:template match="atom:entry/atom:title">
    <xsl:text>&#10;    </xsl:text>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="../atom:source/planet:name"/>
      <xsl:text>: </xsl:text>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
-->

  <!-- indent atom elements -->
  <xsl:template match="atom:*">
    <!-- double space before atom:entries -->
    <xsl:if test="self::atom:entry">
      <xsl:text>&#10;</xsl:text>
    </xsl:if>

    <!-- indent start tag -->
    <xsl:text>&#10;</xsl:text>
    <xsl:for-each select="ancestor::*">
      <xsl:text>  </xsl:text>
    </xsl:for-each>

    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
 
      <!-- indent end tag if there are element children -->
      <xsl:if test="*">
        <xsl:text>&#10;</xsl:text>
        <xsl:for-each select="ancestor::*">
          <xsl:text>  </xsl:text>
        </xsl:for-each>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <!-- pass through everything else -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
