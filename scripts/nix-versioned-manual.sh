#! /usr/bin/env bash

NIX_MANUAL_OUT="manual/nix"

jq -M -r '.[] | [.version, .doc_path] | @tsv' "$1" |
  while IFS=$'\t' read -r version doc_path; do
    echo "$version" >> manual/nix.txt
    echo "$doc_path" >> manual/nix.txt
    mkdir -p "$NIX_MANUAL_OUT/$version"
    cp --no-preserve=mode,ownership -RL "$doc_path/share/doc/nix/manual"/* "$NIX_MANUAL_OUT/$version"
  done
