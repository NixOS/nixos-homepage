let
  pkgs = import ./pkgs.nix;
  dir = toString ./.;
in

# Development environment.
pkgs.mkShell {
  buildInputs = with pkgs; [
    yarn2nix.yarn2nix
    nodejs-10_x
    yarn
    nix
    # For channels json file generation
    python
  ];

  shellHook = ''
    PATH="$(yarn bin):$PATH"

    serve() {
      exec webpack-dev-server "$@"
    }
  '';
}
