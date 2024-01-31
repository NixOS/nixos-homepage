rec {
  description = "The nixos.org homepage";

  # This is used to build the site.
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  # These inputs are used for the manuals and release artifacts
  inputs.released-nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  inputs.released-nixpkgs-stable.url = "nixpkgs/nixos-23.05";
  inputs.released-nix-unstable.url = "github:nixos/nix/master";
  inputs.released-nix-stable.url = "github:nixos/nix/latest-release";
  inputs.nix-pills.url = "github:NixOS/nix-pills";
  inputs.nix-pills.flake = false;

  nixConfig.extra-substituters = [
    "https://nixos-homepage.cachix.org"
    "https://nixos-nix-install-tests.cachix.org"
  ];
  nixConfig.extra-trusted-public-keys = [
    "nixos-homepage.cachix.org-1:NHKBt7NjLcWfgkX4OR72q7LVldKJe/JOsfIWFDAn/tE="
    "nixos-nix-install-tests.cachix.org-1:Le57vOUJjOcdzLlbwmZVBuLGoDC+Xg2rQDtmIzALgFU="
  ];

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , released-nixpkgs-unstable
    , released-nixpkgs-stable
    , released-nix-unstable
    , released-nix-stable
    , nix-pills
    }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlay = final: prev: {
          asciinema-scenario = final.rustPlatform.buildRustPackage rec {
            pname = "asciinema-scenario";
            version = "0.2.0";
            src = final.fetchCrate {
              inherit pname version;
              sha256 = "sha256-qMGi+myppWBapM7TkPeXC2g/M1FA1YGwESNrx8LVXkw=";
            };
            cargoSha256 = "0z4iwjm38xfgipl1pcrkl8277p627pls565k7cclrhxfcx3f513p";
          };
        };

        pkgs = import nixpkgs { inherit system; overlays = [ overlay ]; };
        inherit (pkgs.lib) getVersion;

        pkgs-unstable = import released-nixpkgs-unstable { inherit system; };
        pkgs-stable = import released-nixpkgs-stable { inherit system; };

        nix_stable = released-nix-stable.packages."${system}".nix;
        nix_unstable = released-nix-unstable.packages."${system}".nix;

        nixPills = import nix-pills {
          inherit pkgs;
          revCount = nix-pills.lastModifiedDate; # FIXME
          shortRev = nix-pills.shortRev;
        };

        # TODO: change structure to conform to ./src/content/download/aws-ec2.yaml but in json
        NIXOS_AMIS = pkgs.writeText "ec2-amis.json"
          (builtins.toJSON (
            import (released-nixpkgs-stable + "/nixos/modules/virtualisation/ec2-amis.nix")));

        NIX_STABLE_VERSION = getVersion nix_stable.name;
        NIX_UNSTABLE_VERSION = getVersion nix_unstable.name;
        NIXOS_STABLE_SERIES = pkgs-stable.lib.trivial.release;
        NIXOS_UNSTABLE_SERIES = pkgs-unstable.lib.trivial.release;

        manuals = pkgs.runCommand "manuals" {} ''
          #TODO: add redirect pages

          mkdir -p $out/nix/stable
          mkdir -p $out/nix/unstable
          cp -R ${nix_stable.doc}/share/doc/nix/manual $out/nix/stable
          cp -R ${nix_unstable.doc}/share/doc/nix/manual $out/nix/unstable

          mkdir -p $out/nixpkgs/stable
          mkdir -p $out/nixpkgs/unstable
          # bash ./scripts/bootstrapify-docbook.sh ${released-nixpkgs-stable.htmlDocs.nixpkgsManual}/share/doc/nixpkgs $out/nixpkgs/stable 'Nixpkgs ${NIXOS_STABLE_SERIES} manual' nixpkgs https://github.com/NixOS/nixpkgs/tree/master/doc
          # bash ./scripts/bootstrapify-docbook.sh ${released-nixpkgs-unstable.htmlDocs.nixpkgsManual}/share/doc/nixpkgs $out/nixpkgs/unstable 'Nixpkgs ${NIXOS_UNSTABLE_SERIES} manual' nixpkgs https://github.com/NixOS/nixpkgs/tree/master/doc

          mkdir -p $out/nixos/stable
          mkdir -p $out/nixos/unstable
          # bash ./scripts/bootstrapify-docbook.sh ${released-nixpkgs-stable.htmlDocs.nixosManual}/share/doc/nixos $out/nixos/stable 'NixOS ${NIXOS_STABLE_SERIES} manual' nixos https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual
          # bash ./scripts/bootstrapify-docbook.sh ${released-nixpkgs-unstable.htmlDocs.nixosManual}/share/doc/nixos $out/nixos/unstable 'NixOS ${NIXOS_UNSTABLE_SERIES} manual' nixos https://github.com/NixOS/nixpkgs/tree/master/nixos/doc/manual
        '';

        pills = pkgs.runCommand "pills" {} ''
          mkdir -p $out
          cp ${nixPills.epub}/share/doc/nix-pills/nix-pills.epub $out/nix-pills.epub
          #bash ./scripts/bootstrapify-docbook.sh ${nixPills.html-split}/share/doc/nix-pills} $out 'Nix Pills' nixos https://github.com/NixOS/nix-pills
        '';

      in rec {
        packages.manuals = manuals;
        packages.pills = pills;

        devShells.default = pkgs.mkShell {
          name = "nixos-homepage";

          packages = with pkgs; [
            nodejs_18
            asciinema-scenario
          ];

          shellHook = ''
            export NIX_STABLE_VERSION="${NIX_STABLE_VERSION}"
            export NIX_UNSTABLE_VERSION="${NIX_UNSTABLE_VERSION}"
            export NIXOS_STABLE_SERIES="${NIXOS_STABLE_SERIES}"
            export NIXOS_UNSTABLE_SERIES="${NIXOS_UNSTABLE_SERIES}"
            export NIXOS_AMIS="${NIXOS_AMIS}"

            >&2 echo ""
            >&2 echo "  To bootstrap developing environment run:"
            >&2 echo "      npm install"
            >&2 echo ""
            >&2 echo "  To start developing run:"
            >&2 echo "      npm run dev"
            >&2 echo ""
            >&2 echo "  and go to the following URL in your browser:"
            >&2 echo "      http://localhost:4321"
            >&2 echo ""
            >&2 echo "  It will rebuild the website on each change."
            >&2 echo ""
          '';
        };
    });
}
