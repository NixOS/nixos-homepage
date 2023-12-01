rec {
  description = "The nixos.org homepage";

  # This is used to build the site.
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  # These inputs are used for the manuals and release artifacts
  inputs.released-nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  # temporarily pinned to use the updated version of release notes
  # inputs.released-nixpkgs-stable.url = "nixpkgs/nixos-23.11";
  inputs.released-nixpkgs-stable.url = "nixpkgs/23.11";
  inputs.released-nix-unstable.url = "github:nixos/nix/master";
  inputs.released-nix-stable.url = "github:nixos/nix/latest-release";
  inputs.nix-pills.url = "github:NixOS/nix-pills";
  inputs.nix-pills.flake = false;
  inputs.nixos-common-styles.url = "github:NixOS/nixos-common-styles";
  inputs.nixos-common-styles.inputs.flake-utils.follows = "flake-utils";

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
    , nixos-common-styles
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

        nixosAmis = pkgs.writeText "ec2-amis.json"
          (builtins.toJSON (
            import (released-nixpkgs-stable + "/nixos/modules/virtualisation/ec2-amis.nix")));

        mkPyScript = dependencies: name:
          let
            pythonEnv = pkgs.python3.buildEnv.override {
              extraLibs = dependencies;
            };
          in
            pkgs.writeShellScriptBin name ''exec "${pythonEnv}/bin/python" "${toString ./.}/scripts/${name}.py" "$@"'';

        serve =
          mkPyScript (with pkgs.python3Packages; [ click livereload ]) "serve";

        update_blog =
          mkPyScript (with pkgs.python3Packages; [ aiohttp click feedparser cchardet ]) "update-blog";

      in rec {
        defaultPackage = packages.homepage;

        checks.build = defaultPackage;

        packages = {
          homepage = pkgs.stdenv.mkDerivation {
            name = "nixos-homepage-${self.lastModifiedDate}";

            src = self;

            preferLocalBuild = true;
            enableParallelBuilding = true;

            buildInputs = with pkgs; [
                asciinema-scenario
                gnused
                imagemagick
                jq
                libxml2
                libxslt
                linkchecker
                nixVersions.stable
                nixos-common-styles.packages."${system}".embedSVG
                nodePackages.less
                perl
                perlPackages.AppConfig
                perlPackages.JSON
                perlPackages.TemplatePluginIOAll
                perlPackages.TemplatePluginJSONEscape
                perlPackages.TemplateToolkit
                perlPackages.XMLSimple
                serve
                update_blog
                xhtml1
                which
              ];

            preBuild = ''
              export NIX_DB_DIR=$TMPDIR
              export NIX_STATE_DIR=$TMPDIR

              rm -f site-styles/common-styles
              ln -s ${nixos-common-styles.packages."${system}".commonStyles} site-styles/common-styles
            '';

            makeFlags =
              [ "NIX_STABLE_VERSION=${getVersion nix_stable.name}"
                "NIX_MANUAL_STABLE_IN=${nix_stable.doc}/share/doc/nix/manual"
                "NIXPKGS_MANUAL_STABLE_IN=${released-nixpkgs-stable.htmlDocs.nixpkgsManual}"
                "NIXOS_MANUAL_STABLE_IN=${released-nixpkgs-stable.htmlDocs.nixosManual}"
                "NIXOS_STABLE_SERIES=${pkgs-stable.lib.trivial.release}"

                "NIX_UNSTABLE_VERSION=${getVersion nix_unstable.name}"
                "NIX_MANUAL_UNSTABLE_IN=${nix_unstable.doc}/share/doc/nix/manual"
                "NIXPKGS_MANUAL_UNSTABLE_IN=${released-nixpkgs-unstable.htmlDocs.nixpkgsManual}"
                "NIXOS_MANUAL_UNSTABLE_IN=${released-nixpkgs-unstable.htmlDocs.nixosManual}"
                "NIXOS_UNSTABLE_SERIES=${pkgs-unstable.lib.trivial.release}"

                "NIXOS_AMIS=${nixosAmis}"
                "NIX_PILLS_MANUAL_IN=${nixPills.html-split}/share/doc/nix-pills"
                "NIX_PILLS_MANUAL_EPUB=${nixPills.epub}/share/doc/nix-pills/nix-pills.epub"

                "-j 1"
              ];

            doCheck = true;

            installPhase = ''
              mkdir $out
              cp -prd . .well-known/ $out/
            '';

            shellHook = ''
              export NIX_STABLE_VERSION="${getVersion nix_stable.name}"
              export NIX_MANUAL_STABLE_IN="${nix_stable.doc}/share/doc/nix/manual"
              export NIXPKGS_MANUAL_STABLE_IN="${released-nixpkgs-stable.htmlDocs.nixpkgsManual}"
              export NIXOS_MANUAL_STABLE_IN="${released-nixpkgs-stable.htmlDocs.nixosManual}"
              export NIXOS_STABLE_SERIES="${pkgs-stable.lib.trivial.release}"

              export NIX_UNSTABLE_VERSION="${getVersion nix_unstable.name}"
              export NIX_MANUAL_UNSTABLE_IN="${nix_unstable.doc}/share/doc/nix/manual"
              export NIXPKGS_MANUAL_UNSTABLE_IN="${released-nixpkgs-unstable.htmlDocs.nixpkgsManual}"
              export NIXOS_MANUAL_UNSTABLE_IN="${released-nixpkgs-unstable.htmlDocs.nixosManual}"
              export NIXOS_UNSTABLE_SERIES="${pkgs-unstable.lib.trivial.release}"

              export NIXOS_AMIS="${nixosAmis}"
              export NIX_PILLS_MANUAL_IN="${nixPills.html-split}/share/doc/nix-pills"
              export NIX_PILLS_MANUAL_EPUB="${nixPills.epub}/share/doc/nix-pills/nix-pills.epub"

              rm -f site-styles/common-styles
              ln -s ${nixos-common-styles.packages."${system}".commonStyles} site-styles/common-styles

              >&2 echo ""
              >&2 echo "  To start developing run:"
              >&2 echo "      serve"
              >&2 echo ""
              >&2 echo "  and go to the following URL in your browser:"
              >&2 echo "      http://127.0.0.1:8000/"
              >&2 echo ""
              >&2 echo "  It will rebuild the website on each change."
              >&2 echo ""
            '';
          };
        };
    });
}
