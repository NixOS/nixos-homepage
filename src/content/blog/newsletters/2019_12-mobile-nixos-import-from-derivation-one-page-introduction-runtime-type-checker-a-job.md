---
title: '#12 - Mobile NixOS, import-from-derivation, one-page introduction, runtime type-checker, a job'
date: 2019-09-04
description: No act of kindness, no matter how small, is ever wasted. - Aesop
---

# News

- [One-page Nix expression language overview](https://github.com/tazjin/nix-1p)

  Vincent wrote a one-page introduction to Nix language, covering language features
  you'll most likely encounter from day one.

- [Encrypted ZFS mirror with mirrored boot on NixOS](https://elis.nu/blog/2019/08/encrypted-zfs-mirror-with-mirrored-boot-on-nixos/)

  Using the `boot.loader.grub.mirroredBoots` module to have redundant boots with an encrypted ZFS
  mirror.

- [Serokell is hiring Nix DevOps Engineers](https://www.notion.so/serokell/tl-dr-Serokell-is-hiring-Nix-DevOps-Engineers-9a33609414344f4fa167078a1a0f7896)

  Serokell is looking for remote full-time Nix SREs.

- [Yants - Yet Another Nix Type System](https://github.com/tazjin/yants)

  Yants is a small runtime type-checker for Nix that can check primitives (`int`, `string`, etc.) ,
  simple polymorphic types (`option`, `list`, `attrs`), structs/records, enums, functions and more.

  It features pattern matching for enum variants, pretty-printed function types and other niceties!
  Check out the link for screenshots.

- [NixOS RFC Process](https://nixos.mayflower.consulting/review/nixos-rfc-post/blog/2019/08/19/nixos-rfc-process/)

  Robin goes into the details of RFC process that Nix community established last year.

- [Easy IHaskell Docker Images with Nix](https://vaibhavsagar.com/blog/2019/08/11/ihaskell-nix-docker/)

  Vaibhav shows how to use Nix to package iHaskell into a docker container.

- [Mobile NixOS: the Present and the Future](https://samuel.dionne-riel.com/blog/2019/08/21/mobile-nixos-the-present-and-future.html)

  Samuel announced full-time involvement into NixOS mobile and the current
  state of the project.

- [Pre-commit git hooks with Nix](https://blog.hercules-ci.com/nix/2019/08/22/pre-commit-git-hooks-for-nix/)

  Git hooks, packaged with Nix, enforced at development time and on a CI.

- [All the versions with Nix](http://matthewbauer.us/blog/all-the-versions.html)

  Matthew explains how to use multiple revisions of nixpkgs to mix stable
  vs. bleeding edge packages.

- [Native support for import-from-derivation](https://blog.hercules-ci.com/2019/08/30/native-support-for-import-for-derivation/)

  Hercules CI gained a crucial feature for development teams. The post goes
  into the detail how evaluation and realization phases work in Nix and why
  sometimes mixing the two makes sense.

# Contribute to NixOS Weekly Newsletter

This work would not be possible without the many contributions of the community.

You can help too! Create or comment on the [pull request](https://github.com/NixOS/nixos-weekly/pulls)
for the next edition or look at the
[issue tracker](https://github.com/NixOS/nixos-weekly/issues) to add other improvements.
