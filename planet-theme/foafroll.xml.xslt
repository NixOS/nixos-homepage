<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	        xmlns:foaf="http://xmlns.com/foaf/0.1/"
	        xmlns:rss="http://purl.org/rss/1.0/"
	        xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:planet="http://planet.intertwingly.net/"
                exclude-result-prefixes="atom planet">
 
  <xsl:output indent="yes" method="xml"/>

  <xsl:template match="atom:feed">
    <rdf:RDF>
      <foaf:Group>
        <foaf:name><xsl:value-of select="atom:author/atom:name"/></foaf:name>
        <foaf:homepage><xsl:value-of select="atom:author/atom:uri"/></foaf:homepage>

        <xsl:apply-templates select="planet:source"/>
      </foaf:Group>
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="planet:source">
    <foaf:member>
      <foaf:Agent>
        <foaf:name><xsl:value-of select="planet:name"/></foaf:name>
        <foaf:weblog>
          <foaf:Document rdf:about="{atom:link[@rel='alternate']/@href}">
            <dc:title><xsl:value-of select="atom:title"/></dc:title>
            <rdfs:seeAlso>
              <rss:channel rdf:about="{atom:link[@rel='self']/@href}" />
            </rdfs:seeAlso>
          </foaf:Document>
        </foaf:weblog>
      </foaf:Agent>
    </foaf:member>
  </xsl:template>
</xsl:stylesheet>
