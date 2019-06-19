NIXOS_SERIES = 19.03
NIXPKGS = https://nixos.org/channels/nixos-$(NIXOS_SERIES)/nixexprs.tar.xz
NIXPKGS_UNSTABLE = https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz

rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

default: all


HTML = index.html news.html \
  nix/index.html nix/about.html nix/download.html \
  nixpkgs/index.html nixpkgs/download.html \
  nixos/index.html nixos/about.html nixos/download.html nixos/support.html \
  nixos/community.html nixos/packages.html nixos/options.html \
  nixos/security.html nixos/foundation.html \
  nixos/wiki.html \
  patchelf.html hydra/index.html \
  disnix/index.html disnix/download.html disnix/docs.html \
  disnix/extensions.html disnix/examples.html disnix/support.html \
  nixops/index.html


### Prettify the NixOS manual.

NIXOS_MANUAL_IN = /no-such-path
NIXOS_MANUAL_OUT = nixos/manual

all: $(NIXOS_MANUAL_OUT)

$(NIXOS_MANUAL_OUT): $(NIXOS_MANUAL_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIXOS_MANUAL_IN)/share/doc/nixos $(NIXOS_MANUAL_OUT) 'NixOS manual' nixos https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual


### Prettify the Nix Pills

NIX_PILLS_MANUAL_IN = nixos/nix-pills-raw
NIX_PILLS_MANUAL_OUT = nixos/nix-pills

#all: $(NIX_PILLS_MANUAL_OUT)

$(NIX_PILLS_MANUAL_OUT): $(NIX_PILLS_MANUAL_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIX_PILLS_MANUAL_IN) $(NIX_PILLS_MANUAL_OUT) 'Nix Pills' nixos https://github.com/NixOS/nix-pills

$(NIX_PILLS_MANUAL_IN):
	path=$$(curl -LH 'Accept: application/json' https://hydra.nixos.org/job/nix-pills/master/html-split/latest | jq -re '.buildoutputs.out.path') && \
	nix-store -r $$path && \
	ln -sfn $$path/share/doc/nix-pills $(NIX_PILLS_MANUAL_IN)


### Prettify the Nix manual.

NIX_MANUAL_IN = /no-such-path
NIX_MANUAL_OUT = nix/manual

all: $(NIX_MANUAL_OUT)

$(NIX_MANUAL_OUT): $(call rwildcard, $(NIX_MANUAL_IN), *) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIX_MANUAL_IN) $(NIX_MANUAL_OUT) 'Nix manual' nix https://github.com/NixOS/nix/tree/master/doc/manual
	ln -sfn manual.html $(NIX_MANUAL_OUT)/index.html


### Prettify the NixOps manual.

NIXOPS_MANUAL_IN = /no-such-path
NIXOPS_MANUAL_OUT = nixops/manual

all: $(NIXOPS_MANUAL_OUT)

$(NIXOPS_MANUAL_OUT): $(call rwildcard, $(NIXOPS_MANUAL_IN), *) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIXOPS_MANUAL_IN) $(NIXOPS_MANUAL_OUT) 'NixOps manual' nixops https://github.com/NixOS/nixops/tree/master/doc/manual
	ln -sfn manual.html $(NIXOPS_MANUAL_OUT)/index.html


### Prettify the Nixpkgs manual.

NIXPKGS_MANUAL_IN = /no-such-path
NIXPKGS_MANUAL_OUT = nixpkgs/manual

all: $(NIXPKGS_MANUAL_OUT)

$(NIXPKGS_MANUAL_OUT): $(NIXPKGS_MANUAL_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(NIXPKGS_MANUAL_IN)/share/doc/nixpkgs $(NIXPKGS_MANUAL_OUT) 'Nixpkgs manual' nixpkgs https://github.com/NixOS/nixpkgs/tree/master/doc
	ln -sfn manual.html $(NIXPKGS_MANUAL_OUT)/index.html


all: $(HTML) favicon.png $(subst .png,-small.png,$(filter-out %-small.png,$(wildcard nixos/screenshots/*))) \
  #nixpkgs/packages.json.gz \
  #nixpkgs/packages-unstable.json.gz \
  #nixos/options.json.gz


### Prettify the Hydra manual.

HYDRA_MANUAL_IN = /no-such-path
HYDRA_MANUAL_OUT = hydra/manual

all: $(HYDRA_MANUAL_OUT)

$(HYDRA_MANUAL_OUT): $(HYDRA_MANUAL_IN) bootstrapify-docbook.sh bootstrapify-docbook.xsl layout.tt common.tt
	bash ./bootstrapify-docbook.sh $(HYDRA_MANUAL_IN) $(HYDRA_MANUAL_OUT) 'Hydra manual' hydra https://github.com/NixOS/hydra/tree/master/doc/manual
	ln -sfn manual.html $(HYDRA_MANUAL_OUT)/index.html


favicon.png: logo/nixos-logo-only-hires.png
	convert -resize 16x16 -background none -gravity center -extent 16x16 $< $@

%-small.png: %.png
	convert -resize 200 $< $@

%.html: %.tt layout.tt common.tt nix-release.tt nixos-release.tt donation.tt
	tpage \
	  --pre_chomp --post_chomp \
	  --define root=`echo $@ | sed -e 's|[^/]||g' -e 's|/|../|g'` \
	  --define fileName=$< \
	  --pre_process=nix-release.tt --pre_process=nixos-release.tt --pre_process=common.tt \
	  $< > $@.tmp
	xmllint --nonet --noout $@.tmp
	mv $@.tmp $@

# FIXME: hacky. The channel generator should put up a JSON file.
nixos-release.tt:
	uri=$$(curl --fail --silent -o /dev/null -w %{redirect_url} https://nixos.org/channels/nixos-${NIXOS_SERIES}); \
	version=$$(echo $$uri | sed 's|.*/nixos-||'); \
	echo "[%- latestNixOSSeries = \"${NIXOS_SERIES}\"; latestNixOSRelease = \"$$version\" -%]" > $@

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

index.html: news-rss.xml latest-news.xhtml nixpkgs-commits.json nixpkgs-commit-stats.json blogs.json

nixos/download.html: nixos/amis.json nixos/azure-blobs.json

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

nixos/azure-blobs.json: nixos/azure-blobs.nix
	nix-instantiate --eval --strict --json $< > $@.tmp
	mv $@.tmp $@

nixos/azure-blobs.nix:
	curl --fail -L https://raw.github.com/NixOS/nixpkgs/master/nixos/modules/virtualisation/azure-bootstrap-blobs.nix > $@.tmp
	mv $@.tmp $@

nixpkgs-commits.json:
	curl --fail https://api.github.com/repos/NixOS/nixpkgs/commits > $@.tmp
	mv $@.tmp $@

nixpkgs-commit-stats.json:
	curl --fail https://api.github.com/repos/NixOS/nixpkgs/stats/participation > $@.tmp
	mv $@.tmp $@

blogs.xml:
	curl --fail https://planet.nixos.org/rss20.xml > $@.tmp
	mv $@.tmp $@

blogs.json: blogs.xml
	perl -MJSON -MXML::Simple -e 'print encode_json(XMLin("blogs.xml"));' < $< > $@.tmp
	mv $@.tmp $@

ifeq ($(UPDATE), 1)
.PHONY: nixos/amis.nix nixos/azure-blobs.nix nixpkgs-commits.json nixpkgs-commit-stats.json blogs.xml nixpkgs/packages.json nixpkgs/packages-unstable.json nixos/options.json \
  $(NIXOS_MANUAL_IN) $(NIXOS_MANUAL_OUT) $(NIX_MANUAL_OUT) $(NIXPKGS_MANUAL_IN) $(HYDRA_MANUAL_IN) $(NIX_PILLS_MANUAL_IN) nixos-release.tt
endif


%.json.gz: %.json
	gzip -9 < $^ > $@.tmp
	mv $@.tmp $@

nixpkgs/packages.json: packages-config.nix
	nixpkgs=$$(nix-instantiate --find-file nixpkgs -I nixpkgs=$(NIXPKGS)); \
	(echo -n '{ "commit": "' && (cat $$nixpkgs/.git-revision || printf "unknown") && echo -n '","packages":' \
	  && nix-env -f '<nixpkgs>' -I nixpkgs=$(NIXPKGS) -qa --json --arg config 'import ./packages-config.nix' \
	  && echo -n '}') \
	  | sed "s|$$nixpkgs/||g" | jq -c . > $@.tmp
	python -mjson.tool < $@.tmp > /dev/null
	mv $@.tmp $@

nixpkgs/packages-unstable.json: packages-config.nix
	nixpkgs=$$(nix-instantiate --find-file nixpkgs -I nixpkgs=$(NIXPKGS_UNSTABLE)); \
	(echo -n '{ "commit": "' && (cat $$nixpkgs/.git-revision || printf "unknown") && echo -n '","packages":' \
	  && nix-env -f '<nixpkgs>' -I nixpkgs=$(NIXPKGS_UNSTABLE) -qa --json --arg config 'import ./packages-config.nix' \
	  && echo -n '}') \
	  | sed "s|$$nixpkgs/||g" | jq -c . > $@.tmp
	python -mjson.tool < $@.tmp > /dev/null
	mv $@.tmp $@

nixos/options.json:
	cat $$(nix-build --no-out-link '<nixpkgs/nixos/release.nix>' -I nixpkgs=$(NIXPKGS) -A options)/share/doc/nixos/options.json > $@.tmp
	mv $@.tmp $@
