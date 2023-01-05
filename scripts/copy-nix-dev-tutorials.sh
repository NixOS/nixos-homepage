#! /usr/bin/env bash

set -e

pages=(
  # "tutorials/install-nix.html" # Not needed since this is part of Download page
  "tutorials/nix-language.html"
  "tutorials/ad-hoc-developer-environments.html"
  "tutorials/towards-reproducibility-pinning-nixpkgs.html"
  "tutorials/declarative-and-reproducible-developer-environments.html"
  "tutorials/continuous-integration-github-actions.html"
  "tutorials/dev-environment.html"
  "tutorials/building-and-running-docker-images.html"
  "tutorials/building-bootable-iso-image.html"
  "tutorials/deploying-nixos-using-terraform.html"
  "tutorials/installing-nixos-on-a-raspberry-pi.html"
  "tutorials/integration-testing-using-virtual-machines.html"
  "tutorials/cross-compilation.html"
  "contributing/index.html"
)

outDir=$1

mkdir -p $outDir
rm -f learn_guides.html.in

for page in "${pages[@]}"; do
  filename="$(basename ${page%.*})"
  if [[ "$filename" == "index" ]]; then
    filename=$(basename "$(dirname "$page")")
  fi
  source="$NIX_DEV_MANUAL_IN/$page"
  target="$outDir/$filename.tt"
  temp="$target.temp"

  title=$(xidel $source --css '#main-content > div > div > .section > h1' --printed-node-format=text | sed 's|¶||')

  echo "<li><a href=\"/$outDir/$filename.html\">$title</a></li>" >> learn_guides.html.in

  xidel $source --css '#main-content > div > div > .section > *' --printed-node-format=xml \
    | sed 's|<a class=\"headerlink\".*<\/a>||g' \
    | sed 's|href="install-nix.html#install-nix"|href="[% root %]download.html#download-nix"|g' \
    | sed 's|<a class="reference internal" href="../glossary.html#term-attribute-name"><span class="xref std std-term">attribute name</span></a>|attribute name|g' \
    | sed 's|<a class="reference internal" href="../glossary.html#term-package-name"><span class="xref std std-term">package name</span></a>|package name|g' \
    | sed 's|<a class="reference internal" href="../glossary.html#term-reproducible"><span class="xref std std-term">reproducible</span></a>|reproducible|g' \
    | sed 's|../reference/pinning-nixpkgs.html#ref-pinning-nixpkgs|towards-reproducibility-pinning-nixpkgs.html|g' \
      > "$temp"

  echo "[% WRAPPER atHead %] <link rel=\"canonical\" href=\"https://nix.dev/$page\" /> [% END %]" > $target

  echo "[% WRAPPER layout.tt title=\"Guides - $title\" handlesLayout=1 %]" >> $target
  echo "<div class=\"page-title\">" >> $target
  echo "  <div>" >> $target
  echo "    <a href=\"[% root %]learn.html#learn-guides\">Learn</a>" >> $target
  echo "    <span>→</span>" >> $target
  echo "  </div>" >> $target
  echo "  <h1>$title</h1>" >> $target
  echo "</div>" >> $target

  echo "<section class=\"learn-guide\">" >> $target
  sed \
    -e 's|<h1>.*</h1>||g' \
    -e 's|<span id=.*></span>||g' \
      $temp >> $target
  echo "<p><a href=\"https://nix.dev/${page%.*}\">View original article on nix.dev</a></p>" >> $target
  echo "</section>" >> $target

  printf '\n\n[%% END %%]\n' >> $target

  rm $temp

done
