{
  # Ensures no aliases are in the results.
  allowAliases = false;

  # List them; the explorer will hide them as needed.
  allowUnfree = true;

  # Enable recursion into attribute sets that nix-env normally doesn't look into
  # so that we can get a more complete picture of the available packages for the
  # purposes of the index.
  packageOverrides = super: {
    haskellPackages = super.recurseIntoAttrs super.haskellPackages;
    rPackages = super.recurseIntoAttrs super.rPackages;
  };
}
