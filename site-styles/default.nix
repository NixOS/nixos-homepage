{ pkgs ? import <nixpkgs> {}
, nixos-common-styles
, system
}:
pkgs.stdenv.mkDerivation {
  name = "nixos-homepage-styles";

  nativeBuildInputs = with pkgs.nodePackages; [
    less
  ];

  src = ./.;

  privateOutputs = [
    "community"
  ];
   
  buildPhase = ''
    rm -rf common-styles
    ln -sf ${nixos-common-styles.defaultPackage."${system}"} ./common-styles

    rm -rf assets
    ln -sf ${nixos-common-styles.lib.memoizeAssets ./assets} ./assets

    echo ":: Building site styles"
    lessc --verbose --source-map index.less styles.css

    for p in $privateOutputs; do
      echo ":: Building page-specific styles for $p"
      lessc --verbose --source-map "pages/$p.private.less" "pages/$p.css"
    done
  '';

  installPhase = ''
    mkdir -p $out
    cp -v styles.css $out/
    cp -v styles.css.map $out/

    mkdir -v $out/pages
    for p in $privateOutputs; do
      cp -v "pages/$p.css" "$out/pages/$p.css"
    done
  '';
}
