NixOS.org
=========

This repository contains the sources of the `nixos.org` website.  To
build it:

    $ git clone git@github.com:NixOS/nixos-homepage.git
    $ cd nixos-homepage
    $ nix-shell -p python --run "cd result; python2 -m SimpleHTTPServer 8000"

then open http://127.0.0.1:8000/index.html
