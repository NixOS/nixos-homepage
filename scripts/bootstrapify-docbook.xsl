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
    Convert admonitions.
    We mainly need to change the div classes to use the alert component.
    https://getbootstrap.com/2.3.2/components.html#alerts
  -->
  <xsl:template name="alert-class">
    <xsl:param name="admonition-type"/>
    <xsl:choose>
      <xsl:when test="$admonition-type = 'caution'">
        <xsl:value-of select="'alert-danger'"/>
      </xsl:when>
      <xsl:when test="$admonition-type = 'danger'">
        <xsl:value-of select="'alert-danger'"/>
      </xsl:when>
      <xsl:when test="$admonition-type = 'important'">
        <xsl:value-of select="'alert-warning'"/>
      </xsl:when>
      <xsl:when test="$admonition-type = 'note'">
        <xsl:value-of select="'alert-info'"/>
      </xsl:when>
      <xsl:when test="$admonition-type = 'tip'">
        <xsl:value-of select="'alert-info'"/>
      </xsl:when>
      <xsl:when test="$admonition-type = 'warning'">
        <xsl:value-of select="'alert-warning'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--
    It can either be a single-paragraph block (the title can be docbook-xsl’s default, or a custom one):

      <div class="note">
        <h3 class="title">Note</h3>
        <p>Body</p>
      </div>

    in which case we turn it into a single line as prefered by Bootstrap.
  -->
  <xsl:template match="x:div[(@class='caution' or @class = 'danger' or @class = 'important' or @class = 'note' or @class = 'tip' or @class = 'warning') and count(*) = 2]">
    <xsl:element name="div">
      <xsl:attribute name="class">alert <xsl:call-template name="alert-class"><xsl:with-param name="admonition-type" select="@class" /></xsl:call-template></xsl:attribute>
      <strong><xsl:apply-templates select="x:h3[@class='title']/node()" />:</strong><xsl:text> </xsl:text><xsl:apply-templates select="x:p/node()" />
    </xsl:element>
  </xsl:template>

  <!--
    Or there can be more elements, in which case we will switch it to “.alert-block” and
    change the heading size to h4 as expected by Bootstrap.
  -->
  <xsl:template match="x:div[(@class='caution' or @class = 'danger' or @class = 'important' or @class = 'note' or @class = 'tip' or @class = 'warning') and count(*) > 2]">
    <xsl:element name="div">
      <xsl:attribute name="class">alert <xsl:call-template name="alert-class"><xsl:with-param name="admonition-type" select="@class" /></xsl:call-template> alert-block</xsl:attribute>
      <h4><xsl:apply-templates select="x:h3[@class='title']/node()" /></h4>
      <xsl:apply-templates select="node()[not(self::x:h3[@class='title'])]" />
    </xsl:element>
  </xsl:template>


  <xsl:template match="x:table">
    <table class='table table-striped'>
      <xsl:apply-templates select="@*|node()" />
    </table>
  </xsl:template>

</xsl:stylesheet>
