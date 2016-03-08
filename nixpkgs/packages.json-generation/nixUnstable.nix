let path-to-nix = builtins.fetchTarball https://github.com/fkz/nix/archive/generate-nixos-packages.tar.gz; in {
  packageOverrides = pkgs: {
    nixUnstable = pkgs.lib.overrideDerivation pkgs.nixUnstable (old: rec {
      name = "nix-${version}";
      version = builtins.readFile (path-to-nix + "/version");
      src = (import "${path-to-nix}/release.nix" {}).tarball + "/tarballs/${name}pre1234_abcdef.tar.xz";
    });
  };
}
