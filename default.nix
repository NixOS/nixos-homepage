with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "nixos.org-homepage";

  src = if lib.inNixShell then null else ./.;

  postHook = "unset http_proxy"; # hack for nix-shell

  postUnpack = ''
    # Clean up when building from a working tree.
    (cd $sourceRoot && (git ls-files -o | xargs -r rm -v))
  '';

  buildInputs =
    [ perl
      perlPackages.TemplateToolkit
      perlPackages.TemplatePluginJSONEscape
      perlPackages.TemplatePluginIOAll
      perlPackages.XMLSimple
      libxslt libxml2 imagemagick git curl
    ];

  makeFlags = "catalog=${pkgs.xhtml1}/xml/dtd/xhtml1/catalog.xml";

  installPhase =
    ''
      mkdir -p $out
      cp -prvd * $out/
    '';
}
