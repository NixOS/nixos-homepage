<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:sets="http://exslt.org/sets"
                xmlns:exsl="http://exslt.org/common"
                xmlns:str="http://exslt.org/strings"
                xmlns="http://www.w3.org/1999/xhtml"
                extension-element-prefixes="exsl sets str"
                exclude-result-prefixes="xhtml"
                >

  <xsl:param name="fileName" />
  <xsl:param name="toTop" />

  <xsl:output method='xml' encoding="UTF-8"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
              />

  <xsl:template match="xhtml:html">

    <html xml:lang="en" lang="en">
      
      <head>
        <xsl:copy-of select="xhtml:head/*" />
        <link rel="stylesheet" href="{$toTop}style.css" type="text/css" />
        <link rel="stylesheet" href="{$toTop}navbar.css" type="text/css" />
        <link rel="stylesheet" href="{$toTop}news.css" type="text/css" />
      </head>
        
      <body>

        <div id="container">

          <div id="leftnavbar">

            <!--
            <div id="logo">
              <img src="{$toTop}nix-logo.jpg" alt="Nix Logo" />
            </div>
            -->

            <ul>
              <xsl:variable name="sections" xmlns="">
                <section url="index.html">Home</section>
                <section url="about.html">About</section>
                <section url="news.html">News</section>
                <section url="download.html">Download
                  <subsection url="foo">Latest stable release</subsection>
                  <subsection url="foo">Latest unstable release</subsection>
                  <subsection url="foo">Older releases</subsection>
                </section>
                <section url="docs.html">Documentation
                  <subsection url="foo">FAQ</subsection>
                  <subsection url="foo">Manual</subsection>
                  <subsection url="foo">Research papers</subsection>
                </section>
                <section>Projects
                  <subsection url="foo">Nix Packages</subsection>
                  <subsection url="foo">NixOS</subsection>
                  <subsection url="foo">Services</subsection>
                  <subsection url="foo">Buildfarm</subsection>
                </section>
                <section>Resources
                  <subsection url="https://mail.cs.uu.nl/pipermail/nix-dev/">Mailing list</subsection>
                  <subsection url="https://bugs.cs.uu.nl/secure/BrowseProject.jspa?id=100a72">Bug tracker</subsection>
                  <subsection url="irc://irc.freenode.net/#trace">IRC channel</subsection>
                </section>
              </xsl:variable>
              <xsl:apply-templates select="exsl:node-set($sections)" />
            </ul>

          </div>

          <div id="content">

            <xsl:apply-templates mode="expandNews"
                                 select="xhtml:body/*[not(@class = 'svn-id')]" />

            <hr />

            <div id="svn-id">
              <p>
                <xsl:variable name="tokens" select="str:split(.//*[@class='svn-id'])" />
                This page was last updated on <xsl:value-of
                select="$tokens[4]" /><xsl:text> at
                </xsl:text><xsl:value-of select="$tokens[5]" />
                (revision <xsl:value-of select="$tokens[3]" />).
              </p>
            </div>
          
          </div>
        
        
        </div>


      </body>
      
    </html>
    
  </xsl:template>


  <xsl:template match="section">
    <li class="section">
      <xsl:choose>
        <xsl:when test="$fileName != @url">
          <xsl:apply-templates mode="maybePrefix" select="." />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="child::text()" />
        </xsl:otherwise>
      </xsl:choose>
      
<!--      <xsl:if test="($fileName = @url or subsection[$fileName = @url]) and subsection"> -->
      <xsl:if test="subsection">
        <xsl:if test="subsection">
          <ul>
            <xsl:apply-templates select="subsection" />
          </ul>
        </xsl:if>
      </xsl:if>
    </li>
  </xsl:template>

  
  <xsl:template match="subsection">
    <li class="subsection">
      <xsl:choose>
        <xsl:when test="$fileName != @url">
          <xsl:apply-templates mode="maybePrefix" select="." />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="." />
        </xsl:otherwise>
      </xsl:choose>
    </li>
  </xsl:template>


  <xsl:template mode="maybePrefix" match="*">
    <xsl:choose>
      <xsl:when test="starts-with(@url, 'http://')">
        <a href="{@url}"><xsl:value-of select="child::text()" /></a>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$toTop}{@url}"><xsl:value-of select="child::text()" /></a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template mode="expandNews" match="xhtml:div[@class = 'news-placeholder']">
    <table class="news">

      <xsl:variable name="foo" select="xhtml:div[@class = 'number']" />

      <xsl:for-each select="document('news.xml')/news/item[not($foo) or position() &lt;= $foo]">

        <tr class="news-header">
          <td class="news-date"><xsl:value-of select="date" /></td>
          <td class="news-short">
            <xsl:copy-of select="title/child::node()" />
          </td>
        </tr>
        <tr class="news-descr">
          <td colspan="2">
            <xsl:copy-of select="description/child::node()" />
          </td>
        </tr>

      </xsl:for-each>

    </table>
  </xsl:template>

  <xsl:template mode="expandNews" match="*">
    <xsl:copy-of select="." />
  </xsl:template>

  
</xsl:stylesheet>
