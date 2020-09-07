#! /bin/sh

set -e

UPDATE=1 nix shell nixpkgs#gnumake nixpkgs#curl -c make update --keep-going

nix flake update \
  --update-input released-nixpkgs-unstable \
  --update-input released-nixpkgs-stable \
  --update-input released-nix-unstable \
  --update-input released-nix-stable \
  --update-input nix-pills \
  --update-input nix-dev
