# Enable recursion into attribute sets that nix-env normally doesn't look into
# so that we can get a more complete picture of the available packages for the
# purposes of the index.

{

  packageOverrides = super:
    builtins.foldl'
     (s: packageSet: s //
       { "${packageSet}" = super.recurseIntoAttrs super."${packageSet}"; })
     {} [
          "coqPackages"
          "haskellPackages"
          "idrisPackages"
          "nodePackages"
          "quicklispPackages"
          "rPackages"
        ];
}
