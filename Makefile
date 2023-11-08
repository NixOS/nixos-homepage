ROOT = "/"

rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

default: all


HTML = \
  404.html \
  blog/stories.html \
  blog/announcements.html \
  blog/categories.html \
  blog/index.html \
  community/event-funding.html \
  community/commercial-support.html \
  community/index.html \
  community/teams/moderation.html \
  community/teams/infrastructure.html \
  community/teams/marketing.html \
  community/teams/nixcon.html \
  community/teams/nixos-release.html \
  community/teams/rfc-steering-committee.html \
  community/teams/security.html \
  community/teams/documentation.html \
  community/teams/nixpkgs-architecture.html \
  community/teams/nix.html \
  community/teams/cuda.html \
  community/teams/foundation-board.html \
  demos/index.html \
  donate.html \
  download.html \
  explore.html \
  guides/how-nix-works.html \
  index.html \
  learn.html

DEMOS = \
  demos/cover.svg \
  demos/example_1.svg \
  demos/example_2.svg \
  demos/example_3.svg \
  demos/example_4.svg \
  demos/example_5.svg \
  demos/example_6.svg


### Prettify the Nix Pills

NIX_PILLS_MANUAL_IN ?= /no-such-path
NIX_PILLS_MANUAL_OUT = guides/nix-pills

all: $(NIX_PILLS_MANUAL_OUT)

$(NIX_PILLS_MANUAL_OUT): $(NIX_PILLS_MANUAL_IN) scripts/bootstrapify-docbook.sh scripts/bootstrapify-docbook.xsl layout.tt common.tt
	bash ./scripts/bootstrapify-docbook.sh $(NIX_PILLS_MANUAL_IN) $(NIX_PILLS_MANUAL_OUT) 'Nix Pills' nixos https://github.com/NixOS/nix-pills

### Copy Nix pills EPUB

NIX_PILLS_MANUAL_EPUB ?= /no-such-path
NIX_PILLS_MANUAL_EPUB_OUT = $(NIX_PILLS_MANUAL_OUT)/nix-pills.epub

all: $(NIX_PILLS_MANUAL_EPUB_OUT)

$(NIX_PILLS_MANUAL_EPUB_OUT): $(NIX_PILLS_MANUAL_EPUB)
	mkdir -p "$(NIX_PILLS_MANUAL_OUT)"
	cp --no-preserve=mode,ownership -L "$(NIX_PILLS_MANUAL_EPUB)" $@

### Prettify the Nix manual.

NIX_MANUAL_STABLE_IN ?= /no-such-path
NIX_MANUAL_STABLE_OUT = manual/nix/stable

$(NIX_MANUAL_STABLE_OUT): $(call rwildcard, $(NIX_MANUAL_STABLE_IN), *)
	mkdir -p $(NIX_MANUAL_STABLE_OUT)
	cp --no-preserve=mode,ownership -RL $(NIX_MANUAL_STABLE_IN)/* $(NIX_MANUAL_STABLE_OUT)

NIX_MANUAL_UNSTABLE_IN ?= /no-such-path
NIX_MANUAL_UNSTABLE_OUT = manual/nix/unstable

$(NIX_MANUAL_UNSTABLE_OUT): $(call rwildcard, $(NIX_MANUAL_UNSTABLE_IN), *)
	mkdir -p $(NIX_MANUAL_UNSTABLE_OUT)
	cp --no-preserve=mode,ownership -RL $(NIX_MANUAL_UNSTABLE_IN)/* $(NIX_MANUAL_UNSTABLE_OUT)

manual/nix/index.html: $(NIX_MANUAL_STABLE_OUT) $(NIX_MANUAL_UNSTABLE_OUT)
	bash ./scripts/fix-manual-headers.sh manual/nix stable
	@echo "<!DOCTYPE html>" > $@
	@echo "<html>" >> $@
	@echo "  <head>" >> $@
	@echo "    <meta http-equiv=\"refresh\" content=\"7; url='stable/index.html'\" />" >> $@
	@echo "  </head>" >> $@
	@echo "  <body>" >> $@
	@echo "    <h1>Redirecting...</h1>" >> $@
	@echo "    <p>Please follow <a href=\"stable/index.html\">this link</a>.</p>" >> $@
	@echo "  </body>" >> $@
	@echo "</html>" >> $@

all: manual/nix/index.html

### Prettify the Nixpkgs manual.

NIXPKGS_MANUAL_STABLE_IN ?= /no-such-path
NIXPKGS_MANUAL_STABLE_OUT = manual/nixpkgs/stable

$(NIXPKGS_MANUAL_STABLE_OUT): $(NIXPKGS_MANUAL_STABLE_IN) scripts/bootstrapify-docbook.sh scripts/bootstrapify-docbook.xsl layout.tt common.tt
	bash ./scripts/bootstrapify-docbook.sh $(NIXPKGS_MANUAL_STABLE_IN)/share/doc/nixpkgs $(NIXPKGS_MANUAL_STABLE_OUT) 'Nixpkgs $(NIXOS_STABLE_SERIES) manual' nixpkgs https://github.com/NixOS/nixpkgs/tree/master/doc

NIXPKGS_MANUAL_UNSTABLE_IN ?= /no-such-path
NIXPKGS_MANUAL_UNSTABLE_OUT = manual/nixpkgs/unstable

$(NIXPKGS_MANUAL_UNSTABLE_OUT): $(NIXPKGS_MANUAL_UNSTABLE_IN) scripts/bootstrapify-docbook.sh scripts/bootstrapify-docbook.xsl layout.tt common.tt
	bash ./scripts/bootstrapify-docbook.sh $(NIXPKGS_MANUAL_UNSTABLE_IN)/share/doc/nixpkgs $(NIXPKGS_MANUAL_UNSTABLE_OUT) 'Nixpkgs $(NIXOS_UNSTABLE_SERIES) manual' nixpkgs https://github.com/NixOS/nixpkgs/tree/master/doc

manual/nixpkgs/index.html: $(NIXPKGS_MANUAL_STABLE_OUT) $(NIXPKGS_MANUAL_UNSTABLE_OUT)
	bash ./scripts/fix-manual-headers.sh manual/nixpkgs stable
	@echo "<!DOCTYPE html>" > $@
	@echo "<html>" >> $@
	@echo "  <head>" >> $@
	@echo "    <meta http-equiv=\"refresh\" content=\"7; url='stable/index.html'\" />" >> $@
	@echo "  </head>" >> $@
	@echo "  <body>" >> $@
	@echo "    <h1>Redirecting...</h1>" >> $@
	@echo "    <p>Please follow <a href=\"stable/index.html\">this link</a>.</p>" >> $@
	@echo "  </body>" >> $@
	@echo "</html>" >> $@

all: manual/nixpkgs/index.html


### Prettify the NixOS manual.

NIXOS_MANUAL_STABLE_IN ?= /no-such-path
NIXOS_MANUAL_STABLE_OUT = manual/nixos/stable

$(NIXOS_MANUAL_STABLE_OUT): $(NIXOS_MANUAL_STABLE_IN) scripts/bootstrapify-docbook.sh scripts/bootstrapify-docbook.xsl layout.tt common.tt
	bash ./scripts/bootstrapify-docbook.sh $(NIXOS_MANUAL_STABLE_IN)/share/doc/nixos $(NIXOS_MANUAL_STABLE_OUT) 'NixOS $(NIXOS_STABLE_SERIES) manual' nixos https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual

NIXOS_MANUAL_UNSTABLE_IN ?= /no-such-path
NIXOS_MANUAL_UNSTABLE_OUT = manual/nixos/unstable

$(NIXOS_MANUAL_UNSTABLE_OUT): $(NIXOS_MANUAL_UNSTABLE_IN) scripts/bootstrapify-docbook.sh scripts/bootstrapify-docbook.xsl layout.tt common.tt
	bash ./scripts/bootstrapify-docbook.sh $(NIXOS_MANUAL_UNSTABLE_IN)/share/doc/nixos $(NIXOS_MANUAL_UNSTABLE_OUT) 'NixOS $(NIXOS_UNSTABLE_SERIES) manual' nixos https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual

manual/nixos/index.html: $(NIXOS_MANUAL_STABLE_OUT) $(NIXOS_MANUAL_UNSTABLE_OUT)
	bash ./scripts/fix-manual-headers.sh manual/nixos stable
	@echo "<!DOCTYPE html>" > $@
	@echo "<html>" >> $@
	@echo "  <head>" >> $@
	@echo "    <meta http-equiv=\"refresh\" content=\"7; url='stable/index.html'\" />" >> $@
	@echo "  </head>" >> $@
	@echo "  <body>" >> $@
	@echo "    <h1>Redirecting...</h1>" >> $@
	@echo "    <p>Please follow <a href=\"stable/index.html\">this link</a>.</p>" >> $@
	@echo "  </body>" >> $@
	@echo "</html>" >> $@

all: manual/nixos/index.html


### Non HTML files (images/icons/etc...)

all: $(HTML) favicon.png favicon.ico robots.txt \
	$(subst .png,-small.png,$(filter-out %-small.png,$(wildcard images/screenshots/*)))


robots.txt: $(HTML)
	echo "User-agent: *" >> $@
	#echo "Disallow: /" >> $@
	#for page in $(HTML); do echo "Allow: /$$page" >> $@; done

favicon.png: logo/nixos-logo-only-hires.png
	convert -resize 16x16 -background none -gravity center -extent 16x16 $< $@

favicon.ico: favicon.png
	convert -resize x16 -gravity center -crop 16x16+0+0 -flatten -colors 256 -background transparent $< $@

%-small.png: %.png
	convert -resize 200 $< $@

%.html: %.tt layout.tt common.tt
	perl `which tpage` \
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

%: %.in common.tt
	echo $$PATH
	perl `which tpage` \
	  --define latestNixVersion=$(NIX_STABLE_VERSION) \
	  --pre_process=common.tt $< > $@.tmp
	mv $@.tmp $@

#
# -- /blog section -----------------------------------------------------------
#

blog/announcements-rss.xml: blog/announcements.xml blog/announcements-rss.xsl
	xsltproc blog/announcements-rss.xsl blog/announcements.xml > $@.tmp
	mv $@.tmp $@

blog/announcements.html: blog/announcements.html.in blog/layout.tt

blog/announcements.html.in: blog/announcements-rss.xml blog/announcements.xml blog/announcements.xsl
	xsltproc --param maxItem 10000 blog/announcements.xsl blog/announcements.xml > $@.tmp
	mv $@.tmp $@

blog/stories-rss.xml: blog/stories.xml blog/stories-rss.xsl
	xsltproc blog/stories-rss.xsl blog/stories.xml > $@.tmp
	mv $@.tmp $@

blog/stories.html: blog/stories.html.in blog/layout.tt

blog/stories.html.in: blog/stories-rss.xml blog/stories.xml blog/stories.xsl
	xsltproc --param maxItem 10000 blog/stories.xsl blog/stories.xml > $@.tmp
	mv $@.tmp $@

blog/index.html: blog/layout.tt

blog/categories.html: blog/layout.tt

index.html: blog/announcements-rss.xml blog/index.html


### Check

check: all
	bash ./scripts/check-links.sh



### Styles (css/svg/...)


SITE_STYLES_LESS := $(wildcard site-styles/*.less) $(wildcard site-styles/**/*.less)

STYLES = \
	styles/fonts/*.ttf \
	styles/blog.css \
	styles/community.css \
	styles/index.css

tmp.svg.less: $(wildcard site-styles/assets/*)
	embed-svg site-styles/assets tmp.svg.less

tmp.styles: tmp.svg.less $(SITE_STYLES_LESS)
	rm -rf tmp.styles

	mkdir -p tmp.styles
	cp -fR site-styles/* tmp.styles/

	rm -rf tmp.styles/assets/*
	cp tmp.svg.less tmp.styles/assets/svg.less

styles/fonts/%.ttf: $(wildcard site-styles/common-styles/fonts/*)
	rm -rf styles/fonts
	mkdir -p styles/fonts
	cp site-styles/common-styles/fonts/*.ttf styles/fonts

styles/%.css: tmp.styles $(SITE_STYLES_LESS)
	mkdir -vp styles
	lessc --math=always --verbose \
		--source-map=styles/$*.css.map \
		tmp.styles/pages/$*.private.less \
		styles/$*.css;

styles/index.css: tmp.styles $(SITE_STYLES_LESS)
	mkdir -vp styles
	lessc --math=always --verbose --source-map=styles/index.css.map tmp.styles/index.less styles/index.css

all: $(STYLES)



### Asciinema demos

index.html: $(DEMOS)

demos/%.svg: demos/%.scenario
	echo "Generating $@ and $(patsubst %.svg,%.cast,$@) ..."
	asciinema-scenario --preview-file "$@" $< > $(patsubst %.svg,%.cast,$@)
	# XXX: this in until asciinema-scenario is fixed
	#      https://github.com/garbas/asciinema-scenario/issues/3
	sed -i -e "s|<nixpkgs|\&lt;nixpkgs|g" $@
