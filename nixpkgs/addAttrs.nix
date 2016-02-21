#TODO: why do I have to this here?
# (maybe this has to do with more laziness in mkDerivation?)
let config = {
  config = {
    allowBroken = true;
    allowUnfree = true;
  };
};  in
{ nixpkgs ? import ~/nixpkgs config }:

nixpkgs.overridePackages (self: super:
    let get-attribute = package: import ./get-attributes.nix { inherit (nixpkgs) lib; inherit package; };
        inherit (nixpkgs) lib;
        blacklisted = x: lib.elem x [ 
          #TODO: this blacklisting doesn't make sense...
          "_.linuxPackages_grsec_stable_server_xen.fusionio-vsl" 
          "_.linuxPackages_grsec_stable_desktop.fusionio-vsl"
          "_.linuxPackages_grsec_stable_server.fusionio-vsl"
          #"_.gdb" 
          "_.gdbGuile" 
          "_.go_1_4" 
          "_.gobjectIntrospection" 
          "_.gnu.libpthreadHeaders" 
          "_.ocamlPackages.conduit" 
          "_.ocamlPackages.re2" 
          "_.ocamlPackages.textutils"
          "_.python35Packages.pitz"
          "_.python35Packages.pygobject3"
          "_.python35Packages.pygtksourceview"
          "_.python2"
          "_.pythonPackages.python"
          "_.python27Packages.python"
          "_.python2Full"
          "_.python2Packages.python"
          "_.pythonFull"
          "_.python27Full"
          "_.python"
          "_.python27"
          "_.pythonPackages.wtforms"
          "_.python2Packages.wtforms"
          "_.python27Packages.wtforms"
          "_.python3"
          "_.python34"
          "_.python35"
          # TODO: allow most python packages
          "_.python35Packages"
          "_.shadow"
          "_.gnu.smbfs"
          "_.linuxPackages_grsec_stable_server_xen.sysdig"
          "_.linuxPackages_grsec_stable_server.sysdig"
          "_.linuxPackages_grsec_stable_desktop.sysdig"
          "_.linuxPackages_grsec_stable_server_xen.vhba"
          "_.linuxPackages_grsec_stable_desktop.vhba"
          "_.linuxPackages_grsec_stable_server.vhba"
          "_.uclibc"
          "_.gnu.unionfs"
          "_.gnome3_18.accerciser"
          "_.gnome3.accerciser"
        ];
        mapRecursively = n: x:
          if lib.isDerivation x then
            x // { meta = x.meta // { parameters = builtins.trace n (get-attribute x); }; }
          else if lib.isAttrs x then
            if x ? "recurseForDerivations" then
              lib.mapAttrs (name: value: builtins.trace name (if blacklisted "${n}.${name}" then value else mapRecursively "${n}.${name}" value)) x
            else
              x
          else if lib.isList x then
            map (mapRecursively "${n}.list") x
          else x; in
    mapRecursively "_" (nixpkgs // { recurseForDerivations = true; }))