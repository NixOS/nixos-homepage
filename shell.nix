with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "nixos.org-homepage";

  postHook = "unset http_proxy"; # hack for nix-shell

  buildInputs =
    [ perl
      perlPackages.TemplateToolkit
      perlPackages.TemplatePluginJSONEscape
      perlPackages.TemplatePluginIOAll
      perlPackages.XMLSimple
      libxslt libxml2 imagemagick git curl
      xhtml1
    ];
}
