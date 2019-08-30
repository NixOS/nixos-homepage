let
  pkgs = import ./pkgs.nix;
  inherit (pkgs) lib;
in
pkgs.yarn2nix.mkYarnPackage {
  name = "nixos-packages-explorer";
  src = lib.cleanSource ./.;
  packageJson = ./package.json;
  yarnLock = ./yarn.lock;

  # As a frontend package, we need to override installPhase
  buildPhase = ''
    ( # Don't clobber path outside
    PATH="$(yarn bin):$PATH"
    webpack -p
    )
  '';

  # As a frontend package, we need to override installPhase
  installPhase = ''
    cp -r dist $out
  '';

  # yarn2nix doesn't support disabling distPhase through `doDist = false`.
  distPhase = ":";
}
