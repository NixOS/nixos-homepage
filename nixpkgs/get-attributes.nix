{ lib
, package }:

let
  arguments = 
    if !(package ? _function) then { error = "some error happened"; } else
    let f = name: isOptional: if builtins.hasAttr name package.origArgs then package.origArgs.${name} else if isOptional then "(optional)" else { type = "derivation"; }; in
    lib.mapAttrs f (builtins.functionArgs package._function);
  isDerivation = x:
    if lib.isList x then lib.any isDerivation x
    else lib.isDerivation x || lib.isFunction x; 
  result = lib.filterAttrs (x: y: !isDerivation y) arguments;
in result