rec {
  description = "The nixos.org homepage";

  # This is used to build the site.
  inputs.nixpkgs = { url = "nixpkgs/nixos-unstable"; };

  # These inputs are used for the manuals and release artifacts
  inputs.released-nixpkgs-unstable = { url = "nixpkgs/nixos-unstable"; };
  inputs.released-nixpkgs-stable = { url = "nixpkgs/nixos-21.11"; };
  inputs.released-nix-unstable = { url = "github:nixos/nix/master"; };
  inputs.released-nix-stable = { url = "github:nixos/nix/latest-release"; };
  inputs.nix-pills = { url = "github:NixOS/nix-pills"; flake = false; };
  inputs.nix-dev = { url = "github:nix-dot-dev/nix.dev"; };
  inputs.nixos-common-styles = { url = "github:NixOS/nixos-common-styles"; };

  outputs =
    { self
    , nixpkgs
    , released-nixpkgs-unstable
    , released-nixpkgs-stable
    , released-nix-unstable
    , released-nix-stable
    , nix-pills
    , nix-dev
    , nixos-common-styles
    }:
    let
      system = "x86_64-linux";

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

      shuffle_commercial_providers =
        mkPyScript (with pkgs.python3Packages; [ click toml ]) "shuffle-commercial-providers";

      update_blog =
        mkPyScript (with pkgs.python3Packages; [ aiohttp click feedparser cchardet ]) "update-blog";

    in rec {
      defaultPackage."${system}" = packages."${system}".homepage;

      checks."${system}".build = defaultPackage."${system}";

      packages."${system}" = rec {
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
              nixFlakes
              nodePackages.less
              nodePackages.svgo
              perl
              perlPackages.AppConfig
              perlPackages.JSON
              perlPackages.TemplatePluginIOAll
              perlPackages.TemplatePluginJSONEscape
              perlPackages.TemplateToolkit
              perlPackages.XMLSimple
              serve
              shuffle_commercial_providers
              update_blog
              xhtml1
              xidel
            ];

          preBuild = ''
            export NIX_DB_DIR=$TMPDIR
            export NIX_STATE_DIR=$TMPDIR

            rm -f site-styles/common-styles
            cp -r ${nixos-common-styles.packages."${system}".commonStyles} site-styles/common-styles
            chmod -R +w site-styles/common-styles

            # First delete source SVG files.
            # This serves two purposes:
            #   - Validate they're not accidentally used in the final build
            #   - Skip needlessly optimizing them
            find site-styles -name '*.src.svg' -delete
            # Then optimize the remaining SVGs
            find site-styles -name '*.svg' -print0 \
              | xargs --null --max-procs=$NIX_BUILD_CORES --max-args=1 svgo
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
              "NIX_PILLS_MANUAL_IN=${nixPills}/share/doc/nix-pills"
              "NIX_DEV_MANUAL_IN=${nix-dev.defaultPackage.x86_64-linux}"

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
            export NIX_PILLS_MANUAL_IN="${nixPills}/share/doc/nix-pills"
            export NIX_DEV_MANUAL_IN="${nix-dev.defaultPackage.x86_64-linux}"

            rm -f site-styles/common-styles
            ln -s ${nixos-common-styles.packages."${system}".commonStyles} site-styles/common-styles

            echo ""
            echo "  NixOS homepage development shell"
            echo "  ================================"
            echo ""
            echo "  To hack on the homepage only:"
            echo "      serve"
            echo ""
            echo "  To hack on common styles too:"
            echo "      scripts/nixos-common-styles-dev-setup.sh .../path/to/nixos-common-styles"
            echo "      serve"
            echo ""
            echo "  Note: The common-styles symlink needs to be refreshed any time the nix shell is entered"
            echo ""
            echo "  Then go to the following URL in your browser:"
            echo "      https://127.0.0.1:8000/"
            echo ""
            echo "  It will rebuild the website on each change."
            echo ""
          '';
        };
      };
  };
}
