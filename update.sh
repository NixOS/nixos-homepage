#! /bin/sh

UPDATE=1 nix run nixpkgs#gnumake nixpkgs#curl -c make update

nix flake update --update-input nixpkgsStable --update-input nixpkgsUnstable --commit-lock-file
