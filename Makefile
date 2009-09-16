tpage = /nix/var/nix/profiles/per-user/eelco/hydra-deps/bin/tpage
catalog = $(HOME)/.nix-profile/xml/dtd/xhtml1/catalog.xml

#HTML = index.html about.html news.html docs/papers.html \
#  nixpkgs.html nixos/index.html patchelf.html people.html

HTML = test.html patchelf.html about.html \
  nixos/about.html nixos/download.html

all: $(HTML)

#check: all
#	xmllint --noout --valid $(HTML)

#%.html: %-in.html add-navbar.xsl news.xml
#	xsltproc --xinclude \
#	    --stringparam fileName "$@" \
#	    --novalid add-navbar.xsl $< > $@ || rm $@

docs/papers-in.html: docs/papers.xml docs/bib2html.xsl lib.xsl
	xsltproc docs/bib2html.xsl docs/papers.xml > docs/papers-in.html || rm docs/papers-in.html

%.html: %.tt layout.tt navbar.tt
	$(tpage) --define curUri=$@ --define root=`echo $@ | sed -e 's|[^/]||g' -e 's|/|../|g'` $< > $@ && \
	XML_CATALOG_FILES=$(catalog) xmllint --nonet --noout --valid $@ || \
	(rm -f $@ && exit 1)
