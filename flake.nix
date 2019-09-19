{
  epoch = 201909;

  description = "The nixos.org homepage";

  inputs.nixpkgsStable.uri = "nixpkgs/release-19.03";
  inputs.nixpkgsUnstable.uri = "nixpkgs/master";

  outputs = { self, nixpkgsUnstable, nixpkgsStable, nix, hydra }:
    with import nixpkgsStable { system = "x86_64-linux"; };
    rec {

    checks.build = defaultPackage;

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
        gzip -k $out/packages.json
      '';

    packages = {

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
          ];

        preBuild = ''
          export NIX_DB_DIR=$TMPDIR
          export NIX_STATE_DIR=$TMPDIR
        '';

        makeFlags =
          [ "NIX_MANUAL_IN=${nix.defaultPackage}/share/doc/nix/manual"
            "NIXOS_MANUAL_IN=${nixpkgsStable.htmlDocs.nixosManual}"
            "NIXPKGS_MANUAL_IN=${nixpkgsStable.htmlDocs.nixpkgsManual}"
            "NIXOPS_MANUAL_IN=${nixpkgsStable.legacyPackages.nixops}/share/doc/nixops"
            "HYDRA_MANUAL_IN=${hydra.defaultPackage}/share/doc/hydra"
            "NIXPKGS_STABLE=${packages.stablePackagesList}"
            "NIXPKGS_UNSTABLE=${packages.unstablePackagesList}"
            "NIXOS_OPTIONS=${packages.nixosOptions}/share/doc/nixos/options.json"
            "PACKAGES_EXPLORER=${packages.packagesExplorer}/bundle.js"
          ];

        installPhase = ''
          mkdir $out
          cp -prd . $out/
        '';
      };


    };

    defaultPackage = packages.homepage;

    nixosConfigurations.container = nixpkgsStable.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ { system.configurationRevision = self.rev;
            boot.isContainer = true;
            networking.useDHCP = false;
            networking.firewall.allowedTCPPorts = [ 80 ];
            services.httpd = {
              enable = true;
              adminAddr = "admin@example.org";
              documentRoot = self.packages.homepage;
            };
          }
        ];
    };

  };
}
