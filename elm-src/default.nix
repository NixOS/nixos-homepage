{ pkgs ? import <nixpkgs> {} }:
let
  inherit (pkgs) stdenv elmPackages lib runCommand fetchzip;

  hashes = {
    "crazymykl/ex-em-elm-1.4.0" = "0qxp7kfqap4n8b2pv88v5a4j8vd0azbr1gf6bv54svycmyn2ghs0";
    "NoRedInk/elm-decode-pipeline-3.0.0" = "11dpynbv90b3yh33dvpx2c09sb6hxj6ffjq6f8a4wyf7lv2vb8nm";
    "Bogdanp/elm-querystring-1.0.0" = "0895hmaz7cmqi7k1zb61y0hmarbhzg8k5p792sm0az8myqkicjs1";
    "Bogdanp/elm-combine-3.1.1" = "0cpd50qab54hlnc1c3pf2j7j45cr3y4nhkf53p8d1w7rm7kyqssb";
    "elm-community/list-extra-6.1.0" = "082rxwicx4ndah48bv49w53fkp5dmcdgraz9z2z2lkr5fkwgcrvx";
    "elm-lang/html-2.0.0" = "08mxkcb1548fcvc1p7r3g1ycrdwmfkyma24jf72238lf7j4ps4ng";
    "elm-lang/dom-1.1.1" = "181yams19hf391dgvjxvamfxdkh49i83qfdwj9big243ljd08mpv";
    "elm-lang/core-5.1.1" = "0iww5kfxwymwj1748q0i629vyr1yjdqsx1fvymra6866gr2m3n19";
    "elm-lang/navigation-2.1.0" = "08rb6b740yxz5jpgkf5qad1raf7qqnx77hzn3bkk0s4kqyirhfcl";
    "elm-lang/http-1.0.0" = "1bhhh81ih7psvs324i5cdac5w79nc9jmykm76cmy6awfp7zhqb4b";
    "elm-lang/lazy-2.0.0" = "09439a2pkzbwvk2lfrg229jwjvc4d5dc32562q276z012bw1a2lc";
    "elm-lang/virtual-dom-2.0.4" = "1zydzzhpxivpzddnxjsjlwc18kaya1l4f8zsgs22wkq25izkin33";
  };

  fetchhash = name: version:
    let
      key = "${name}-${version}";
    in
      if builtins.hasAttr key hashes
        then hashes."${key}"
        else "0000000000000000000000000000000000000000000000000000";


  deps = lib.mapAttrs'
    (pname: version: {
      name = "${pname}/${version}";
      value = fetchzip {
        name = (builtins.replaceStrings ["/"] ["-"] "${pname}-${version}");
        url = "https://github.com/${pname}/archive/${version}.zip";
        sha256 = fetchhash pname version;
       };
     })
    (builtins.fromJSON (builtins.readFile ./elm-stuff/exact-dependencies.json));

  depCopyInstructions = builtins.concatStringsSep "\n"
    (lib.attrValues (lib.mapAttrs
      (dir: src:
        ''
          mkdir -p "$out/packages/${dir}"
          cp -r ${src}/* "$out/packages/${dir}/" # */
        ''
      )
      deps));
  elm_env = runCommand "elm_env" {}
    ''
      mkdir $out
      cp ${./elm-stuff/exact-dependencies.json} $out/exact-dependencies.json
      ${depCopyInstructions}
    '';


in
stdenv.mkDerivation {
  name = "nixos-org";
  src = lib.cleanSource ./.;

  buildInputs = (with elmPackages; [
    elm
  ]);

  buildPhase = ''
    mkdir "$out"
    rm -rf elm-stuff
    cp -r ${elm_env} elm-stuff
    chmod a+w ./elm-stuff
    elm-make ./index.elm --output "$out/options.js"
  '';

  installPhase = ''
    echo ":)"
  '';
}
