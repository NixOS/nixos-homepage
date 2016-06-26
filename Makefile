NIXOS_VERSION = 16.03
NIXPKGS = https://nixos.org/channels/nixos-$(NIXOS_VERSION)/nixexprs.tar.xz

rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

default: all


HTML = index.html news.html \
  nix/index.html nix/about.html nix/download.html \
  nixpkgs/index.html nixpkgs/download.html \
  nixos/about.html nixos/download.html nixos/support.html nixos/community.html nixos/packages.html nixos/options.html \
  nixos/screenshots.html nixos/foundation.html \
  patchelf.html hydra/index.html \
  disnix/index.html disnix/download.html disnix/docs.html \
  disnix/extensions.html disnix/examples.html disnix/support.html \
  docs/papers.html \
  nixops/index.html


### Prettify the NixOS manual.

NIXOS_MANUAL_IN = nixos/manual-raw
NIXOS_MANUAL_OUT = nixos/manual

all: $(NIXOS_MANUAL_OUT)

$(NIXOS_MANUAL_OUT): $(NIXOS_MANUAL_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	./bootstrapify-docbook.sh $(NIXOS_MANUAL_IN)/share/doc/nixos $(NIXOS_MANUAL_OUT) 'NixOS manual' nixos https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual

$(NIXOS_MANUAL_IN):
	@echo rm -f $@
	nix-build -o $@ '<nixpkgs/nixos>' -I nixpkgs=$(NIXPKGS) \
	  -A config.system.build.manual.manual --arg configuration '{ fileSystems."/".device = "/dummy"; }'


### Prettify the Nix manual.

NIX_MANUAL_IN = nix/manual-raw
NIX_MANUAL_OUT = nix/manual

ifneq ($(wildcard $(NIX_MANUAL_IN)),)

all: $(NIX_MANUAL_OUT)

$(NIX_MANUAL_OUT): $(call rwildcard, $(NIX_MANUAL_IN), *) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	./bootstrapify-docbook.sh $(NIX_MANUAL_IN) $(NIX_MANUAL_OUT) 'Nix manual' nix https://github.com/NixOS/nix/tree/master/doc/manual
	ln -sfn manual.html $(NIX_MANUAL_OUT)/index.html

endif


### Prettify the NixOps manual.

NIXOPS_MANUAL_IN = nixops/manual-raw
NIXOPS_MANUAL_OUT = nixops/manual

ifneq ($(wildcard $(NIXOPS_MANUAL_IN)),)

all: $(NIXOPS_MANUAL_OUT)

$(NIXOPS_MANUAL_OUT): $(call rwildcard, $(NIXOPS_MANUAL_IN), *) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	./bootstrapify-docbook.sh $(NIXOPS_MANUAL_IN) $(NIXOPS_MANUAL_OUT) 'NixOps manual' nixops https://github.com/NixOS/nixops/tree/master/doc/manual
	ln -sfn manual.html $(NIXOPS_MANUAL_OUT)/index.html

endif


### Prettify the Nixpkgs manual.

NIXPKGS_MANUAL_IN = nixpkgs/manual-raw
NIXPKGS_MANUAL_OUT = nixpkgs/manual

all: $(NIXPKGS_MANUAL_OUT)

$(NIXPKGS_MANUAL_OUT): $(NIXPKGS_MANUAL_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	./bootstrapify-docbook.sh $(NIXPKGS_MANUAL_IN)/share/doc/nixpkgs $(NIXPKGS_MANUAL_OUT) 'Nixpkgs manual' nixpkgs https://github.com/NixOS/nixpkgs/tree/master/doc
	ln -sfn manual.html $(NIXPKGS_MANUAL_OUT)/index.html

$(NIXPKGS_MANUAL_IN):
	@echo rm -f $@
	nix-build -o $@ '<nixpkgs/doc>' -I nixpkgs=$(NIXPKGS)


all: $(HTML) favicon.png $(subst .png,-small.png,$(filter-out %-small.png,$(wildcard nixos/screenshots/*))) \
  nixpkgs/packages.json.gz \
  nixos/options.json.gz \
  nix/install nix/install.sig


favicon.png: logo/nixos-logo-only-hires.png
	convert -resize 16x16 -background none -gravity center -extent 16x16 $< $@

%-small.png: %.png
	convert -resize 200 $< $@

docs/papers-in.html: docs/papers.xml docs/bib2html.xsl
	xsltproc docs/bib2html.xsl docs/papers.xml > $@ || rm $@

docs/papers.html: docs/papers-in.html

%.html: %.tt layout.tt common.tt donation.tt
	tpage \
	  --pre_chomp --post_chomp \
	  --define modifiedAt="`git log -1 --pretty='%ai' $<`" \
	  --define modifiedBy="`git log -1 --pretty='%an' $<`" \
	  --define root=`echo $@ | sed -e 's|[^/]||g' -e 's|/|../|g'` \
	  --define fileName=$< \
	  --pre_process=common.tt $< > $@.tmp
	xmllint --nonet --noout $@.tmp
	mv $@.tmp $@

%: %.in common.tt
	tpage \
	  --pre_process=common.tt $< > $@.tmp
	mv $@.tmp $@

news.html: all-news.xhtml

all-news.xhtml: news.xml news.xsl
	xsltproc --param maxItem 10000 news.xsl news.xml > $@ || rm -f $@

index.html: latest-news.xhtml nixpkgs-commits.json nixpkgs-commit-stats.json blogs.json

nixos/download.html: nixos/amis.json

latest-news.xhtml: news.xml news.xsl
	xsltproc --param maxItem 12 news.xsl news.xml > $@ || rm -f $@

check:
	checklink $(HTML)

nixos/amis.json: nixos/amis.nix
	nix-instantiate --eval --strict --json $< > $@.tmp
	mv $@.tmp $@

nixos/amis.nix:
	curl --fail -L https://raw.github.com/NixOS/nixpkgs/master/nixos/modules/virtualisation/ec2-amis.nix > $@.tmp
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
.PHONY: nixos/amis.nix nixpkgs-commits.json nixpkgs-commit-stats.json blogs.xml nixpkgs/packages.json.gz nixos/options.json.gz \
  $(NIXOS_MANUAL_IN) $(NIXOS_MANUAL_OUT) $(NIX_MANUAL_OUT) $(NIXPKGS_MANUAL_IN)
endif

nixpkgs/packages.json.gz:
	nixpkgs=$$(nix-instantiate --find-file nixpkgs -I nixpkgs=$(NIXPKGS)); \
	cp -R $$nixpkgs ../home/nixpkgs; \
	patch -d ../home/nixpkgs < nixpkgs/nixpkgs.patch; \
	find ../home/nixpkgs -type f -print0 | xargs -0 perl -pi.back -e 's/assert(.*?);/(if $$1 then builtins.trace "failed assertion" else (x: x))/g'; \
	(echo -n '{ "commit": "' && cat ../home/nixpkgs/.git-revision && echo -n '","packages":' \
	  && nix-env -f './nixpkgs/addAttrs.nix' -I nixpkgs=$(NIXPKGS) -qa --json --arg config '{}' \
	  && echo -n '}') \
	  | sed "s|$$nixpkgs/||g" | gzip -9 > $@.tmp
	gunzip < $@.tmp | python -mjson.tool > /dev/null
	# I haven't gotten nginx configured to transfer the gzip file
	# mv $@.tmp $@
	gunzip < $@.tmp > $@

nixos/options.json.gz:
	gzip -9 < $$(nix-build --no-out-link '<nixpkgs/nixos/release.nix>' -I nixpkgs=$(NIXPKGS) -A options)/share/doc/nixos/options.json > $@.tmp
	mv $@.tmp $@

nix/install.sig: nix/install
	if ! gpg2 --verify $@ $<; then \
		gpg2 --detach-sign --armor < $< > $@.tmp; \
		mv $@.tmp $@; \
	fi
	touch $@
