{ pkgs ? import <nixpkgs> {} }:
with rec {
  loadNixpkgs = version:
    let
      src = builtins.fetchTarball "https://nixos.org/channels/${version}/nixexprs.tar.xz";
    in import src {};

  nixosFromNixpkgs = nixpkgs:
    import "${nixpkgs.path}/nixos";

  nixpkgsdocsFromNixpkgs = nixpkgs:
    import "${nixpkgs.path}/doc";

  latestJobsetFromHydra = { project, jobset, job }:
    let
      url = "https://hydra.nixos.org/job/${project}/${jobset}/${job}/latest.json";
      json = builtins.fetchurl { inherit url; };
      builddata = builtins.fromJSON (builtins.trace json json);
      path = builtins.path {
        path = builddata.buildoutputs.out.path;
      };
    in null;

  projectFromGitHub = { repo, branch, args, file ? "default.nix" }:
    let
      src = builtins.fetchGit {
        url = "https://github.com/nixos/${repo}.git";
        ref = branch;
      };
    in pkgs.callPackage "${src}/${file}" args;

  nixos-18-03 = loadNixpkgs "nixos-18.03";
  nixos-unstable = loadNixpkgs "nixos-unstable";


  callNix = name: command:
    pkgs.runCommand name rec {
      buildInputs = with pkgs; [ nix ];
      NIX_STORE_DIR = "/tmp/test-root/store";
      NIX_LOCALSTATE_DIR = "/tmp/test-root/var";
      NIX_LOG_DIR = "/tmp/test-root/var/log/nix";
      NIX_STATE_DIR = "/tmp/test-root/var/nix";
      NIX_CONF_DIR = "/tmp/test-root/etc";
    } command;

  package-list-stable = callNix "package-list-stable.nix"
    ''
      nix-env --readonly-mode -f '<nixpkgs>' -I nixpkgs=${nixos-18-03.path} -qa --json --arg config 'import ${./discover-more-packages-config.nix}' > $out
    '';

  package-list-unstable = callNix "package-list-unstable.nix"
    ''
      nix-env --readonly-mode -f '<nixpkgs>' -I nixpkgs=${nixos-unstable.path} -qa --json --arg config 'import ${./discover-more-packages-config.nix}' > $out
    '';
};
pkgs.runCommand "nixos.org" rec {
  src = ./.;

  buildInputs = with pkgs; [
    perl
    python
    perlPackages.TemplateToolkit
    perlPackages.TemplatePluginJSONEscape
    perlPackages.TemplatePluginIOAll
    perlPackages.XMLSimple
    libxslt libxml2 imagemagick git curl
    xhtml1
    nixStable
    gnupg
    jq
  ];

  stable_packages = package-list-stable;
  unstable_packages = package-list-unstable;
  stable_options = (import "${nixos-18-03.path}/nixos/release.nix" {}).options;

  nix_pills = projectFromGitHub {
    repo = "nix-pills";
    branch = "master";
    args = {
      revCount = 0;
      shortRev = "abc123";
    };
  };

  hydra = let
      src = builtins.fetchGit {
        url = "https://github.com/nixos/hydra.git";
        ref = "master";
      };
      imported = import "${src}/release.nix" {
        hydraSrc = src;
      };
    in imported.manual;

  nixos_manual = (nixosFromNixpkgs nixos-18-03
    {
      configuration = {
        fileSystems."/".device = "/dummy";
      };
    }).config.system.build.manual.manual;
  nixpkgs_manual = nixpkgsdocsFromNixpkgs nixos-18-03;

  commit_list = builtins.fetchurl "https://api.github.com/repos/NixOS/nixpkgs/commits";
  commit_stats = builtins.fetchurl "https://api.github.com/repos/NixOS/nixpkgs/stats/participation";
  planet = builtins.fetchurl "https://planet.nixos.org/rss20.xml";
  amis_nix = builtins.fetchurl "https://raw.github.com/NixOS/nixpkgs/master/nixos/modules/virtualisation/ec2-amis.nix";
  amis_json = builtins.toFile "amis.json" (builtins.toJSON (import amis_nix));
  azure_nix = builtins.fetchurl "https://raw.github.com/NixOS/nixpkgs/master/nixos/modules/virtualisation/azure-bootstrap-blobs.nix";
  azure_json = builtins.toFile "azure-bootstrap-blobs.json" (builtins.toJSON (import azure_nix));

}
''
  cp -r $src ./website
  chmod -R u+w ./website
  cd website

  patchShebangs .

  ln -s $nixos_manual ./nixos/manual-raw
  ln -s $nixpkgs_manual ./nixpkgs/manual-raw
  ln -s $hydra ./hydra/manual-raw
  ln -s $nix_pills/share/doc/nix-pills ./nixos/nix-pills-raw
  ln -s $commit_list nixpkgs-commits.json
  ln -s $commit_stats nixpkgs-commit-stats.json
  ln -s $planet ./blogs.xml
  ln -s $amis_nix ./nixos/amis.nix
  ln -s $amis_json ./nixos/amis.json
  ln -s $azure_nix ./nixos/azure-blobs.nix
  ln -s $azure_json ./nixos/azure-blobs.json

  (
    echo -n '{ "commit": "';
    cat ${nixos-18-03.path}/.git-revision
    echo -n '","packages":'
    cat $stable_packages
    echo -n '}'
  ) > ./nixpkgs/packages.json

  (
    echo -n '{ "commit": "';
    cat ${nixos-unstable.path}/.git-revision
    echo -n '","packages":'
    cat $unstable_packages
    echo -n '}'
  ) > ./nixpkgs/packages-unstable.json

  cp $stable_options/share/doc/nixos/options.json ./nixos/options.json
  chmod -R u+w .

  make
  cd ..
  mv ./website $out
''
