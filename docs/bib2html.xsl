<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:sets="http://exslt.org/sets"
                xmlns:exsl="http://exslt.org/common"
                xmlns:str="http://exslt.org/strings"
                xmlns="http://www.w3.org/1999/xhtml"
                extension-element-prefixes="exsl sets str">

  <xsl:import href="../lib.xsl" />

  <xsl:output method='xml' encoding="utf-8" />

  <xsl:key name="authorURLs" match="authorURL" use="text()" />

  <xsl:key name="years" match="year" use="." />
  

  <xsl:template match="bibliography">

    <html>
      
      <head>
        <title>Publications</title>
        <link rel="stylesheet" href="bib.css" type="text/css" />
        <xsl:call-template name="emitToggleScripts" />
      </head>
        
      <body>

        <h1>Publications</h1>

        <xsl:call-template name="emitMainToggle" />

        <xsl:for-each select="//year[count(. | key('years', .)[1]) = 1]">
          
          <h2><xsl:value-of select="." /></h2>
          
          <ul class="biblist">

            <xsl:for-each select="key('years', .)">

              <li class="bibitem">
                <xsl:if test="parent::*/@id">
                  <xsl:attribute name="id"><xsl:value-of select="parent::*/@id" /></xsl:attribute>
                </xsl:if>
                <xsl:apply-templates mode="item" select="parent::*" />
              </li>

            </xsl:for-each>

          </ul>

        </xsl:for-each>

        <div class="svn-id">
          <xsl:value-of select="/bibliography/@svn-id" />
        </div>

      </body>

    </html>

  </xsl:template>


  <xsl:template mode="item" match="*">

    <xsl:for-each select="author[position() != last()]">
      <xsl:apply-templates select="." />
      and
    </xsl:for-each>
    <xsl:apply-templates select="author[position() = last()]" />.

    <strong><xsl:value-of select="title" /></strong>.
    
    <xsl:if test="name() = 'inproceedings' or name() = 'article'">
      In

      <xsl:if test="editor">
        <xsl:for-each select="editor[position() != last()]">
          <xsl:apply-templates select="." />
          and
        </xsl:for-each>
        <xsl:apply-templates select="editor[position() = last()]" />
        (Ed<xsl:if test="count(editor) > 1">s</xsl:if>
        <xsl:text>.)</xsl:text>
      </xsl:if>

      <xsl:if test="booktitle">
        <xsl:if test="editor">, </xsl:if>
        <em><a href="{booktitle/@url}"><xsl:value-of
        select="booktitle" /></a></em>
      </xsl:if>
      
      <xsl:if test="series">
        <xsl:if test="editor or booktitle">, </xsl:if>
        volume <xsl:apply-templates mode="maybeLink" select="volume" />
        <xsl:if test="number">,
          number <xsl:apply-templates mode="maybeLink" select="number" />
        </xsl:if>
        of
        <em><xsl:apply-templates mode="maybeLink" select="series" /></em>
      </xsl:if>

      <xsl:if test="pages">,
        pages <xsl:value-of select="pages/@first" />–<xsl:value-of
        select="pages/@last" />
      </xsl:if>

      <xsl:if test="location">,   
        <xsl:value-of select="location" />
      </xsl:if>
      
      <xsl:text>. </xsl:text>
    </xsl:if>

    <xsl:if test="name() = 'mastersthesis' or name() = 'phdthesis'">
      <xsl:choose>
        <xsl:when test="name() = 'phdthesis'">PhD thesis</xsl:when>
        <xsl:when test="name() = 'mastersthesis'">Master’s thesis</xsl:when>
      </xsl:choose>,
      <xsl:if test="number">
        <xsl:apply-templates mode="maybeLink" select="number" />,
      </xsl:if>
      <xsl:value-of select="location" />.
    </xsl:if>

    <xsl:if test="name() = 'techreport'">
      Technical report
      <xsl:apply-templates mode="maybeLink" select="number" />,
      <xsl:value-of select="location" />.
    </xsl:if>

    <xsl:if test="publisher">
      <xsl:value-of select="publisher" />, 
    </xsl:if>
    
    <xsl:value-of select="month" />
    <xsl:text> </xsl:text>
    <xsl:value-of select="year" />.

    <xsl:if test="isbn">
      ISBN <xsl:value-of select="isbn" />.
    </xsl:if>
    
    <xsl:copy-of select="htmlnote/child::node()" />
    
    <xsl:apply-templates select="link" />

    <xsl:apply-templates select="abstract" />

  </xsl:template>


  <xsl:template match="author">
    <xsl:choose>
      <xsl:when test="key('authorURLs', text())">
        <a href="{key('authorURLs', text())/@url}">
          <xsl:value-of select="." />
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="." />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template match="editor">
    <xsl:value-of select="." />
  </xsl:template>

  
</xsl:stylesheet>
