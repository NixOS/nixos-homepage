{
  name = "nixos-homepage";

  epoch = 201906;

  description = "The nixos.org homepage";

  inputs = [ "nixpkgs" "nix" "hydra" ];

  outputs = inputs:
    with import inputs.nixpkgs { system = "x86_64-linux"; };
    rec {

    checks.build = defaultPackage;

    # Generate a JSON file listing the packages in Nixpkgs.
    lib.nixpkgsToJSON = { src }: runCommand "nixpkgs-json"
      { buildInputs = [ nix jq ];
      }
      ''
        export NIX_DB_DIR=$TMPDIR
        export NIX_STATE_DIR=$TMPDIR
        echo -n '{ "commit": "unknown", "packages":' > tmp
        nix-env -f '<nixpkgs>' -I nixpkgs=${src} -qa --json --arg config 'import ${./packages-config.nix}' >> tmp
        echo -n '}' >> tmp
        mkdir $out
        < tmp sed "s|$$nixpkgs/||g" | jq -c . > $out/packages.json
        gzip -k $out/packages.json
      '';

    packages = {

      nixosOptions = (import (inputs.nixpkgs + "/nixos/release.nix") {
        inherit (inputs) nixpkgs;
      }).options;

      stablePackagesList = lib.nixpkgsToJSON {
        src = inputs.nixpkgs;
      };

      unstablePackagesList = lib.nixpkgsToJSON {
        src = inputs.nixpkgs; # FIXME
      };

      homepage = stdenv.mkDerivation {
        name = "nixos-homepage-${inputs.self.lastModified}";

        src = inputs.self;

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
            nix
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
          [ "NIX_MANUAL_IN=${inputs.nix.defaultPackage}/share/doc/nix/manual"
            "NIXOS_MANUAL_IN=${inputs.nixpkgs.htmlDocs.nixosManual}"
            "NIXPKGS_MANUAL_IN=${inputs.nixpkgs.htmlDocs.nixpkgsManual}"
            "NIXOPS_MANUAL_IN=${inputs.nixpkgs.legacyPackages.nixops}/share/doc/nixops"
            "HYDRA_MANUAL_IN=${inputs.hydra.defaultPackage}/share/doc/hydra"
            "NIXPKGS=${inputs.nixpkgs}"
            "NIXPKGS_STABLE=${packages.stablePackagesList}"
            "NIXPKGS_UNSTABLE=${packages.unstablePackagesList}"
            "NIXOS_OPTIONS=${packages.nixosOptions}/share/doc/nixos/options.json"
          ];

        installPhase = ''
          mkdir $out
          cp -prd . $out/
        '';
      };


    };

    defaultPackage = packages.homepage;

  };
}
