tpage = /nix/var/nix/profiles/per-user/eelco/hydra-deps/bin/tpage
catalog = $(HOME)/.nix-profile/xml/dtd/xhtml1/catalog.xml

HTML = index.html news.html \
  nix/index.html nix/download.html \
  nixpkgs/index.html nixpkgs/download.html nixpkgs/docs.html \
  nixos/index.html nixos/download.html nixos/docs.html nixos/development.html \
  nixos/screenshots.html \
  patchelf.html hydra/index.html \
  developers/index.html \
  docs/papers.html \
  about-us.html

all: $(HTML)

docs/papers-in.html: docs/papers.xml docs/bib2html.xsl
	xsltproc docs/bib2html.xsl docs/papers.xml > docs/papers-in.html || rm docs/papers-in.html

%.html: %.tt layout.tt
	$(tpage) --define curUri=$@ --define root=`echo $@ | sed -e 's|[^/]||g' -e 's|/|../|g'` $< > $@ && \
	XML_CATALOG_FILES=$(catalog) xmllint --nonet --noout --valid $@ || \
	(rm -f $@ && exit 1)

news.html: all-news.xhtml

docs/papers.html: docs/papers-in.html

all-news.xhtml: news.xml news.xsl
	xsltproc --param maxItem 10000 news.xsl news.xml > $@ || rm -f $@

index.html: latest-news.xhtml

latest-news.xhtml: news.xml news.xsl
	xsltproc --param maxItem 5 news.xsl news.xml > $@ || rm -f $@

check:
	checklink $(HTML)
