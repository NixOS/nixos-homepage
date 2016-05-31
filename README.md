NixOS.org
=========

This repository contains the sources of the `nixos.org` website.  To
build it:

    $ git clone git@github.com:NixOS/nixos-homepage.git
    $ cd nixos-homepage
    $ nix-shell --command make

To make the 'packages' page work via file:///, you must unzip the
packages.json and start your browser with CORS disabled for local files:

    $ gzip -d nixpkgs/packages.json.gz
    $ mv nixpkgs/packages.json nixpkgs/packages.json.gz
    $ chromium --allow-file-access-from-files
