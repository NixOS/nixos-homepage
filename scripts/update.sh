#!/usr/bin/env bash

set -e

echo "Updating flake inputs..."
nix flake lock \
  --extra-experimental-features 'nix-command flakes' \
  --update-input released-nixpkgs-unstable \
  --update-input released-nixpkgs-stable \
  --update-input released-nix-unstable \
  --update-input released-nix-stable \
  --update-input nix-pills \
  --update-input nix-dev

echo "Updating blog..."
nix develop \
  --extra-experimental-features 'nix-command flakes' \
  --command update-blog --output-dir blog/
