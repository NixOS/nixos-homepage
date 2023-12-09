---
title: "#13 - Cross compilation for Go and Rust, home-manager email support"
date: 2018-12-04
description: No act of kindness, no matter how small, is ever wasted.
---
# News

- NixOS 19.03 will leverage [multiple cores](https://github.com/NixOS/nixpkgs/pull/50440)
  automatically by default for builds and Nix 2.2 will have the sandbox
  [enabled by default](https://github.com/NixOS/nix/commit/812e39313c2bcf8909b83e1e8bc548a85dcd626c)
  on Linux

- [Deploy a C++ web app on Heroku using Docker and Nix](https://nokomprendo.frama.io/tuto_fonctionnel/posts/tuto_fonctionnel_30/2018-11-08-README.html)


- [Meson 0.48 landed in staging again](https://github.com/NixOS/nixpkgs/pull/46020#event-1973394287)

- [Declarative client mail configuration](https://github.com/rycee/home-manager/pulls?q=is%3Apr+is%3Aclosed+label%3Amail)

  In the past few months, some work went into home-manager to abstract mail configuration
  and generate configs for a variety of client-side software. Declare your username/password
  once and generate configs for afew/alot/astroid/mbsync/offlineimap.

- [Go cross-compilation](https://github.com/NixOS/nixpkgs/pull/50835) landed in staging

  This includes support for Cgo and `buildGoPackage`.
  [Rust cross-compilation](https://github.com/NixOS/nixpkgs/pull/50866) could follow soon.

- [RFC](https://github.com/NixOS/rfcs/pull/36) on improving RFC process

- [Released cachix 0.1.3](https://hackage.haskell.org/package/cachix-0.1.3/changelog)

- [Call for new stickers design for events](https://discourse.nixos.org/t/nixos-stickers-for-35c3-and-fosdem/1540)

 - [OfBorg now uses checks](https://discourse.nixos.org/t/ofborg-now-uses-checks/1558)
   for build status reports, greatly reducing Nixpkgs reviewers' email load.

# Contribute to NixOS Weekly Newsletter

This work would not be possible without the many contributions of the community.

You can help too! Create or comment on the [pull request](https://github.com/NixOS/nixos-weekly/pulls)
for the next edition or look at the
[issue tracker](https://github.com/NixOS/nixos-weekly/issues) to add other improvements.
