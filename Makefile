ROOT = "/"

rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

default: all


HTML = index.html download.html news.html learn.html community.html \
  governance.html donate.html commercial-support.html features.html \
  teams/rfc-steering-committee.html teams/security.html teams/marketing.html \
  teams/nixos_release.html teams/infrastructure.html teams/nixcon.html \
  teams/discourse.html \
  guides/contributing.html guides/install-nix.html guides/ad-hoc-developer-environments.html \
  nixos/packages.html nixos/options.html \
  404.html


### Prettify the NixOS manual.

NIXOS_MANUAL_IN ?= /no-such-path
NIXOS_MANUAL_OUT = nixos/manual

all: $(NIXOS_MANUAL_OUT)

$(NIXOS_MANUAL_OUT): $(NIXOS_MANUAL_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIXOS_MANUAL_IN)/share/doc/nixos $(NIXOS_MANUAL_OUT) 'NixOS manual' nixos https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual


### Prettify the Nix Pills

NIX_PILLS_MANUAL_IN ?= /no-such-path
NIX_PILLS_MANUAL_OUT = nixos/nix-pills

all: $(NIX_PILLS_MANUAL_OUT)

$(NIX_PILLS_MANUAL_OUT): $(NIX_PILLS_MANUAL_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIX_PILLS_MANUAL_IN) $(NIX_PILLS_MANUAL_OUT) 'Nix Pills' nixos https://github.com/NixOS/nix-pills


### Prettify the nix.dev guides

NIX_DEV_MANUAL_IN ?= /no-such-path
NIX_DEV_MANUAL_OUT = nix-dev

all: $(NIX_DEV_MANUAL_OUT)

$(NIX_DEV_MANUAL_OUT): $(NIX_DEV_MANUAL_IN) bootstrapify-sphinx.sh layout.tt common.tt
	bash ./bootstrapify-sphinx.sh $(NIX_DEV_MANUAL_IN)/tutorials $(NIX_DEV_MANUAL_OUT) 'Nix guides' nixos https://github.com/domenkozar/nix.dev


### Prettify the Nix manual.

NIX_MANUAL_IN ?= /no-such-path
NIX_MANUAL_OUT = nix/manual

all: $(NIX_MANUAL_OUT)

$(NIX_MANUAL_OUT): $(call rwildcard, $(NIX_MANUAL_IN), *) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIX_MANUAL_IN) $(NIX_MANUAL_OUT) 'Nix manual' nix https://github.com/NixOS/nix/tree/master/doc/manual
	ln -sfn manual.html $(NIX_MANUAL_OUT)/index.html


### Prettify the Nixpkgs manual.

NIXPKGS_MANUAL_IN ?= /no-such-path
NIXPKGS_MANUAL_OUT = nixpkgs/manual

all: $(NIXPKGS_MANUAL_OUT)

$(NIXPKGS_MANUAL_OUT): $(NIXPKGS_MANUAL_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIXPKGS_MANUAL_IN)/share/doc/nixpkgs $(NIXPKGS_MANUAL_OUT) 'Nixpkgs manual' nixpkgs https://github.com/NixOS/nixpkgs/tree/master/doc
	ln -sfn manual.html $(NIXPKGS_MANUAL_OUT)/index.html


all: $(HTML) favicon.png favicon.ico robots.txt $(subst .png,-small.png,$(filter-out %-small.png,$(wildcard images/screenshots/*))) \
  nixos/packages-explorer.js \
  nixpkgs/packages-channels.json \
  nix-dev


robots.txt: $(HTML)
	echo "Users-agent: *" >> $@
	#echo "Disallow: /" >> $@
	#for page in $(HTML); do echo "Allow: /$$page" >> $@; done

favicon.png: logo/nixos-logo-only-hires.png
	convert -resize 16x16 -background none -gravity center -extent 16x16 $< $@

favicon.ico: favicon.png
	convert -resize x16 -gravity center -crop 16x16+0+0 -flatten -colors 256 -background transparent $< $@

%-small.png: %.png
	convert -resize 200 $< $@

%.html: %.tt layout.tt common.tt 
	tpage \
	  --pre_chomp --post_chomp \
	  --define root=$(ROOT) \
	  --define fileName=$< \
	  --define nixosAmis=$(NIXOS_AMIS) \
	  --define latestNixVersion=$(NIX_VERSION) \
	  --define latestNixOSSeries=$(NIXOS_SERIES) \
	  --pre_process=common.tt \
	  $< > $@.tmp
	xmllint --nonet --noout $@.tmp
	mv $@.tmp $@

%: %.in common.tt
	echo $$PATH
	tpage \
	  --define latestNixVersion=$(NIX_VERSION) \
	  --pre_process=common.tt $< > $@.tmp
	mv $@.tmp $@

news.html: all-news.xhtml

all-news.xhtml: news.xml news.xsl
	xsltproc --param maxItem 10000 news.xsl news.xml > $@ || rm -f $@

news-rss.xml: news.xml news-rss.xsl
	xsltproc news-rss.xsl news.xml > $@.tmp
	mv $@.tmp $@

index.html: news-rss.xml latest-news.xhtml blogs.json

latest-news.xhtml: news.xml news.xsl
	xsltproc --param maxItem 12 news.xsl news.xml > $@ || rm -f $@

check:
	checklink $(HTML)

blogs.xml:
	curl --fail https://planet.nixos.org/rss20.xml > $@.tmp
	mv $@.tmp $@

blogs.json: blogs.xml
	perl -MJSON -MXML::Simple -e 'print encode_json(XMLin("blogs.xml"));' < $< > $@.tmp
	mv $@.tmp $@

ifeq ($(UPDATE), 1)
.PHONY: blogs.xml
update: blogs.xml
	@true
endif


# Cute hack, this allows future expansion if desired
# Mainly, this allows tracking NIXOS_SERIES
nixpkgs/packages-channels.json: Makefile
	echo '["nixos-$(NIXOS_SERIES)", "nixpkgs-unstable"]' > $@

nixos/packages-explorer.js:
	@ln -sfn $(PACKAGES_EXPLORER) $@

all: demo.cast

demo.cast: demo.py demo.scenario
	python demo.py demo.scenario > demo.cast
