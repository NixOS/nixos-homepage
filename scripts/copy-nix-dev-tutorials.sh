#! /usr/bin/env bash

set -e

pages=(
  "tutorials/install-nix.html"
  "tutorials/ad-hoc-developer-environments.html"
  "tutorials/declarative-and-reproducible-developer-environments.html"
  "tutorials/dev-environment.html"
  "tutorials/towards-reproducibility-pinning-nixpkgs.html"
  "tutorials/continuous-integration-github-actions.html"
  "tutorials/building-and-running-docker-images.html"
  "tutorials/deploying-nixos-using-terraform.html"
  "tutorials/contributing.html"
)

outDir=$1

mkdir -p $outDir
rm -f learn_guides.html.in

for page in "${pages[@]}"; do
  filename="$(basename ${page%.*})"
  source="$NIX_DEV_MANUAL_IN/$page"
  target="$outDir/$filename.tt"
  temp="$target.temp"
  title=$(xidel $source --css '#main-content h1' --printed-node-format=text | sed 's|¶||')

  echo "<li><a href=\"/$outDir/$filename.html\">$title</a></li>" >> learn_guides.html.in

  xidel $source --css '#main-content > div > div > .section > *' --printed-node-format=html \
    | sed 's|<a class=\"headerlink\".*<\/a>||g' \
    | sed 's|<a class="reference internal" href="../glossary.html#term-attribute-name"><span class="xref std std-term">attribute name</span></a>|attribute name|g' \
    | sed 's|<a class="reference internal" href="../glossary.html#term-package-name"><span class="xref std std-term">package name</span></a>|package name|g' \
    | sed 's|<a class="reference internal" href="../glossary.html#term-reproducible"><span class="xref std std-term">reproducible</span></a>|reproducible|g' \
    | sed 's|../reference/pinning-nixpkgs.html#ref-pinning-nixpkgs|towards-reproducibility-pinning-nixpkgs.html|g' \
      > "$temp"
  
  echo "[% WRAPPER atHead %] <link rel=\"canonical\" href=\"https://nix.dev/$page\" /> [% END %]" > $target

  echo "[% WRAPPER layout.tt title=\"Guides - $title\" handlesLayout=1 %]" >> $target
  echo "<div class=\"page-title\">" >> $target
  echo "  <div>" >> $target
  echo "    <a href=\"[% root%]learn.html#learn-guides\">Learn</a>" >> $target
  echo "    <span>→</span>" >> $target
  echo "  </div>" >> $target
  echo "  <h1>$title</h1>" >> $target
  echo "</div>" >> $target

  echo "<section class=\"learn-guide\">" >> $target
  sed \
    -e 's|<h1>.*</h1>||g' \
    -e 's|<span id=.*></span>||g' \
      $temp >> $target
  echo "</section>" >> $target



  printf '\n\n[%% END %%]\n' >> $target
done
