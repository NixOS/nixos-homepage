#! /usr/bin/env bash

set -e

dir="$1"
canonical="$2"
baseUrl="https://nixos.org/$dir/$canonical"

[[ -d $dir ]]

# loop over each channel/version
for path in $dir/*; do
  # loop over each html file
  (cd $path && find -type f -print) | while read htmlFile; do
    if [[ "$htmlFile" == *.html ]]; then
      fileName=${htmlFile#"./"}
      filePath="$path/$fileName"

      echo -n "Patching <head> of $filePath ..."
      canonicalFileName="$dir/$canonical/$fileName"
      canonicalUrl=$baseUrl
      if [ -e $canonicalFileName ]; then
        if [ "$fileName" != "index.html" ]; then
          canonicalUrl="$baseUrl/$fileName"
        fi
      fi
      canonicalTag="<link rel=\"canonical\" url=\"$canonicalUrl\" />"
      if grep -Fq "$canonicalTag" $filePath; then
        echo " Already patched!"
      else
        sed -i -e "s|</head>|  $canonicalTag\n</head>|" $filePath
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
