#! /bin/sh

UPDATE=1 nix run nixpkgs#gnumake nixpkgs#curl -c make update --keep-going || true

nix flake update --update-input nixpkgsStable || true
