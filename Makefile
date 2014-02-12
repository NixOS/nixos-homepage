tpage = tpage
catalog = $(HOME)/.nix-profile/xml/dtd/xhtml1/catalog.xml

HTML = index.html news.html \
  nix/index.html nix/download.html nix/docs.html \
  nixpkgs/index.html nixpkgs/download.html nixpkgs/docs.html \
  nixos/index.html nixos/download.html nixos/docs.html \
  nixos/screenshots.html nixos/support.html \
  patchelf.html hydra/index.html \
  disnix/index.html disnix/download.html disnix/docs.html \
  disnix/extensions.html disnix/examples.html disnix/support.html \
  development/index.html \
  docs/papers.html \
  about-us.html \
  nixops/index.html

all: $(HTML) favicon.png $(subst .png,-small.png,$(filter-out %-small.png,$(wildcard nixos/screenshots/*)))

favicon.png: logo/nixos-logo-only-hires.png
	convert -adaptive-resize 16x16! $< $@

%-small.png: %.png
	convert -resize 200 $< $@

docs/papers-in.html: docs/papers.xml docs/bib2html.xsl
	xsltproc docs/bib2html.xsl docs/papers.xml > $@ || rm $@

docs/papers.html: docs/papers-in.html

nixos/papers-in.html: docs/papers.xml docs/bib2html.xsl
	xsltproc --stringparam tag nixos docs/bib2html.xsl docs/papers.xml > $@ || rm $@

nix/papers-in.html: docs/papers.xml docs/bib2html.xsl
	xsltproc --stringparam tag nix docs/bib2html.xsl docs/papers.xml > $@ || rm $@

nixos/docs.html: nixos/papers-in.html

nix/docs.html: nix/papers-in.html

%.html: %.tt layout.tt common.tt nixos/amis.tt
	$(tpage) \
	  --define curUri=$@ \
	  --define modifiedAt="`git log -1 --pretty='%ai' $<`" \
	  --define modifiedBy="`git log -1 --pretty='%an' $<`" \
	  --define curRev="`git log -1 --pretty='%h' $<`" \
	  --define root=`echo $@ | sed -e 's|[^/]||g' -e 's|/|../|g'` $< > $@.tmp
	xmllint --nonet --noout $@.tmp
	mv $@.tmp $@

news.html: all-news.xhtml

all-news.xhtml: news.xml news.xsl
	xsltproc --param maxItem 10000 news.xsl news.xml > $@ || rm -f $@

index.html: latest-news.xhtml nixpkgs-commits.json blogs.json

latest-news.xhtml: news.xml news.xsl
	xsltproc --param maxItem 5 news.xsl news.xml > $@ || rm -f $@

check:
	checklink $(HTML)

nixos/amis.tt: nixos/amis.nix
	(echo "[% amis => {"; < $< sed 's/.*"\(.*\)"\.ebs.*"\(.*\)".*/  "\1" => \"\2\"/; t; d'; echo "} %]") > $@

nixos/amis.nix:
	curl https://raw.github.com/NixOS/nixops/master/nix/ec2-amis.nix > $@.tmp
	mv $@.tmp $@

nixpkgs-commits.json:
	curl https://api.github.com/repos/NixOS/nixpkgs/commits > $@.tmp
	mv $@.tmp $@

blogs.xml:
	curl http://planet.nixos.org/rss20.xml > $@.tmp
	mv $@.tmp $@

blogs.json: blogs.xml
	perl -MJSON -MXML::Simple -e 'print encode_json(XMLin("blogs.xml"));' < $< > $@.tmp
	mv $@.tmp $@
