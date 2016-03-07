  let config = {
  config = {
    allowBroken = true;
    allowUnfree = true;
  };
};  in
{ nixpkgs ? import ./nixpkgs config }:

let inherit (nixpkgs) lib;
    forceCatch = error-handler: x:
      let result = builtins.catch "EvalError" (builtins.deepSeq x x); in
      if lib.isAttrs result && result ? type && result.type == "error" then error-handler result else result;
    get-attribute = package: import ./get-attributes.nix { inherit (nixpkgs) lib; inherit package; };
    info = x: forceCatch (x:x) {
      name = x.name;
      system = x.system;
      meta = x.meta;
      parameters = get-attribute x;
    };
    mapRecursively = n: x:
      forceCatch (error: [ ({ ${n + "(error)"} = { name = n; inherit error; meta = { longDescription = error.message; }; }; }) ])
      (if lib.isDerivation x then
        [(lib.setAttrByPath [n] (info x))]
      else if lib.isAttrs x then
        if x ? "recurseForDerivations" && x.recurseForDerivations then
            lib.concatMap (name: mapRecursively "${n}.${name}" x.${name}) (lib.attrNames x)
        else
          []
      else if lib.isList x then
        [] # map (mapRecursively "${n}.list") x
      else []); in
lib.zipAttrsWith (name: values: lib.head values)
(mapRecursively "__elim__" (nixpkgs // { recurseForDerivations = true; }))