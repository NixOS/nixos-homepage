HTML = index.html news.html

all: $(HTML)

check: all
	xmllint --noout --valid $(HTML)

%.html: %-in.html add-navbar.xsl news.xml
	xsltproc --xinclude \
	    --stringparam fileName "$@" \
	    --stringparam toTop "$$(for i in $$(seq 1 $$(echo -n $< | sed 's|[^/]||g' | wc -c)); do echo -n ../; done)" \
	    --nonet --novalid add-navbar.xsl $< > $@ || rm $@
