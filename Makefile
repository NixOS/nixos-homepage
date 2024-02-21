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

### Prettify the Nixpkgs manual.

NIXPKGS_MANUAL_STABLE_IN ?= /no-such-path
NIXPKGS_MANUAL_STABLE_OUT = manual/nixpkgs/stable

$(NIXPKGS_MANUAL_STABLE_OUT): $(NIXPKGS_MANUAL_STABLE_IN) scripts/bootstrapify-docbook.sh scripts/bootstrapify-docbook.xsl layout.tt common.tt
	bash ./scripts/bootstrapify-docbook.sh $(NIXPKGS_MANUAL_STABLE_IN)/share/doc/nixpkgs $(NIXPKGS_MANUAL_STABLE_OUT) 'Nixpkgs $(NIXOS_STABLE_SERIES) manual' nixpkgs https://github.com/NixOS/nixpkgs/tree/master/doc

NIXPKGS_MANUAL_UNSTABLE_IN ?= /no-such-path
NIXPKGS_MANUAL_UNSTABLE_OUT = manual/nixpkgs/unstable

$(NIXPKGS_MANUAL_UNSTABLE_OUT): $(NIXPKGS_MANUAL_UNSTABLE_IN) scripts/bootstrapify-docbook.sh scripts/bootstrapify-docbook.xsl layout.tt common.tt
	bash ./scripts/bootstrapify-docbook.sh $(NIXPKGS_MANUAL_UNSTABLE_IN)/share/doc/nixpkgs $(NIXPKGS_MANUAL_UNSTABLE_OUT) 'Nixpkgs $(NIXOS_UNSTABLE_SERIES) manual' nixpkgs https://github.com/NixOS/nixpkgs/tree/master/doc

### Prettify the NixOS manual.

NIXOS_MANUAL_STABLE_IN ?= /no-such-path
NIXOS_MANUAL_STABLE_OUT = manual/nixos/stable

$(NIXOS_MANUAL_STABLE_OUT): $(NIXOS_MANUAL_STABLE_IN) scripts/bootstrapify-docbook.sh scripts/bootstrapify-docbook.xsl layout.tt common.tt
	bash ./scripts/bootstrapify-docbook.sh $(NIXOS_MANUAL_STABLE_IN)/share/doc/nixos $(NIXOS_MANUAL_STABLE_OUT) 'NixOS $(NIXOS_STABLE_SERIES) manual' nixos https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual

NIXOS_MANUAL_UNSTABLE_IN ?= /no-such-path
NIXOS_MANUAL_UNSTABLE_OUT = manual/nixos/unstable

$(NIXOS_MANUAL_UNSTABLE_OUT): $(NIXOS_MANUAL_UNSTABLE_IN) scripts/bootstrapify-docbook.sh scripts/bootstrapify-docbook.xsl layout.tt common.tt
	bash ./scripts/bootstrapify-docbook.sh $(NIXOS_MANUAL_UNSTABLE_IN)/share/doc/nixos $(NIXOS_MANUAL_UNSTABLE_OUT) 'NixOS $(NIXOS_UNSTABLE_SERIES) manual' nixos https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual



### Check

check: all
	bash ./scripts/check-links.sh


### Asciinema demos

index.html: $(DEMOS)

demos/%.svg: demos/%.scenario
	echo "Generating $@ and $(patsubst %.svg,%.cast,$@) ..."
	asciinema-scenario --preview-file "$@" $< > $(patsubst %.svg,%.cast,$@)
	# XXX: this in until asciinema-scenario is fixed
	#      https://github.com/garbas/asciinema-scenario/issues/3
	sed -i -e "s|<nixpkgs|\&lt;nixpkgs|g" $@
