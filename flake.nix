{
  name = "nixos-homepage";

  epoch = 201906;

  description = "The nixos.org homepage";

  inputs = [ "nixpkgs" "nix" "hydra" ];

  outputs = inputs: rec {

    checks.build = defaultPackage;

    defaultPackage =
      with import inputs.nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "nixos-homepage";

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
          ];

        preHook = ''
          export NIX_DB_DIR=$TMPDIR
          export NIX_STATE_DIR=$TMPDIR
        '';

        makeFlags =
          [ "NIX_MANUAL_IN=${inputs.nix.defaultPackage}/share/doc/nix/manual"
            "NIXOS_MANUAL_IN=${inputs.nixpkgs.htmlDocs.nixosManual}"
            "NIXPKGS_MANUAL_IN=${inputs.nixpkgs.htmlDocs.nixpkgsManual}"
            "NIXOPS_MANUAL_IN=${inputs.nixpkgs.legacyPackages.nixops}/share/doc/nixops"
            "HYDRA_MANUAL_IN=${inputs.hydra.defaultPackage}/share/doc/hydra"
          ];

        installPhase = ''
          mkdir $out
          cp -prd . $out/
        '';
      };
  };
}
