<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:planet="http://planet.intertwingly.net/"
                exclude-result-prefixes="atom planet">
 
  <xsl:output indent="yes" method="xml"/>

  <xsl:template name="rfc822" xmlns:date="http://exslt.org/dates-and-times">
    <xsl:param name="date"/>
    <!-- http://www.trachtenberg.com/blog/2005/03/03/xslt-cookbook-generating-an-rfc-822-date/ -->
    <xsl:value-of select="concat(date:day-abbreviation($date), ', ',
      format-number(date:day-in-month($date), '00'), ' ',
      date:month-abbreviation($date), ' ', date:year($date), ' ',
      format-number(date:hour-in-day($date), '00'), ':',
      format-number(date:minute-in-hour($date), '00'), ':',
      format-number(date:second-in-minute($date), '00'), ' GMT')"/>
  </xsl:template>

  <xsl:template match="atom:feed">
    <opml version="1.1">
      <head>
        <title><xsl:value-of select="atom:title"/></title>
        <dateModified>
          <xsl:call-template name="rfc822">
            <xsl:with-param name="date" select="atom:updated"/>
          </xsl:call-template>
        </dateModified>
        <ownerName><xsl:value-of select="atom:author/atom:name"/></ownerName>
        <ownerEmail><xsl:value-of select="atom:author/atom:email"/></ownerEmail>
      </head>

      <body>
        <xsl:for-each select="planet:source">
          <outline type="rss" text="{planet:name}" title="{atom:title}"
            xmlUrl="{atom:link[@rel='self']/@href}"/>
        </xsl:for-each>
      </body>
    </opml>
  </xsl:template>
</xsl:stylesheet>
