with import (fetchTarball channel:nixos-17.09) {};

stdenv.mkDerivation {
  name = "nixos.org-homepage";

  postHook = "unset http_proxy"; # hack for nix-shell

  buildInputs =
    [ perl
      python
      perlPackages.TemplateToolkit
      perlPackages.TemplatePluginJSONEscape
      perlPackages.TemplatePluginIOAll
      perlPackages.XMLSimple
      libxslt libxml2 imagemagick git curl
      xhtml1
      nixStable2
      gnupg
      jq
    ];
}
