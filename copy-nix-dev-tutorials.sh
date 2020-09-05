#! /usr/bin/env bash

set -e

pages=(
  "tutorials/ad-hoc-developer-environments.html"
  "tutorials/building-and-running-docker-images.html"
  "tutorials/continuous-integration-github-actions.html"
  "tutorials/contributing.html"
  "tutorials/declarative-and-reproducible-developer-environments.html"
  "tutorials/dev-environment.html"
  "tutorials/install-nix.html"
  "tutorials/towards-reproducibility-pinning-nixpkgs.html"
)

outDir=$1

mkdir -p $outDir

for page in "${pages[@]}"; do
  filename="$(basename ${page%.*})"
  source="$NIX_DEV_MANUAL_IN/$page"
  target="$outDir/$filename.tt"
  echo '[% WRAPPER layout.tt title="" %]' > $target
  cat "$source" \
    | sed 's|<a class=\"headerlink\".*<\/a>||g' \
    | sed 's|<a class="reference internal" href="../glossary.html#term-attribute-name"><span class="xref std std-term">attribute name</span></a>|attribute name|g' \
    | sed 's|<a class="reference internal" href="../glossary.html#term-package-name"><span class="xref std std-term">package name</span></a>|package name|g' \
    | sed 's|<a class="reference internal" href="../glossary.html#term-reproducible"><span class="xref std std-term">reproducible</span></a>|reproducible|g' \
    | sed 's|../reference/pinning-nixpkgs.html#ref-pinning-nixpkgs|towards-reproducibility-pinning-nixpkgs.html|g' \
    | pup --pre '.section' \
      >> "$target"

  echo "[% END %]" >> $target
done
