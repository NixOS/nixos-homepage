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
  explore.html \
  governance.html \
  guides/deploying-nixos-using-terraform.html \
  guides/ad-hoc-developer-environments.html \
  guides/building-and-running-docker-images.html \
  guides/continuous-integration-github-actions.html \
  guides/contributing.html \
  guides/declarative-and-reproducible-developer-environments.html \
  guides/dev-environment.html \
  guides/how-nix-works.html \
  guides/install-nix.html \
  guides/towards-reproducibility-pinning-nixpkgs.html \
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

DEMOS = \
  demos/cover.svg \
  demos/example_1.svg \
  demos/example_2.svg \
  demos/example_3.svg \
  demos/example_4.svg \
  demos/example_5.svg \
  demos/example_6.svg


NIX_DEV_MANUAL_IN ?= /no-such-path
NIX_DEV_MANUAL_OUT = guides

all: $(NIX_DEV_MANUAL_OUT) learn_guides.html.in

$(NIX_DEV_MANUAL_OUT) learn_guides.html.in: $(NIX_DEV_MANUAL_IN) layout.tt copy-nix-dev-tutorials.sh
	bash copy-nix-dev-tutorials.sh $(NIX_DEV_MANUAL_OUT)


### Prettify the Nix Pills

NIX_PILLS_MANUAL_IN ?= /no-such-path
NIX_PILLS_MANUAL_OUT = guides/nix-pills

all: $(NIX_PILLS_MANUAL_OUT)

$(NIX_PILLS_MANUAL_OUT): $(NIX_PILLS_MANUAL_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIX_PILLS_MANUAL_IN) $(NIX_PILLS_MANUAL_OUT) 'Nix Pills' nixos https://github.com/NixOS/nix-pills


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


all: $(HTML) favicon.png favicon.ico robots.txt \
	styles \
	$(subst .png,-small.png,$(filter-out %-small.png,$(wildcard images/screenshots/*)))


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

%.html: %.tt layout.tt common.tt $(DEMOS) $(NIX_DEV_MANUAL_OUT) learn_guides.html.in
	tpage \
	  --pre_chomp --post_chomp \
	  --eval_perl \
	  --define root=$(ROOT) \
	  --define fileName=$< \
	  --define outputName=$@ \
	  --define nixosAmis=$(NIXOS_AMIS) \
	  --define latestNixVersion=$(NIX_STABLE_VERSION) \
	  --define latestNixOSSeries=$(NIXOS_STABLE_SERIES) \
	  --pre_process=common.tt \
	  $< > $@.tmp
	xmllint --nonet --noout $@.tmp
	mv $@.tmp $@

%: %.in common.tt $(NIX_DEV_MANUAL_OUT) learn_guides.html.in
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

index.html: $(DEMOS) news-rss.xml latest-news.xhtml blogs.json 

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

# The nix-built site will use the provided SITE_STYLES
ifeq ($(strip $(SITE_STYLES)),)
# But development `make` builds will nix-build.
styles: $(wildcard site-styles/*)
	nix-build -A packages.x86_64-linux.siteStyles --fallback --out-link $@
else
styles:
	@ln -sfn $(SITE_STYLES) $@
endif

all: manuals

manuals:
	bash ./fix-manual-headers.sh manual/nix stable
	bash ./fix-manual-headers.sh manual/nixpkgs stable
	bash ./fix-manual-headers.sh manual/nixos stable

all: $(DEMOS)

demos/%.svg: demos/%.scenario
	echo "Generating $@ and $(patsubst %.svg,%.cast,$@) ..."
	asciinema-scenario --preview-file "$@" $< > $(patsubst %.svg,%.cast,$@)
	# XXX: this in until asciinema-scenario is fixed
	#      https://github.com/garbas/asciinema-scenario/issues/3
	sed -i -e "s|<nixpkgs|\&lt;nixpkgs|g" $@
