{ stdenv, runCommandNoCC, fetchurl, lib, nodePackages }:

stdenv.mkDerivation {
  name = "nixos-homepage-styles";

  nativeBuildInputs = with nodePackages; [
    less
    svgo
  ];

  src = ./.;

  privateOutputs = [
    "community"
  ];
   
  buildPhase = ''
    echo ":: Embedding SVG files"
    (cd assets
    # Skip the source svg files
    rm -f *.src.svg

    # Optimize svg files
    for f in *.svg; do
      svgo $f &
    done 
    # Wait until all `svgo` processes are done
    # According to light testing, it is twice as fast that way.
    wait

    # Embed svg files in svg.less
    for f in *.svg; do
      token=''${f^^}
      token=''${token//[^A-Z0-9]/_}
      token=SVG_''${token/%_SVG/}
      substituteInPlace svg.less --replace "@$token)" "'$(cat $f)')"
      substituteInPlace svg.less --replace "@$token," "'$(cat $f)',"
    done
    )

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
