#! /usr/bin/env bash

set -e

inDir="$1"
outDir="$2"
title="$3"
menu="$4"
source="$5"

outDirTmp="${outDir}.tmp"
rm -rf "$outDirTmp"
mkdir -p "$outDirTmp"

[[ -d $inDir ]]

(cd $inDir && find -type f -print) | while read fn; do
    echo "$fn"
    if [[ $fn =~ epub ]]; then
        true
    elif [[ "$fn" =~ .html$ ]]; then
        xsltproc --nonet ./scripts/bootstrapify-docbook.xsl "$inDir/$fn" > "$outDirTmp/$fn.in"
        root=$(realpath --relative-to="$(pwd)" "$outDirTmp/$fn" | sed -e 's|[^/]||g' -e 's|/|../|g')
        perl $(which tpage) --pre_chomp --post_chomp \
            --define root="${root}" \
            --pre_process=common.tt \
            > "$outDirTmp/$fn" <<EOF
[% WRAPPER layout.tt title="$title" menu='$menu' hideTitle=1 sourceLink='$source' anchors=1 handlesLayout=1 %]

<section class="generic-layout docbook-page">
[% INSERT "$outDirTmp/$fn.in" %]
</section>

[% END %]
EOF
    else
        mkdir -p "$(dirname "$outDirTmp/$fn")"
        cp -f "$inDir/$fn" "$outDirTmp/$fn"
    fi
done

rm -rf "$outDir" # FIXME: not atomic
mv "$outDirTmp" "$outDir"

if [ -e "$outDir/manual.html" ]; then
  mv "$outDir/manual.html" "$outDir/index.html"
  sed -i -z \
    -e 's|pre-git\n  <\/h2>|<\/h2>|g' \
    -e 's|post-git\n  <\/h2>|<\/h2>|g' \
    "$outDir/index.html"
fi
