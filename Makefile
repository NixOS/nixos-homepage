NIXOS_SERIES = 19.09
NIXPKGS_STABLE = /no-such-path
NIXPKGS_UNSTABLE = /no-such-path

rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

default: all


HTML = index.html news.html \
  nix/index.html nix/about.html nix/download.html \
  nixpkgs/index.html nixpkgs/download.html \
  nixos/index.html nixos/about.html nixos/download.html nixos/learn.html \
  nixos/community.html nixos/packages.html nixos/options.html \
  nixos/security.html nixos/foundation.html \
  nixos/wiki.html \
  404.html


### Prettify the NixOS manual.

NIXOS_MANUAL_IN = /no-such-path
NIXOS_MANUAL_OUT = nixos/manual

all: $(NIXOS_MANUAL_OUT)

$(NIXOS_MANUAL_OUT): $(NIXOS_MANUAL_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIXOS_MANUAL_IN)/share/doc/nixos $(NIXOS_MANUAL_OUT) 'NixOS manual' nixos https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual


### Prettify the Nix Pills

NIX_PILLS_MANUAL_IN = /no-such-path
NIX_PILLS_MANUAL_OUT = nixos/nix-pills

all: $(NIX_PILLS_MANUAL_OUT)

$(NIX_PILLS_MANUAL_OUT): $(NIX_PILLS_MANUAL_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIX_PILLS_MANUAL_IN) $(NIX_PILLS_MANUAL_OUT) 'Nix Pills' nixos https://github.com/NixOS/nix-pills


### Prettify the Nix manual.

NIX_MANUAL_IN = /no-such-path
NIX_MANUAL_OUT = nix/manual

all: $(NIX_MANUAL_OUT)

$(NIX_MANUAL_OUT): $(call rwildcard, $(NIX_MANUAL_IN), *) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIX_MANUAL_IN) $(NIX_MANUAL_OUT) 'Nix manual' nix https://github.com/NixOS/nix/tree/master/doc/manual
	ln -sfn manual.html $(NIX_MANUAL_OUT)/index.html


### Prettify the Nixpkgs manual.

NIXPKGS_MANUAL_IN = /no-such-path
NIXPKGS_MANUAL_OUT = nixpkgs/manual

all: $(NIXPKGS_MANUAL_OUT)

$(NIXPKGS_MANUAL_OUT): $(NIXPKGS_MANUAL_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIXPKGS_MANUAL_IN)/share/doc/nixpkgs $(NIXPKGS_MANUAL_OUT) 'Nixpkgs manual' nixpkgs https://github.com/NixOS/nixpkgs/tree/master/doc
	ln -sfn manual.html $(NIXPKGS_MANUAL_OUT)/index.html

all: $(HTML) favicon.png $(subst .png,-small.png,$(filter-out %-small.png,$(wildcard nixos/screenshots/*))) \
  nixos/packages-explorer.js \
  nixpkgs/packages-channels.json \
  nixpkgs/packages-nixos-$(NIXOS_SERIES).json \
  nixpkgs/packages-nixpkgs-unstable.json \
  nixos/options.json


favicon.png: logo/nixos-logo-only-hires.png
	convert -resize 16x16 -background none -gravity center -extent 16x16 $< $@

%-small.png: %.png
	convert -resize 200 $< $@

%.html: %.tt layout.tt common.tt nix-release.tt nixos-release.tt donation.tt
	tpage \
	  --pre_chomp --post_chomp \
	  --define root=`echo $@ | sed -e 's|[^/]||g' -e 's|/|../|g'` \
	  --define fileName=$< \
	  --define nixosAmis=$(NIXOS_AMIS) \
	  --define nixosAzureBlobs=$(NIXOS_AZURE_BLOBS) \
	  --define nixosGCE=$(NIXOS_GCE) \
	  --pre_process=nix-release.tt --pre_process=nixos-release.tt --pre_process=common.tt \
	  $< > $@.tmp
	xmllint --nonet --noout $@.tmp
	mv $@.tmp $@

# FIXME: hacky. The channel generator should put up a JSON file.
nixos-release.tt:
	uri=$$(curl --fail --silent -o /dev/null -w %{redirect_url} https://nixos.org/channels/nixos-${NIXOS_SERIES}); \
	version=$$(echo $$uri | sed 's|.*/nixos-||'); \
	echo "[%- latestNixOSSeries = \"${NIXOS_SERIES}\"; -%]" > $@

%: %.in common.tt nix-release.tt
	echo $$PATH
	tpage \
	  --pre_process=nix-release.tt --pre_process=common.tt $< > $@.tmp
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
.PHONY: blogs.xml nixos-release.tt
update: blogs.xml nixos-release.tt
	@true
endif


.PHONY: nixpkgs/packages-nixos-$(NIXOS_SERIES).json

nixpkgs/packages-nixos-$(NIXOS_SERIES).json:
	@ln -sfn $(NIXPKGS_STABLE)/packages.json $@

.PHONY: nixpkgs/packages-nixpkgs-unstable.json

nixpkgs/packages-nixpkgs-unstable.json:
	@ln -sfn $(NIXPKGS_UNSTABLE)/packages.json $@

NIXOS_OPTIONS = /no-such-path

.PHONY: nixos/options.json

# Cute hack, this allows future expansion if desired
# Mainly, this allows tracking NIXOS_SERIES
nixpkgs/packages-channels.json: Makefile
	echo '["nixos-$(NIXOS_SERIES)", "nixpkgs-unstable"]' > $@

nixos/options.json:
	@ln -sfn $(NIXOS_OPTIONS) $@

nixos/packages-explorer.js:
	@ln -sfn $(PACKAGES_EXPLORER) $@

