HTML = index.html about.html news.html docs/papers.html \
  nixpkgs.html

all: $(HTML)

check: all
	xmllint --noout --valid $(HTML)

%.html: %-in.html add-navbar.xsl news.xml
	xsltproc --xinclude \
	    --stringparam fileName "$@" \
	    --novalid add-navbar.xsl $< > $@ || rm $@

docs/papers-in.html: docs/papers.xml docs/bib2html.xsl lib.xsl
	xsltproc docs/bib2html.xsl docs/papers.xml > docs/papers-in.html || rm docs/papers-in.html

