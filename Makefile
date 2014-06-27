HTML = index.html news.html \
  nix/index.html nix/about.html nix/download.html nix/docs.html \
  nixpkgs/index.html nixpkgs/download.html nixpkgs/docs.html \
  nixos/about.html nixos/download.html nixos/manual/index.html nixos/help.html nixos/community.html nixos/packages.html \
  nixos/screenshots.html \
  patchelf.html hydra/index.html \
  disnix/index.html disnix/download.html disnix/docs.html \
  disnix/extensions.html disnix/examples.html disnix/support.html \
  docs/papers.html \
  nixops/index.html \
  nixpkgs/packages.json.gz

all: $(HTML) favicon.png $(subst .png,-small.png,$(filter-out %-small.png,$(wildcard nixos/screenshots/*)))

favicon.png: logo/nixos-logo-only-hires.png
	convert -adaptive-resize 16x16! $< $@

%-small.png: %.png
	convert -resize 200 $< $@

docs/papers-in.html: docs/papers.xml docs/bib2html.xsl
	xsltproc docs/bib2html.xsl docs/papers.xml > $@ || rm $@

docs/papers.html: docs/papers-in.html

%.html: %.tt layout.tt common.tt
	tpage \
	  --pre_chomp --post_chomp \
	  --define curUri=$@ \
	  --define modifiedAt="`git log -1 --pretty='%ai' $<`" \
	  --define modifiedBy="`git log -1 --pretty='%an' $<`" \
	  --define curRev="`git log -1 --pretty='%h' $<`" \
	  --define root=`echo $@ | sed -e 's|[^/]||g' -e 's|/|../|g'` \
	  --define fileName=$< \
	  --pre_process=common.tt $< > $@.tmp
	xmllint --nonet --noout $@.tmp
	mv $@.tmp $@

news.html: all-news.xhtml

all-news.xhtml: news.xml news.xsl
	xsltproc --param maxItem 10000 news.xsl news.xml > $@ || rm -f $@

index.html: latest-news.xhtml nixpkgs-commits.json nixpkgs-commit-stats.json blogs.json

nixos/download.html: nixos/amis.tt

latest-news.xhtml: news.xml news.xsl
	xsltproc --param maxItem 12 news.xsl news.xml > $@ || rm -f $@

check:
	checklink $(HTML)

nixos/amis.tt: nixos/amis.nix
	latest=$$(sed 's/.*latestNixOSVersion.*"\(.*\)".*/\1/; t; d' common.tt); \
	(echo "[% amis => {"; < $< sed 's/.*'$$latest'.*"\(.*\)"\.ebs.*"\(.*\)".*/  "\1" => \"\2\"/; t; d'; echo "} %]") > $@

nixos/amis.nix:
	curl --fail -L https://raw.github.com/NixOS/nixops/master/nix/ec2-amis.nix > $@.tmp
	mv $@.tmp $@

nixpkgs-commits.json:
	curl --fail https://api.github.com/repos/NixOS/nixpkgs/commits > $@.tmp
	mv $@.tmp $@

nixpkgs-commit-stats.json:
	curl --fail https://api.github.com/repos/NixOS/nixpkgs/stats/participation > $@.tmp
	mv $@.tmp $@

blogs.xml:
	curl --fail http://planet.nixos.org/rss20.xml > $@.tmp
	mv $@.tmp $@

blogs.json: blogs.xml
	perl -MJSON -MXML::Simple -e 'print encode_json(XMLin("blogs.xml"));' < $< > $@.tmp
	mv $@.tmp $@

ifeq ($(UPDATE), 1)
.PHONY: nixos/amis.nix nixpkgs-commits.json nixpkgs-commit-stats.json blogs.xml nixpkgs/packages.json.gz
endif

nixpkgs/packages.json.gz:
	nix-env -f '<nixpkgs>' -qa --json --arg config '{}' \
	  | sed "s|$$(nix-instantiate --find-file nixpkgs)/||g" | gzip -9 > $@.tmp
	gunzip < $@.tmp | python -mjson.tool > /dev/null
	mv $@.tmp $@

nixos/manual/index.html: nixos/manual/manual.html.incl

nixos/manual/manual.html.incl: nixos/manual/manual.html strip-docbook.xsl
	xsltproc --nonet strip-docbook.xsl $< > $@.tmp
	mv $@.tmp $@
