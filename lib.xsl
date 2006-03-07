<?xml version="1.0"?>

<xsl:transform
  version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sets="http://exslt.org/sets"
  xmlns:exsl="http://exslt.org/common"
  extension-element-prefixes="exsl sets">

  <xsl:template name="emitToggleScripts">
    <script type="text/javascript">
<![CDATA[
function toggleVisById(id) {
    toggleVis(document.getElementById(id));
}

function toggleVis(elem) {
    if (elem.style.display == 'none') {
        elem.style.display = 'block';
    } else {
        elem.style.display = 'none';
    }
}

function showAll(tag, class, show) {
    var elems = document.getElementsByTagName(tag);
    for (var i = 0; i != elems.length; i++) {
        var elem = elems[i];
        if (elem.getAttribute("class") == class) {
            if (show) 
                elem.style.display = 'block';
            else
                elem.style.display = 'none';
        }
    }
}

function toggleAll(show) {
    showAll("div", "abstract", show);
    toggleVisById("showAllAbstracts");
    toggleVisById("hideAllAbstracts");
}
]]>
    </script>
  </xsl:template>

  <xsl:template name="emitMainToggle">
    <xsl:if test="//abstract">
      <p id="showAllAbstracts"><a href="javascript:toggleAll(true)">[Show all abstracts]</a></p>
      <p id="hideAllAbstracts" style="display: none;"><a href="javascript:toggleAll(false)">[Hide all abstracts]</a></p>
    </xsl:if>
  </xsl:template>
  

  <xsl:template match="abstract">
    
    <xsl:variable name="id" select="generate-id()" />
      
    [<a href="javascript:toggleVisById(&quot;{$id}&quot;)">abstract</a>]
      
    <div class="abstract" id="{$id}" style="display: none;">
      <xsl:choose>
        <xsl:when test="p">
          <em>Abstract: </em>
          <xsl:copy-of select="p[position() = 1]/child::node()" />
          <xsl:for-each select="p[position() > 1]">
            <div class="newpara" />
            <xsl:copy-of select="child::node()" />
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <em>Abstract: </em>
          <xsl:copy-of select="child::node()" />
        </xsl:otherwise>
      </xsl:choose>
    </div>

  </xsl:template>

  
  <xsl:template match="link" >
    [<a href="{@url}"><xsl:value-of select="@type" /></a>]
  </xsl:template>


  <xsl:template mode="maybeLink" match="*">
    <xsl:choose>
      <xsl:when test="@url">
        <a href="{@url}">
          <xsl:copy-of select="child::node()" />
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="child::node()" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
</xsl:transform>