{
  edition = 201909;

  description = "The nixos.org homepage";

  inputs.nixpkgsStable.url = "nixpkgs/release-19.09";
  inputs.nixpkgsUnstable.url = "nixpkgs/master";
  inputs.nix-pills = { url = "github:NixOS/nix-pills"; flake = false; };

  outputs = { self, nixpkgsUnstable, nixpkgsStable, nix-pills }:
    with import nixpkgsStable { system = "x86_64-linux"; };
    rec {

    checks.x86_64-linux.build = defaultPackage.x86_64-linux;

    # Generate a JSON file listing the packages in Nixpkgs.
    lib.nixpkgsToJSON = { src }: runCommand "nixpkgs-json"
      { buildInputs = [ pkgs.nix jq ];
      }
      ''
        export NIX_DB_DIR=$TMPDIR
        export NIX_STATE_DIR=$TMPDIR
        echo -n '{ "commit": "${src.rev}", "packages":' > tmp
        nix-env -f '<nixpkgs>' -I nixpkgs=${src} -qa --json --arg config 'import ${./packages-config.nix}' >> tmp
        echo -n '}' >> tmp
        mkdir $out
        < tmp sed "s|$$nixpkgs/||g" | jq -c . > $out/packages.json
      '';

    packages.x86_64-linux = {

      nixosOptions = (import (nixpkgsStable + "/nixos/release.nix") {
        nixpkgs = nixpkgsStable;
      }).options;

      stablePackagesList = lib.nixpkgsToJSON {
        src = nixpkgsStable;
      };

      unstablePackagesList = lib.nixpkgsToJSON {
        src = nixpkgsUnstable;
      };

      packagesExplorer = import ./packages-explorer nixpkgsStable;

      nixosAmis = writeText "ec2-amis.json"
        (builtins.toJSON (
          import (nixpkgsStable + "/nixos/modules/virtualisation/ec2-amis.nix")));

      nixosAzureBlobs = writeText "azure-blobs.json"
        (builtins.toJSON (
          import (nixpkgsStable + "/nixos/modules/virtualisation/azure-bootstrap-blobs.nix")));

      nixosGCE = writeText "gce-images.json"
        (builtins.toJSON (
          import (nixpkgsStable + "/nixos/modules/virtualisation/gce-images.nix")));

      nixPills = import nix-pills {
        inherit pkgs;
        revCount = nix-pills.lastModified; # FIXME
        shortRev = nix-pills.shortRev;
      };

      homepage = stdenv.mkDerivation {
        name = "nixos-homepage-${self.lastModified}";

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
            "NIXOS_MANUAL_IN=${nixpkgsStable.htmlDocs.nixosManual}"
            "NIXPKGS_MANUAL_IN=${nixpkgsStable.htmlDocs.nixpkgsManual}"
            "NIXPKGS_STABLE=${packages.x86_64-linux.stablePackagesList}"
            "NIXPKGS_UNSTABLE=${packages.x86_64-linux.unstablePackagesList}"
            "NIXOS_OPTIONS=${packages.x86_64-linux.nixosOptions}/share/doc/nixos/options.json"
            "NIXOS_AMIS=${packages.x86_64-linux.nixosAmis}"
            "NIXOS_GCE=${packages.x86_64-linux.nixosGCE}"
            "NIXOS_AZURE_BLOBS=${packages.x86_64-linux.nixosAzureBlobs}"
            "PACKAGES_EXPLORER=${packages.x86_64-linux.packagesExplorer}/bundle.js"
            "NIX_PILLS_MANUAL_IN=${packages.x86_64-linux.nixPills}/share/doc/nix-pills"
          ];

        installPhase = ''
          mkdir $out
          cp -prd . $out/
        '';

        shellHook = ''
          export NIX_MANUAL_IN="${nix.doc}/share/doc/nix/manual"
          export NIXOS_MANUAL_IN="${nixpkgsStable.htmlDocs.nixosManual}"
          export NIXPKGS_MANUAL_IN="${nixpkgsStable.htmlDocs.nixpkgsManual}"
          export NIXPKGS_STABLE="${packages.x86_64-linux.stablePackagesList}"
          export NIXPKGS_UNSTABLE="${packages.x86_64-linux.unstablePackagesList}"
          export NIXOS_OPTIONS="${packages.x86_64-linux.nixosOptions}/share/doc/nixos/options.json"
          export NIXOS_AMIS="${packages.x86_64-linux.nixosAmis}"
          export NIXOS_GCE="${packages.x86_64-linux.nixosGCE}"
          export NIXOS_AZURE_BLOBS="${packages.x86_64-linux.nixosAzureBlobs}"
          export PACKAGES_EXPLORER="${packages.x86_64-linux.packagesExplorer}/bundle.js"
          export NIX_PILLS_MANUAL_IN="${packages.x86_64-linux.nixPills}/share/doc/nix-pills"
        '';
      };


    };

    defaultPackage.x86_64-linux = packages.x86_64-linux.homepage;

    nixosConfigurations.container = nixpkgsStable.lib.nixosSystem {
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
              documentRoot = self.packages.x86_64-linux.homepage;
            };
          })
        ];
    };

  };
}
