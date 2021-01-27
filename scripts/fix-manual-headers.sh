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

      canonicalFileName="$dir/$canonical/$fileName"
      canonicalUrl=$baseUrl
      if [ -e $canonicalFileName ]; then
        if [ "$fileName" != "index.html" ]; then
          canonicalUrl="$baseUrl/$fileName"
        fi
      fi
      canonicalTag="<link rel=\"canonical\" url=\"$canonicalUrl\" />"
      if ! grep -Fq "$canonicalTag" $filePath; then
        sed -i -e "s|</head>|  $canonicalTag\n</head>|" $filePath
        echo "Patched <head> of $filePath."
      fi

      injectedTag="<script src=\"/js/manual-version-switch.js\"></script>"
      if ! grep -Fq "$injectedTag" $filePath; then
        sed -i -e "s|</body>|\n  $injectedTag\n</body>|" $filePath
        echo "Injected channel switcher for $filePath."
      fi

      injectedTag="data-$project-channels='["
      if [[ "$project" == "nix" ]]; then
        injectedTag+="{\"channel\":\"unstable\",\"version\":\"$NIX_UNSTABLE_VERSION\"},"
        injectedTag+="{\"channel\":\"stable\",\"version\":\"$NIX_STABLE_VERSION\"}"
      else
        injectedTag+="{\"channel\":\"unstable\",\"version\":\"$NIXOS_UNSTABLE_SERIES\"},"
        injectedTag+="{\"channel\":\"stable\",\"version\":\"$NIXOS_STABLE_SERIES\"}"
      fi
      injectedTag+="]'"
      if ! grep -Fq "$injectedTag" $filePath; then
        sed -i -e "s|<body|<body $injectedTag|" $filePath
        echo "Injected list of channels in $filePath."
      fi
    fi
  done
done
