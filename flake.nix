{
  description = "The nixos.org homepage";

  # This is used to build the site.
  inputs.nixpkgs = { url = "nixpkgs/nixos-20.03"; };

  # These inputs are used for the manuals and release artifacts
  inputs.released-nixpkgs = { url = "nixpkgs/nixos-20.03"; };
  inputs.released-nix = { url = "github:nixos/nix/2.3-maintenance"; flake = false; };
  inputs.nix-pills = { url = "github:NixOS/nix-pills"; flake = false; };

  outputs = { self, nixpkgs, released-nixpkgs, released-nix, nix-pills }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      released-pkgs = import released-nixpkgs { inherit system; };
    in rec {
      defaultPackage."${system}" = packages."${system}".homepage;

      checks."${system}".build = defaultPackage."${system}";

      packages."${system}" = rec {

        packagesExplorer = import ./packages-explorer nixpkgs;

        nix = (import "${released-nix}/release.nix" {
          nix = released-nix;
          nixpkgs = released-nixpkgs;
          officialRelease = true;
        }).build."${system}";

        nixosAmis = pkgs.writeText "ec2-amis.json"
          (builtins.toJSON (
            import (released-nixpkgs + "/nixos/modules/virtualisation/ec2-amis.nix")));

        nixPills = import nix-pills {
          inherit pkgs;
          revCount = nix-pills.lastModifiedDate; # FIXME
          shortRev = nix-pills.shortRev;
        };

        homepage = pkgs.stdenv.mkDerivation {
          name = "nixos-homepage-${self.lastModifiedDate}";

          src = self;

          enableParallelBuilding = true;

          buildInputs = with pkgs; [
              fd
              libxslt
              libxml2
              perl
              perlPackages.JSON
              perlPackages.XMLSimple
              perlPackages.TemplateToolkit
              perlPackages.TemplatePluginJSONEscape
              perlPackages.TemplatePluginIOAll
              perlPackages.AppConfig
              pkgs.nix
              imagemagick
              xhtml1
              jq
              python3
              python3Packages.click
              python3Packages.colorama
              entr
            ];

          preBuild = ''
            export NIX_DB_DIR=$TMPDIR
            export NIX_STATE_DIR=$TMPDIR
          '';

          makeFlags =
            [ "NIX_VERSION=${released-pkgs.lib.getVersion nix.name}"
              "NIXOS_SERIES=${released-pkgs.lib.trivial.release}"
              "NIX_MANUAL_IN=${nix}/share/doc/nix/manual"
              "NIXOS_MANUAL_IN=${released-nixpkgs.htmlDocs.nixosManual}"
              "NIXPKGS_MANUAL_IN=${released-nixpkgs.htmlDocs.nixpkgsManual}"
              "NIXOS_AMIS=${nixosAmis}"
              "PACKAGES_EXPLORER=${packagesExplorer}/bundle.js"
              "NIX_PILLS_MANUAL_IN=${nixPills}/share/doc/nix-pills"
            ];

          installPhase = ''
            mkdir $out
            cp -prd . $out/
          '';

          shellHook = ''
            export NIX_VERSION="${released-pkgs.lib.getVersion nix.name}"
            export NIXOS_SERIES="${released-pkgs.lib.trivial.release}"
            export NIX_MANUAL_IN="${nix}/share/doc/nix/manual"
            export NIXOS_MANUAL_IN="${released-nixpkgs.htmlDocs.nixosManual}"
            export NIXPKGS_MANUAL_IN="${released-nixpkgs.htmlDocs.nixpkgsManual}"
            export NIXOS_AMIS="${nixosAmis}"
            export PACKAGES_EXPLORER="${packagesExplorer}/bundle.js"
            export NIX_PILLS_MANUAL_IN="${nixPills}/share/doc/nix-pills"
          '';
        };
      };

      nixosConfigurations.container = nixpkgs.lib.nixosSystem {
        inherit system;
        modules =
          [ ({ lib, ... }:
            { system.configurationRevision = lib.mkIf (self ? rev) self.rev;
              boot.isContainer = true;
              networking.useDHCP = false;
              networking.firewall.allowedTCPPorts = [ 80 ];
              services.httpd = {
                enable = true;
                adminAddr = "admin@example.org";
                virtualHosts.default = {
                  documentRoot = packages."${system}".homepage;
                };
              };
            })
          ];
      };

  };
}
