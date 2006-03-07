HTML = index.html about.html news.html

all: $(HTML)

check: all
	xmllint --noout --valid $(HTML)

%.html: %-in.html add-navbar.xsl news.xml
	xsltproc --xinclude \
	    --stringparam fileName "$@" \
	    --novalid add-navbar.xsl $< > $@ || rm $@
