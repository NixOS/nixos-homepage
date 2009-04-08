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

  <xsl:param name="toTop">
    <xsl:for-each select="str:split($fileName, '')[text() = '/']">
      <xsl:text>../</xsl:text>
    </xsl:for-each>
  </xsl:param>

  <xsl:param name="latestNix">http://nixos.org/releases/nix/nix-0.12</xsl:param>

  <xsl:output method='xml' encoding="UTF-8"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
              />

  <xsl:template match="xhtml:html">

    <html xml:lang="en" lang="en">
      
      <head>
	<xsl:apply-templates select="xhtml:head/*" mode="id"/>
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
                <section>Main
                  <link url="index.html">Home</link>
                  <link url="about.html">About</link>
                  <link url="news.html">News</link>
                </section>
                <section>Download
                  <link url="{$latestNix}">Latest stable release</link>
                  <link url="http://hydra.nixos.org/release/nix/unstable/latest">Latest unstable release</link>
                  <link url="http://nixos.org/releases/full-index-nix.html">Older releases</link>
                </section>
                <section>Documentation
                  <!-- <link url="foo">FAQ</link> -->
                  <link url="http://hydra.nixos.org/job/nix/trunk/build/latest/download-by-type/doc/manual">Manual</link>
                  <link url="docs/papers.html">Research papers</link>
                </section>
                <section>Projects
                  <link url="nixpkgs.html">Nix Packages</link>
                  <link url="nixos/index.html">NixOS</link>
                  <!--
                  <link url="foo">Services</link>
                  <link url="foo">Buildfarm</link>
                  -->
                  <link url="patchelf.html">PatchELF</link>
                </section>
                <section>Resources
                  <link url="https://mail.cs.uu.nl/mailman/listinfo/nix-dev">Mailing list</link>
                  <link url="https://svn.nixos.org/repoman/info/nix">Subversion repository</link>
                  <link url="http://bugs.strategoxt.org/browse/NIX">Bug tracker</link>
                  <link url="irc://irc.freenode.net/#nixos">IRC channel</link>
                  <link url="people.html">Contributors</link>
                </section>
              </xsl:variable>
              <xsl:apply-templates select="exsl:node-set($sections)" />
            </ul>

          </div>

          <div id="content">

            <xsl:apply-templates mode="expandNews"
                                 select="xhtml:body/child::node()[not(@class = 'svn-id')]" />
            
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
          <div class="title">
            <xsl:value-of select="child::text()" />
          </div>
        </xsl:otherwise>
      </xsl:choose>
      
<!--      <xsl:if test="($fileName = @url or link[$fileName = @url]) and link"> -->
      <xsl:if test="link">
        <xsl:if test="link">
          <ul>
            <xsl:apply-templates select="link" />
          </ul>
        </xsl:if>
      </xsl:if>
    </li>
  </xsl:template>

  
  <xsl:template match="link">
    <xsl:choose>
      <xsl:when test="$fileName != @url">
        <li>
          <div class="title">
            <xsl:apply-templates mode="maybePrefix" select="." />
          </div>
        </li>
      </xsl:when>
      <xsl:otherwise>
        <li class="active">
          <div class="title">
            <xsl:value-of select="." />
          </div>
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template mode="maybePrefix" match="*">
    <xsl:choose>
      <xsl:when test="contains(@url, '://')">
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
          <td class="news-short">
            <xsl:apply-templates select="title/child::node()" mode="id"/>
          </td>
          <td class="news-date"><xsl:value-of select="year" />/<xsl:value-of select="month" />/<xsl:value-of select="day" /></td>
        </tr>
        <tr class="news-descr">
          <td colspan="2">
            <xsl:apply-templates select="description/child::node()" mode="id"/>
          </td>
        </tr>

      </xsl:for-each>

    </table>
  </xsl:template>

  <xsl:template mode="expandNews" match="*">
    <xsl:apply-templates select="." mode="id"/>
  </xsl:template>


  <xsl:template match="xhtml:*" mode="id">
    <xsl:element name="{local-name(.)}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:for-each select="@*">
	<xsl:attribute name="{name(.)}">
	  <xsl:value-of select="."/>
	</xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates mode="id"/>
    </xsl:element>
  </xsl:template>
  
  
</xsl:stylesheet>
