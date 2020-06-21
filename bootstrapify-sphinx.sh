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
        mkdir -p $(dirname $outDirTmp/$fn)
        xmlstarlet fo -H -R "$inDir/$fn" \
            | xmlstarlet ed -d "//a[@class='headerlink']" \
            | xmlstarlet sel -t -c "//div[@class='section']" \
            > "$outDirTmp/$fn.in"
        root=$(realpath --relative-to="$(pwd)" "$outDirTmp/$fn" | sed -e 's|[^/]||g' -e 's|/|../|g')
    else
        mkdir -p "$(dirname "$outDirTmp/$fn")"
        cp -f "$inDir/$fn" "$outDirTmp/$fn"
    fi
done

rm -rf "$outDir" # FIXME: not atomic
mv "$outDirTmp" "$outDir"
