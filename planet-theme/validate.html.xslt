<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:planet="http://planet.intertwingly.net/"
                xmlns="http://www.w3.org/1999/xhtml">
 
  <xsl:template match="atom:feed">
    <html xmlns="http://www.w3.org/1999/xhtml">

      <!-- head -->
      <xsl:text>&#10;&#10;</xsl:text>
      <head>
        <title><xsl:value-of select="atom:title"/></title>
        <meta name="robots" content="noindex,nofollow" />
        <meta name="generator" content="{atom:generator}" />
        <link rel="shortcut icon" href="/favicon.ico" />
        <style type="text/css">
        img{border:0}
        a{text-decoration:none}
        a:hover{text-decoration:underline}
        .message{border-bottom:1px dashed red} a.message:hover{cursor: help;text-decoration: none}
        dl{margin:0}
        dt{float:left;width:9em}
        dt:after{content:':'}
        </style>
      </head>

      <!-- body -->
      <xsl:text>&#10;&#10;</xsl:text>
      <body>
        <table border="1" cellpadding="3" cellspacing="0">
          <thead>
            <tr>
              <th></th>
              <th>Name</th>
              <th>Format</th>
              <xsl:if test="//planet:ignore_in_feed | //planet:filters |
                //planet:xml_base | //planet:*[contains(local-name(),'_type')]">
                <th>Notes</th>
              </xsl:if>
            </tr>
          </thead>
          <xsl:apply-templates select="planet:source">
            <xsl:sort select="planet:name"/>
          </xsl:apply-templates>
          <xsl:text>&#10;</xsl:text>
        </table>
      </body>
    </html>
  </xsl:template>
 
  <xsl:template match="planet:source">
    <xsl:variable name="validome_format">
      <xsl:choose>
        <xsl:when test="planet:format = 'rss090'">rss_0_90</xsl:when>
        <xsl:when test="planet:format = 'rss091n'">rss_0_91</xsl:when>
        <xsl:when test="planet:format = 'rss091u'">rss_0_91</xsl:when>
        <xsl:when test="planet:format = 'rss10'">rss_1_0</xsl:when>
        <xsl:when test="planet:format = 'rss092'">rss_0_90</xsl:when>
        <xsl:when test="planet:format = 'rss093'"></xsl:when>
        <xsl:when test="planet:format = 'rss094'">rss_0_90</xsl:when>
        <xsl:when test="planet:format = 'rss20'">rss_2_0</xsl:when>
        <xsl:when test="planet:format = 'rss'">rss_2_0</xsl:when>
        <xsl:when test="planet:format = 'atom01'"></xsl:when>
        <xsl:when test="planet:format = 'atom02'"></xsl:when>
        <xsl:when test="planet:format = 'atom03'">atom_0_3</xsl:when>
        <xsl:when test="planet:format = 'atom10'">atom_1_0</xsl:when>
        <xsl:when test="planet:format = 'atom'">atom_1_0</xsl:when>
        <xsl:when test="planet:format = 'cdf'"></xsl:when>
        <xsl:when test="planet:format = 'hotrss'"></xsl:when>
      </xsl:choose>
    </xsl:variable>

    <xsl:text>&#10;</xsl:text>
    <tr>
      <xsl:if test="planet:bozo='true'">
        <xsl:attribute name="style">background-color:#FCC</xsl:attribute>
      </xsl:if>
      <td>
        <a title="feed validator">
          <xsl:attribute name="href">
            <xsl:text>http://feedvalidator.org/check?url=</xsl:text>
            <xsl:choose>
              <xsl:when test="planet:http_location">
                <xsl:value-of select="planet:http_location"/>
              </xsl:when>
              <xsl:when test="atom:link[@rel='self']/@href">
                <xsl:value-of select="atom:link[@rel='self']/@href"/>
              </xsl:when>
            </xsl:choose>
          </xsl:attribute>
          <img src="http://feedvalidator.org/favicon.ico" hspace='2' vspace='1'/>
        </a>
        <a title="validome">
          <xsl:attribute name="href">
            <xsl:text>http://www.validome.org/rss-atom/validate?</xsl:text>
            <xsl:text>viewSourceCode=1&amp;version=</xsl:text>
            <xsl:value-of select="$validome_format"/>
            <xsl:text>&amp;url=</xsl:text>
            <xsl:choose>
              <xsl:when test="planet:http_location">
                  <xsl:value-of select="planet:http_location"/>
              </xsl:when>
              <xsl:when test="atom:link[@rel='self']/@href">
                <xsl:value-of select="atom:link[@rel='self']/@href"/>
              </xsl:when>
            </xsl:choose>
          </xsl:attribute>
          <img src="http://validome.org/favicon.ico" hspace='2' vspace='1'/>
        </a>
      </td>
      <td>
        <a href="{atom:link[@rel='alternate']/@href}">
          <xsl:choose>
            <xsl:when test="planet:message">
              <xsl:attribute name="class">message</xsl:attribute>
              <xsl:attribute name="title">
                <xsl:value-of select="planet:message"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="atom:title">
              <xsl:attribute name="title">
                <xsl:value-of select="atom:title"/>
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <xsl:value-of select="planet:name"/>
        </a>
      </td>
      <td><xsl:value-of select="planet:format"/></td>
      <xsl:if test="planet:ignore_in_feed | planet:filters | planet:xml_base |
        planet:*[contains(local-name(),'_type')]">
        <td>
          <dl>
            <xsl:for-each select="planet:ignore_in_feed | planet:filters |
              planet:xml_base | planet:*[contains(local-name(),'_type')]">
              <xsl:sort select="local-name()"/>
              <dt><xsl:value-of select="local-name()"/></dt>
              <dd><xsl:value-of select="."/></dd>
            </xsl:for-each>
          </dl>
        </td>
      </xsl:if>
    </tr>
  </xsl:template>
</xsl:stylesheet>
