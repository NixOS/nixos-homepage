<?xml version="1.0"?>

<xsl:stylesheet
    version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:x="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="x">

  <xsl:output method="html" omit-xml-declaration="yes" indent="no"/>

  <xsl:template match="/">
    <div class='row'>
      <div class="span3" id="sidebar">
        <ul class="nav nav-list affix">
          <xsl:for-each select="//x:div[@class='book']/x:div[@class = 'toc']/x:dl[@class = 'toc']/x:dt/x:span">
            <li><xsl:apply-templates select="node()" /></li>
          </xsl:for-each>
        </ul>
      </div>
      <div class="span9">
        <div class="page-header">
          <h1><xsl:apply-templates select="//x:div[@class='book']/x:div[@class='titlepage']//x:h1/node()"/></h1>
          <h2><xsl:apply-templates select="//x:div[@class='book']/x:div[@class='titlepage']//x:h2/node()"/></h2>
        </div>
        <div class="docbook">
          <xsl:apply-templates select="//x:div[@class='book']"/>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <xsl:template match="x:div[@class='toc' or @class='list-of-examples' or @class='author']" />

  <xsl:template match="x:p[@class='copyright']" />

  <xsl:template match="x:p[@class='copyright']" />

  <xsl:template match="x:div[@class='preface' or @class='chapter' or @class='section' or @class='appendix']">
    <section>
      <xsl:apply-templates select="@*|node()" />
    </section>
  </xsl:template>

  <xsl:template match="x:h1">
    <div class='page-header'><h1><xsl:apply-templates select="@*|node()" /></h1></div>
  </xsl:template>

  <!--
  <xsl:template match="x:h2">
    <div class='page-header'><h2><xsl:apply-templates select="@*|node()" /></h2></div>
  </xsl:template>
  -->

  <xsl:template match="x:div[@class='titlepage' and ../@class = 'book']" />

  <xsl:template match="x:div[@class='warning' and count(x:p) = 1]" priority='1'>
    <div class="alert alert-warning">
      <strong>Warning:</strong><xsl:text> </xsl:text><xsl:apply-templates select="x:p/node()" />
    </div>
  </xsl:template>

  <xsl:template match="x:div[@class='warning']">
    <div class="alert alert-warning">
      <xsl:apply-templates select="node()[not(self::x:h3)]" />
    </div>
  </xsl:template>

  <xsl:template match="x:div[@class='note' and count(x:p) = 1]" priority='1'>
    <div class="alert alert-info">
      <strong>Note:</strong><xsl:text> </xsl:text><xsl:apply-templates select="x:p/node()" />
    </div>
  </xsl:template>

  <xsl:template match="x:table">
    <table class='table table-striped'>
      <xsl:apply-templates select="@*|node()" />
    </table>
  </xsl:template>

</xsl:stylesheet>
