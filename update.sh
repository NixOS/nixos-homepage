#! /bin/sh

set -e

UPDATE=1 nix shell nixpkgs#gnumake nixpkgs#curl -c make update --keep-going

nix flake update \
  --update-input released-nixpkgs \
  --update-input released-nix \
  --update-input nix-pills
