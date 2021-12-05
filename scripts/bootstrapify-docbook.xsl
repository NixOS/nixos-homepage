<?xml version="1.0"?>

<xsl:stylesheet
    version="1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:x="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="x">

  <xsl:output method="html" omit-xml-declaration="yes" indent="no"/>

  <xsl:template match="/">
    <xsl:apply-templates select="/x:html/x:body/x:div[@class!='navheader' and @class!='navfooter']" mode="top" />
  </xsl:template>

  <xsl:template match="*" mode="top">
    <xsl:apply-templates select="//x:script[@type='text/javascript']"/>
    <xsl:apply-templates select="//x:link[@rel='stylesheet' and @href!='style.css']"/>
    <div class="page-header">
      <xsl:if test="@class='book'">
        <h1><xsl:apply-templates select="//x:div[@class='book']/x:div[@class='titlepage']//x:h1/node()"/></h1>
        <h2><xsl:apply-templates select="//x:div[@class='book']/x:div[@class='titlepage']//x:h2/node()"/></h2>
      </xsl:if>
      <xsl:if test="@class!='book'">
        <h1><xsl:value-of select="//x:link[@rel='home']/@title"/></h1>
      </xsl:if>
    </div>

    <xsl:if test="//x:link/@rel">
      <ul class="pager">
        <xsl:if test="@class='book'">
          <xsl:attribute name="class">hidden</xsl:attribute>
        </xsl:if>
        <xsl:if test="@class!='book'">
          <xsl:attribute name="class">pager</xsl:attribute>
        </xsl:if>
        <xsl:if test="//x:link[@rel='prev']">
          <li class="previous">
            <a accesskey="p"><xsl:attribute name="href"><xsl:value-of select="//x:link[@rel='prev']/@href"/></xsl:attribute>
            ← <xsl:value-of select="//x:link[@rel='prev']/@title" /></a>
          </li>
        </xsl:if>
        <xsl:if test="//x:link[@rel='up']">
          <li class="up">
            <a accesskey="u"><xsl:attribute name="href"><xsl:value-of select="//x:link[@rel='up']/@href"/></xsl:attribute>
            ↑ <xsl:value-of select="//x:link[@rel='up']/@title" /></a>
          </li>
        </xsl:if>
        <xsl:if test="//x:link[@rel='next']">
          <li class="next">
            <a accesskey="n"><xsl:attribute name="href"><xsl:value-of select="//x:link[@rel='next']/@href"/></xsl:attribute>
            <xsl:value-of select="//x:link[@rel='next']/@title" /> →</a>
          </li>
        </xsl:if>
      </ul>
    </xsl:if>

    <div class="docbook">
      <xsl:apply-templates />
    </div>
    <xsl:if test="//x:link/@rel">
      <ul class="pager">
        <xsl:if test="@class='book'">
          <xsl:attribute name="class">hidden</xsl:attribute>
        </xsl:if>
        <xsl:if test="@class!='book'">
          <xsl:attribute name="class">pager</xsl:attribute>
        </xsl:if>
        <xsl:if test="//x:link[@rel='prev']">
          <li class="previous">
            <a accesskey="p"><xsl:attribute name="href"><xsl:value-of select="//x:link[@rel='prev']/@href"/></xsl:attribute>
            ← <xsl:value-of select="//x:link[@rel='prev']/@title" /></a>
          </li>
        </xsl:if>
        <xsl:if test="//x:link[@rel='up']">
          <li class="up">
            <a accesskey="u"><xsl:attribute name="href"><xsl:value-of select="//x:link[@rel='up']/@href"/></xsl:attribute>
            ↑ <xsl:value-of select="//x:link[@rel='up']/@title" /></a>
          </li>
        </xsl:if>
        <xsl:if test="//x:link[@rel='next']">
          <li class="next">
            <a accesskey="n"><xsl:attribute name="href"><xsl:value-of select="//x:link[@rel='next']/@href"/></xsl:attribute>
            <xsl:value-of select="//x:link[@rel='next']/@title" /> →</a>
          </li>
        </xsl:if>
      </ul>
    </xsl:if>


  </xsl:template>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!--
  <xsl:template match="x:div[@class='chapter' or @class='appendix']//x:div[@class='toc']" />
  -->

  <xsl:template match="x:div[@class='list-of-examples' or @class='author']" />

  <xsl:template match="x:p[@class='copyright']" />

  <xsl:template match="x:p[@class='copyright']" />

  <xsl:template match="x:div[@class='preface' or @class='chapter' or @class='section' or @class='appendix']">
    <section>
      <xsl:apply-templates select="@*|node()" />
    </section>
  </xsl:template>

  <xsl:template match="x:h1[x:a/@id]">
    <div class='page-header'>
      <h1>
        <xsl:attribute name="id"><xsl:value-of select="x:a/@id" /></xsl:attribute>
        <xsl:apply-templates select="@*|node()[not(self::x:a)]" />
      </h1>
    </div>
  </xsl:template>

  <xsl:template match="x:h2[x:a/@id]|x:h3[x:a/@id]">
    <xsl:element name="{name(.)}">
      <xsl:attribute name="id"><xsl:value-of select="x:a/@id" /></xsl:attribute>
      <xsl:apply-templates select="@*|node()[not(self::x:a)]" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="x:div[@class='titlepage' and ../@class = 'book']" />


  <!--
    Allow more precise targetting of admonitions by using more distinct class name.
    Also use semantic markup and follow rscss guidelines.
  -->
  <xsl:template match="x:div[(@class='caution' or @class = 'danger' or @class = 'important' or @class = 'note' or @class = 'tip' or @class = 'warning')]">
    <xsl:element name="aside">
      <xsl:attribute name="class">admonition-block -<xsl:value-of select="@class" /></xsl:attribute>
      <xsl:attribute name="role">note</xsl:attribute>
      <xsl:apply-templates select="@*[not(name() = 'class')]|node()" />
    </xsl:element>
  </xsl:template>

  <!-- Use div for the admonition title so it does not mess up the document outline. -->
  <xsl:template match="x:div[(@class='caution' or @class = 'danger' or @class = 'important' or @class = 'note' or @class = 'tip' or @class = 'warning')]/x:h3[@class='title']">
    <xsl:element name="div">
      <xsl:apply-templates select="@*|node()" />
    </xsl:element>
  </xsl:template>


  <xsl:template match="x:table">
    <table class='table table-striped'>
      <xsl:apply-templates select="@*|node()" />
    </table>
  </xsl:template>

</xsl:stylesheet>
