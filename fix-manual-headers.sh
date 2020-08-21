#! /usr/bin/env bash

set -e

dir="$1"
cannonical="$2"
baseUrl="https://nixos.org/$dir/$cannonical"

[[ -d $dir ]]

# loop over each channel/version
for path in $dir/*; do
  # loop over each html file
  (cd $path && find -type f -print) | while read htmlFile; do
    if [[ "$htmlFile" == *.html ]]; then
      fileName=${htmlFile#"./"}
      filePath="$path/$fileName"
      echo -n "Patching $filePath ..."
      cannonicalFileName="$dir/$cannonical/$fileName"
      cannonicalUrl=$baseUrl
      if [ -e $cannonicalFileName ]; then
        if [ "$fileName" != "index.html" ]; then
          cannonicalUrl="$baseUrl/$fileName"
        fi
      fi
      cannonicalTag="<link rel=\"cannonical\" url=\"$cannonicalUrl\" />"
      if grep -Fq "$cannonicalTag" $filePath; then
        echo " Already patched!"
      else
        sed -i -e "s|</head>|  $cannonicalTag\n</head>|" $filePath
        echo " Patched!"
      fi
    fi
  done
done
