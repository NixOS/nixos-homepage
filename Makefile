ROOT = "/"

rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

default: all


HTML = \
  404.html \
  commercial-support.html \
  community.html \
  demos/index.html \
  donate.html \
  download.html \
  features.html \
  governance.html \
  guides/ad-hoc-developer-environments.html \
  guides/contributing.html \
  guides/install-nix.html \
  index.html \
  learn.html \
  news.html \
  teams/discourse.html \
  teams/infrastructure.html \
  teams/marketing.html \
  teams/nixcon.html \
  teams/nixos_release.html \
  teams/rfc-steering-committee.html \
  teams/security.html


### Prettify the Nix Pills

NIX_PILLS_MANUAL_IN ?= /no-such-path
NIX_PILLS_MANUAL_OUT = guides/nix-pills

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

NIX_MANUAL_STABLE_IN ?= /no-such-path
NIX_MANUAL_STABLE_OUT = manual/nix/stable

all: $(NIX_MANUAL_STABLE_OUT)

$(NIX_MANUAL_STABLE_OUT): $(call rwildcard, $(NIX_MANUAL_STABLE_IN), *) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIX_MANUAL_STABLE_IN) $(NIX_MANUAL_STABLE_OUT) 'Nix $(NIX_STABLE_VERSION) manual' nix https://github.com/NixOS/nix/tree/master/doc/manual

NIX_MANUAL_UNSTABLE_IN ?= /no-such-path
NIX_MANUAL_UNSTABLE_OUT = manual/nix/unstable

all: $(NIX_MANUAL_UNSTABLE_OUT)

$(NIX_MANUAL_UNSTABLE_OUT): $(call rwildcard, $(NIX_MANUAL_UNSTABLE_IN), *) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	mkdir -p $(NIX_MANUAL_UNSTABLE_OUT)
	cp --no-preserve=mode,ownership -RL $(NIX_MANUAL_UNSTABLE_IN)/* $(NIX_MANUAL_UNSTABLE_OUT)


### Prettify the Nixpkgs manual.

NIXPKGS_MANUAL_STABLE_IN ?= /no-such-path
NIXPKGS_MANUAL_STABLE_OUT = manual/nixpkgs/stable

all: $(NIXPKGS_MANUAL_STABLE_OUT)

$(NIXPKGS_MANUAL_STABLE_OUT): $(NIXPKGS_MANUAL_STABLE_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIXPKGS_MANUAL_STABLE_IN)/share/doc/nixpkgs $(NIXPKGS_MANUAL_STABLE_OUT) 'Nixpkgs $(NIXOS_STABLE_SERIES) manual' nixpkgs https://github.com/NixOS/nixpkgs/tree/master/doc

NIXPKGS_MANUAL_UNSTABLE_IN ?= /no-such-path
NIXPKGS_MANUAL_UNSTABLE_OUT = manual/nixpkgs/unstable

all: $(NIXPKGS_MANUAL_UNSTABLE_OUT)

$(NIXPKGS_MANUAL_UNSTABLE_OUT): $(NIXPKGS_MANUAL_UNSTABLE_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIXPKGS_MANUAL_UNSTABLE_IN)/share/doc/nixpkgs $(NIXPKGS_MANUAL_UNSTABLE_OUT) 'Nixpkgs $(NIXOS_UNSTABLE_SERIES) manual' nixpkgs https://github.com/NixOS/nixpkgs/tree/master/doc


### Prettify the NixOS manual.

NIXOS_MANUAL_STABLE_IN ?= /no-such-path
NIXOS_MANUAL_STABLE_OUT = manual/nixos/stable

all: $(NIXOS_MANUAL_STABLE_OUT)

$(NIXOS_MANUAL_STABLE_OUT): $(NIXOS_MANUAL_STABLE_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIXOS_MANUAL_STABLE_IN)/share/doc/nixos $(NIXOS_MANUAL_STABLE_OUT) 'NixOS $(NIXOS_STABLE_SERIES) manual' nixos https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual

NIXOS_MANUAL_UNSTABLE_IN ?= /no-such-path
NIXOS_MANUAL_UNSTABLE_OUT = manual/nixos/unstable

all: $(NIXOS_MANUAL_UNSTABLE_OUT)

$(NIXOS_MANUAL_UNSTABLE_OUT): $(NIXOS_MANUAL_UNSTABLE_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIXOS_MANUAL_UNSTABLE_IN)/share/doc/nixos $(NIXOS_MANUAL_UNSTABLE_OUT) 'NixOS $(NIXOS_UNSTABLE_SERIES) manual' nixos https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual


all: $(HTML) favicon.png favicon.ico robots.txt $(subst .png,-small.png,$(filter-out %-small.png,$(wildcard images/screenshots/*))) nix-dev


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
	  --define latestNixVersion=$(NIX_STABLE_VERSION) \
	  --define latestNixOSSeries=$(NIXOS_STABLE_SERIES) \
	  --pre_process=common.tt \
	  $< > $@.tmp
	xmllint --nonet --noout $@.tmp
	mv $@.tmp $@

%: %.in common.tt
	echo $$PATH
	tpage \
	  --define latestNixVersion=$(NIX_STABLE_VERSION) \
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

check: $(HTML)
	bash check-links.sh

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

all: manuals

manuals:
	bash ./fix-manual-headers.sh manual/nix stable
	bash ./fix-manual-headers.sh manual/nixpkgs stable
	bash ./fix-manual-headers.sh manual/nixos stable

all: \
  demos/cover.cast \
  demos/example_1.cast \
  demos/example_2.cast \
  demos/example_3.cast \
  demos/example_4.cast \
  demos/example_5.cast

demos/%.cast: demos/%.scenario demos/create.py 
	echo "Generating $@ ..."
	python demos/create.py $< > $@
