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

      echo -n "Patching <head> of $filePath ..."
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

      echo -n "Injecting channel switcher for $filePath ..."
      injectedTag="<script src=\"/js/manual-version-switch.js\"></script>"
      if grep -Fq "$injectedTag" $filePath; then
        echo " Already injected!"
      else
        sed -i -e "s|</body>|\n  $injectedTag\n</body>|" $filePath
        echo " Injected!"
      fi
    fi
  done
done
