#! /usr/bin/env bash

set -e

dir="$1"
canonical="$2"
baseUrl="https://nixos.org/$dir/$canonical"
project="$(basename $dir)"

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

      echo -n "Injecting list of channels in $filePath ..."
      injectedTag="data-$project-channels='["
      if [[ "$project" == "nix" ]]; then
        injectedTag+="{\"channel\":\"unstable\",\"version\":\"$NIX_UNSTABLE_VERSION\"},"
        injectedTag+="{\"channel\":\"stable\",\"version\":\"$NIX_STABLE_VERSION\"}"
      else
        injectedTag+="{\"channel\":\"unstable\",\"version\":\"$NIXOS_UNSTABLE_SERIES\"},"
        injectedTag+="{\"channel\":\"stable\",\"version\":\"$NIXOS_STABLE_SERIES\"}"
      fi
      injectedTag+="]'"
      if grep -Fq "$injectedTag" $filePath; then
        echo " Already injected!"
      else
        sed -i -e "s|<body|<body $injectedTag|" $filePath
        echo " Injected!"
      fi
    fi
  done
done
