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
    for f in *.svg; do svgo $f; done

    # Embed svg files in svg.less
    for f in *.svg; do
      token=''${f^^}
      token=''${token//[^A-Z]/_}
      token=SVG_''${token/%_SVG/}
      substituteInPlace svg.less --replace "@$token)" "'$(cat $f)')"
      substituteInPlace svg.less --replace "@$token," "'$(cat $f)',"
    done
    )
    lessc index.less styles.css
  '';

  installPhase = ''
    mkdir -p $out
    cp styles.css $out/
  '';
}
