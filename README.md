NixOS.org
=========

This repository contains the sources of the `nixos.org` website.  To
build it:

    $ git clone git@github.com:NixOS/nixos-homepage.git
    $ cd nixos-homepage
    $ nix-shell
    [nix-shell]$ make
    [nix-shell]$ python -m http.server

then open http://127.0.0.1:8000/index.html

To automatically rebuild on every change:

    [nix-shell]$ fd | entr make

To test the complete result from a nix-build:

    $ nix-build
    $ nix-shell --run 'cd result/ && python -m http.server'

## License

The content of the website is licensed under the [Creative Commons Attribution Share Alike 4.0 International](LICENSES/CC-BY-SA-4.0.txt) license.

The software (including sample code) is licensed under the [MIT](LICENSES/MIT.txt) license.

Some files might have a different license. See the files content for details.
