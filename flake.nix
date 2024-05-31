rec {
  description = "The nixos.org homepage";

  inputs = {
    # This is used to build the site.
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # These inputs are used for the manuals and release artifacts
    released-nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    released-nixpkgs-stable.url = "nixpkgs/nixos-24.05";
    released-nix-unstable.url = "github:nixos/nix/master";
    released-nix-stable.url = "github:nixos/nix/latest-release";
    nix-pills.url = "github:NixOS/nix-pills";
    nix-pills.flake = false;
  };

  nixConfig = {
    extra-substituters = [
      "https://nixos-homepage.cachix.org"
      "https://nixos-nix-install-tests.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-homepage.cachix.org-1:NHKBt7NjLcWfgkX4OR72q7LVldKJe/JOsfIWFDAn/tE="
      "nixos-nix-install-tests.cachix.org-1:Le57vOUJjOcdzLlbwmZVBuLGoDC+Xg2rQDtmIzALgFU="
    ];
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , released-nixpkgs-unstable
    , released-nixpkgs-stable
    , released-nix-unstable
    , released-nix-stable
    , nix-pills
    }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlay = final: prev: {
          asciinema-scenario = final.rustPlatform.buildRustPackage rec {
            pname = "asciinema-scenario";
            version = "0.2.0";
            src = final.fetchCrate {
              inherit pname version;
              sha256 = "sha256-qMGi+myppWBapM7TkPeXC2g/M1FA1YGwESNrx8LVXkw=";
            };
            cargoSha256 = "0z4iwjm38xfgipl1pcrkl8277p627pls565k7cclrhxfcx3f513p";
          };
        };

        pkgs = import nixpkgs { inherit system; overlays = [ overlay ]; };
        inherit (pkgs.lib) getVersion;

        pkgs-unstable = import released-nixpkgs-unstable { inherit system; };
        pkgs-stable = import released-nixpkgs-stable { inherit system; };

        nix_stable = released-nix-stable.packages."${system}".nix;
        nix_unstable = released-nix-unstable.packages."${system}".nix;

        nixPills = import nix-pills {
          inherit pkgs;
        };

        # TODO: change structure to conform to ./src/content/download/aws-ec2.yaml but in json
        NIXOS_AMIS = pkgs.writeText "ec2-amis.json"
          (builtins.toJSON (
            import (released-nixpkgs-stable + "/nixos/modules/virtualisation/ec2-amis.nix")));

        NIX_STABLE_VERSION = getVersion nix_stable.name;
        NIX_UNSTABLE_VERSION = getVersion nix_unstable.name;
        NIXOS_STABLE_SERIES = pkgs-stable.lib.trivial.release;
        NIXOS_UNSTABLE_SERIES = pkgs-unstable.lib.trivial.release;

        redirectManualHTML = redirectURL: out: ''
          cat <<EOT > ${out}
          <!DOCTYPE html>
          <html>
            <head>
              <meta http-equiv="refresh" content="1; url='${redirectURL}'"/>
            </head>
            <body>
              <h1>Redirecting...</h1>
              <p>Please follow <a href="${redirectURL}">this link</a>.</p>
            </body>
          </html>
          EOT
        '';

        manualVersionSwitch = dir: canonical:
          let
            baseUrl = "https://nixos.org/${dir}/${canonical}";
          in ''
          project=$(basename ${dir})
          # loop over each channel/version
          for path in ${dir}/*; do
            # loop over each html file
            (cd $path && find -type f -print) | while read htmlFile; do
              if [[ "$htmlFile" == *.html ]]; then
                fileName=''${htmlFile#"./"}
                filePath="$path/$fileName"
                echo "Patching $fileName"
                echo "Patching $filePath"

                canonicalFileName="${dir}/${canonical}/$fileName"
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
                  injectedTag+="{\"channel\":\"unstable\",\"version\":\"${NIX_UNSTABLE_VERSION}\"},"
                  injectedTag+="{\"channel\":\"stable\",\"version\":\"${NIX_STABLE_VERSION}\"}"
                else
                  injectedTag+="{\"channel\":\"unstable\",\"version\":\"${NIXOS_UNSTABLE_SERIES}\"},"
                  injectedTag+="{\"channel\":\"stable\",\"version\":\"${NIXOS_STABLE_SERIES}\"}"
                fi
                injectedTag+="]'"
                if ! grep -Fq "$injectedTag" $filePath; then
                  sed -i -e "s|<body|<body $injectedTag|" $filePath
                  echo "Injected list of channels in $filePath."
                fi
              fi
            done
          done
        '';

        manuals = pkgs.runCommand "manuals" { nativeBuildInputs = with pkgs; [ gnused gnugrep ]; } ''
          mkdir -p $out
          ${redirectManualHTML "/learn" "$out/index.html"}

          nix_dir=$PWD/nix && mkdir -p $nix_dir
          cp -R --no-preserve=mode,ownership ${nix_stable.doc}/share/doc/nix/manual $nix_dir/stable
          cp -R --no-preserve=mode,ownership ${nix_unstable.doc}/share/doc/nix/manual $nix_dir/unstable
          ${manualVersionSwitch "$nix_dir" "stable"}
          ${redirectManualHTML "/manual/nix/stable" "$nix_dir/index.html"}
          mv $nix_dir $out

          nixpkgs_dir=$PWD/nixpkgs && mkdir -p $nixpkgs_dir
          cp -R --no-preserve=mode,ownership ${released-nixpkgs-stable.htmlDocs.nixpkgsManual}/share/doc/nixpkgs $nixpkgs_dir/stable
          cp -R --no-preserve=mode,ownership ${released-nixpkgs-unstable.htmlDocs.nixpkgsManual}/share/doc/nixpkgs $nixpkgs_dir/unstable
          mv $nixpkgs_dir/stable/manual.html $nixpkgs_dir/stable/index.html
          mv $nixpkgs_dir/unstable/manual.html $nixpkgs_dir/unstable/index.html
          ${manualVersionSwitch "$nixpkgs_dir" "stable"}
          ${redirectManualHTML "/manual/nixpkgs/stable" "$nixpkgs_dir/index.html"}
          mv $nixpkgs_dir $out

          nixos_dir=$PWD/nixos && mkdir -p $nixos_dir
          cp -R --no-preserve=mode,ownership ${released-nixpkgs-stable.htmlDocs.nixosManual}/share/doc/nixos $nixos_dir/stable
          cp -R --no-preserve=mode,ownership ${released-nixpkgs-unstable.htmlDocs.nixosManual}/share/doc/nixos $nixos_dir/unstable
          ${manualVersionSwitch "$nixos_dir" "stable"}
          ${redirectManualHTML "/manual/nixos/stable" "$nixos_dir/index.html"}
          mv $nixos_dir $out
        '';

        pills = pkgs.runCommand "pills" {} ''
          mkdir -p $out
          cp -R ${nixPills.html-split}/share/doc/nix-pills/* $out
          cp ${nixPills.epub}/share/doc/nix-pills/nix-pills.epub $out/nix-pills.epub
        '';

        demos = pkgs.runCommand "demos" { nativeBuildInputs = with pkgs; [ asciinema-scenario gnused ]; } ''
          mkdir -p $out
          for scenario in ${./public/demos}/*.scenario; do
            scenarioFileName=$out/$(basename $scenario .scenario)
            echo "Generating $scenarioFileName.cast and $scenarioFileName.svg ..."
            asciinema-scenario --preview-file $scenarioFileName.svg $scenario > $scenarioFileName.cast
            # XXX: this in until asciinema-scenario is fixed
            #      https://github.com/garbas/asciinema-scenario/issues/3
            sed -i -e "s|<nixpkgs|\&lt;nixpkgs|g" $scenarioFileName.svg
          done
        '';

      in rec {
        packages.manuals = manuals;
        packages.pills = pills;
        packages.demos = demos;

        devShells.default = pkgs.mkShell {
          name = "nixos-homepage";

          packages = with pkgs; [
            nodejs_20
          ];

          shellHook = ''
            export NIX_STABLE_VERSION="${NIX_STABLE_VERSION}"
            export NIX_UNSTABLE_VERSION="${NIX_UNSTABLE_VERSION}"
            export NIXOS_STABLE_SERIES="${NIXOS_STABLE_SERIES}"
            export NIXOS_UNSTABLE_SERIES="${NIXOS_UNSTABLE_SERIES}"
            export NIXOS_AMIS="${NIXOS_AMIS}"

            >&2 echo ""
            >&2 echo "  To bootstrap developing environment run:"
            >&2 echo "      npm install"
            >&2 echo ""
            >&2 echo "  Afterwards, to start developing, run:"
            >&2 echo "      npm run dev"
            >&2 echo ""
            >&2 echo "  and go to the following URL in your browser:"
            >&2 echo "      http://localhost:4321"
            >&2 echo ""
            >&2 echo "  It will rebuild the website on each change."
            >&2 echo ""
          '';
        };
    });
}
