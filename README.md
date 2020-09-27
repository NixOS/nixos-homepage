NixOS.org
=========

This repository contains the sources of the `nixos.org` website.

### Linux/NixOS

To build it on Linux/NixOS:

    $ git clone https://github.com/NixOS/nixos-homepage.git
    $ cd nixos-homepage
    $ nix-shell
    [nix-shell]$ make
    [nix-shell]$ python -m http.server

then open http://127.0.0.1:8000


To automatically rebuild on every change:

    [nix-shell]$ fd | entr make

To test the complete result from a nix-build:

    $ nix-build
    $ nix-shell --run 'cd result/ && python -m http.server'

### Docker Desktop for Mac

Unfortunately it will not build on macOS natively. 
But it can be build in a [Docker container on macOS](https://www.docker.com/products/docker-desktop). 
(You may need to increase the maximum "Disk image size" in Docker's Resources Preferences.)

In your favourite macOS terminal:

    $ docker run -p 8000:8000 -it --name nixos-homepage nixos/nix

Since git, fd and entr are not installed in the container:

    # nix-shell -p git fd entr

Following with the same steps as on Linux/NixOS:

    [nix-shell]$ git clone https://github.com/NixOS/nixos-homepage.git
    [nix-shell]$ cd nixos-homepage
    [nix-shell]$ nix-shell
    [nix-shell]$ make

Add the `--bind 0.0.0.0` argument to bind the web server with the container's external interface too:

    [nix-shell]$ python -m http.server --bind 0.0.0.0

Then open http://127.0.0.1:8000/index.html in your browser on macOS.

A single terminal screen is inconvenient for serious development, so you may want to set up openssh on the container to access the sources with the IDE on your Mac.
Alternatively you can set up something like [tmux](https://github.com/tmux/tmux/) to allow for multiple terminals into the container. Replace
    `# nix-shell -p git fd entr`
with
    `# nix-shell -p git fd entr tmux`
to access the latter.

## License

The content of the website is licensed under the [Creative Commons Attribution Share Alike 4.0 International](LICENSES/CC-BY-SA-4.0.txt) license.

The software (including sample code) is licensed under the [MIT](LICENSES/MIT.txt) license.

Some files might have a different license. See the files content for details.
