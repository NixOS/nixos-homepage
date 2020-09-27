(import (fetchTarball https://github.com/edolstra/flake-compat/archive/master.tar.gz) {
  src = (import <nixpkgs> {}).lib.cleanSource ./.;
}).defaultNix
