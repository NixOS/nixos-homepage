{ stdenv, runCommandNoCC, fetchurl, lib, nodePackages }:

stdenv.mkDerivation {
  name = "nixos-homepage-styles";

  nativeBuildInputs = with nodePackages; [
    less
    svgo
  ];

  src = ./.;
   
  buildPhase = ''
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
    lessc --verbose --source-map index.less styles.css
  '';

  installPhase = ''
    mkdir -p $out
    cp -v styles.css $out/
    cp -v styles.css.map $out/
  '';
}
