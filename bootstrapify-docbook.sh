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

for fn in $(cd $inDir && find -type f); do
    echo "$fn"
    if [[ "$fn" =~ .html$ ]]; then
        xsltproc --nonet bootstrapify-docbook.xsl "$inDir/$fn" > "$outDirTmp/$fn.in"
        tpage --pre_chomp --post_chomp \
            --define root=`echo "$outDir/$fn" | sed -e 's|[^/]||g' -e 's|/|../|g'` \
            --pre_process=common.tt \
            > "$outDirTmp/$fn" <<EOF
[% WRAPPER layout.tt title="$title" menu='$menu' hideTitle=1 sourceLink='$source' %]

[% INSERT "$outDirTmp/$fn.in" %]

[% END %]
EOF
    else
        mkdir -p "$(dirname "$outDirTmp/$fn")"
        cp -f "$inDir/$fn" "$outDirTmp/$fn"
    fi
done

rm -rf "$outDir" # FIXME: not atomic
mv "$outDirTmp" "$outDir"
