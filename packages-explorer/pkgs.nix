nixpkgs: import nixpkgs {
  system = "x86_64-linux";
  overlays = [(self: super: {
    yarn2nix = import (self.fetchFromGitHub {
      owner = "moretea";
      repo = "yarn2nix";
      rev = "780e33a07fd821e09ab5b05223ddb4ca15ac663f";
      sha256 = "1f83cr9qgk95g3571ps644rvgfzv2i4i7532q8pg405s4q5ada3h";
    }) { pkgs = self; };
  })];
}
