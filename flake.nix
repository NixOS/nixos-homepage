{
  name = "nixos-homepage";

  epoch = 201906;

  description = "The nixos.org homepage";

  inputs = [ "nixpkgs" ];

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
          ];

        preHook = ''
          export NIX_DB_DIR=$TMPDIR
          export NIX_STATE_DIR=$TMPDIR
        '';

        installPhase = ''
          mkdir $out
          cp -prd . $out/
        '';
      };
  };
}
