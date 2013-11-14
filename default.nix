with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "nixos.org-homepage";

  src = ./.;

  postUnpack = ''
    # Clean up when building from a working tree.
    (cd $sourceRoot && (git ls-files -o | xargs -r rm -v))
  '';

  buildInputs = [ pkgs.perlPackages.TemplateToolkit pkgs.libxslt pkgs.libxml2 pkgs.imagemagick pkgs.git ];

  makeFlags = "catalog=${pkgs.xhtml1}/xml/dtd/xhtml1/catalog.xml";

  installPhase =
    ''
      mkdir -p $out
      cp -prvd * $out/
    '';
}
