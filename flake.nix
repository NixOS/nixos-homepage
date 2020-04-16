{
  edition = 201909;

  description = "The nixos.org homepage";

  # This is used to build the site.
  inputs.nixpkgs.url = "nixpkgs/nixos-20.03";

  # These are used for the manuals, and release artifacts
  inputs.released-nixpkgs.url = "nixpkgs/nixos-20.03";
  inputs.nix-pills = { url = "github:NixOS/nix-pills"; flake = false; };

  outputs = { self, nixpkgs, released-nixpkgs, nix-pills }:
    with import nixpkgs { system = "x86_64-linux"; };
    rec {

    checks.x86_64-linux.build = defaultPackage.x86_64-linux;

    packages.x86_64-linux = {

      packagesExplorer = import ./packages-explorer nixpkgs;

      nixosAmis = writeText "ec2-amis.json"
        (builtins.toJSON (
          import (released-nixpkgs + "/nixos/modules/virtualisation/ec2-amis.nix")));

      nixPills = import nix-pills {
        inherit pkgs;
        revCount = nix-pills.lastModifiedDate; # FIXME
        shortRev = nix-pills.shortRev;
      };

      homepage = stdenv.mkDerivation {
        name = "nixos-homepage-${self.lastModifiedDate}";

        src = self;

        enableParallelBuilding = true;

        buildInputs =
          [ libxslt
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
            entr
          ];

        preBuild = ''
          export NIX_DB_DIR=$TMPDIR
          export NIX_STATE_DIR=$TMPDIR
        '';

        makeFlags =
          [ "NIX_MANUAL_IN=${nix.doc}/share/doc/nix/manual"
            "NIXOS_MANUAL_IN=${released-nixpkgs.htmlDocs.nixosManual}"
            "NIXPKGS_MANUAL_IN=${released-nixpkgs.htmlDocs.nixpkgsManual}"
            "NIXOS_AMIS=${packages.x86_64-linux.nixosAmis}"
            "PACKAGES_EXPLORER=${packages.x86_64-linux.packagesExplorer}/bundle.js"
            "SITE_STYLES=${packages.x86_64-linux.siteStyles}"
            "NIX_PILLS_MANUAL_IN=${packages.x86_64-linux.nixPills}/share/doc/nix-pills"
          ];

        installPhase = ''
          mkdir $out
          cp -prd . $out/
        '';

        shellHook = ''
          export NIX_MANUAL_IN="${nix.doc}/share/doc/nix/manual"
          export NIXOS_MANUAL_IN="${released-nixpkgs.htmlDocs.nixosManual}"
          export NIXPKGS_MANUAL_IN="${released-nixpkgs.htmlDocs.nixpkgsManual}"
          export NIXOS_AMIS="${packages.x86_64-linux.nixosAmis}"
          export PACKAGES_EXPLORER="${packages.x86_64-linux.packagesExplorer}/bundle.js"
          # SITE_STYLES skipped by design.
          export NIX_PILLS_MANUAL_IN="${packages.x86_64-linux.nixPills}/share/doc/nix-pills"
        '';
      };

      siteStyles = callPackage ./site-styles {};

    };

    defaultPackage.x86_64-linux = packages.x86_64-linux.homepage;

    nixosConfigurations.container = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
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
                documentRoot = self.packages.x86_64-linux.homepage;
              };
            };
          })
        ];
    };

  };
}
